"""Command line entry: python -m bench <command>."""
import argparse
import json
import sys
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path

from bench.cells import rejudge_cell, run_cell
from bench.docker_runner import build_image
from bench.languages import LANGS
from bench.problems import PROBLEMS_DIR, load_all
from bench.report import load_rows, write_csv, write_summary
from bench.tokens import count_file

RUNS_DIR = Path("runs")


def select(items, spec: str, key):
    if spec == "all":
        return list(items)
    by_id = {key(i): i for i in items}
    picked = []
    for token in spec.split(","):
        token = token.strip()
        if token not in by_id:
            sys.exit(f"unknown id: {token}. known: {', '.join(by_id)}")
        picked.append(by_id[token])
    return picked


def parse_args(argv):
    ap = argparse.ArgumentParser(prog="bench")
    sub = ap.add_subparsers(dest="cmd", required=True)
    sub.add_parser("build-image")
    r = sub.add_parser("run")
    r.add_argument("--models", required=True, help="comma list, e.g. haiku,sonnet")
    r.add_argument("--langs", default="all")
    r.add_argument("--problems", default="all")
    r.add_argument("--workers", type=int, default=4)
    r.add_argument("--max-turns", type=int, default=40)
    r.add_argument("--timeout", type=float, default=600)
    r.add_argument("--run-id", default=None)
    s = sub.add_parser("summarize")
    s.add_argument("run_dir")
    rj = sub.add_parser("rejudge", help="re-run hidden tests on every cell of a run")
    rj.add_argument("run_dir")
    rj.add_argument("--workers", type=int, default=4)
    rj.add_argument("--only-failed", action="store_true",
                    help="re-judge only cells whose row says passed=false")
    c = sub.add_parser("count-tokens")
    c.add_argument("file")
    return ap.parse_args(argv)


def cmd_run(ns) -> None:
    models = [m.strip() for m in ns.models.split(",")]
    langs = select(LANGS, ns.langs, lambda l: l.id)
    problems = select(load_all(PROBLEMS_DIR), ns.problems, lambda p: p.id)
    run_id = ns.run_id or time.strftime("%Y%m%d-%H%M%S")
    run_dir = RUNS_DIR / run_id
    jobs = [(m, l, p) for m in models for l in langs for p in problems]
    print(f"run {run_id}: {len(jobs)} cells, {ns.workers} workers", flush=True)
    with ThreadPoolExecutor(max_workers=ns.workers) as pool:
        futures = {pool.submit(run_cell, run_dir, m, l, p, ns.max_turns, ns.timeout): (m, l, p)
                   for m, l, p in jobs}
        for fut in as_completed(futures):
            m, l, p = futures[fut]
            try:
                row = fut.result()
            except Exception as exc:  # keep the run alive
                print(f"  {m:8} {l.id:12} {p.id:10} CRASH {exc}", flush=True)
                continue
            mark = "PASS" if row["passed"] else "FAIL"
            print(f"  {m:8} {l.id:12} {p.id:10} {mark} "
                  f"tok={row['total_tokens']:>7} turns={row['num_turns']:>3} "
                  f"sol={row['solution_tokens_o200k']:>4} {row['error'][:60]}", flush=True)
    _write_reports(run_dir)


def cmd_rejudge(ns) -> None:
    run_dir = Path(ns.run_dir)
    problems = {p.id: p for p in load_all(PROBLEMS_DIR)}
    langs = {l.id: l for l in LANGS}
    jobs = []
    for row_path in sorted(run_dir.rglob("row.json")):
        model, lang_id, pid = row_path.parts[-4], row_path.parts[-3], row_path.parts[-2]
        if lang_id in langs and pid in problems:
            before = json.loads(row_path.read_text(encoding="utf-8")).get("passed")
            if ns.only_failed and before:
                continue
            jobs.append((model, langs[lang_id], problems[pid], before))
    print(f"rejudge {run_dir}: {len(jobs)} cells", flush=True)
    changed = 0
    with ThreadPoolExecutor(max_workers=ns.workers) as pool:
        futures = {pool.submit(rejudge_cell, run_dir, m, l, p): (m, l, p, b)
                   for m, l, p, b in jobs}
        for fut in as_completed(futures):
            m, l, p, before = futures[fut]
            row = fut.result()
            if row is None:
                continue
            if row["passed"] != before:
                changed += 1
                print(f"  {m:8} {l.id:12} {p.id:10} {before} -> {row['passed']}", flush=True)
    print(f"{changed} cells changed verdict", flush=True)
    _write_reports(run_dir)


def _write_reports(run_dir: Path) -> None:
    rows = load_rows(run_dir)
    write_csv(rows, run_dir / "cells.csv")
    write_summary(rows, run_dir / "summary.md")
    print((run_dir / "summary.md").read_text(encoding="utf-8"))


def main(argv=None) -> None:
    ns = parse_args(sys.argv[1:] if argv is None else argv)
    if ns.cmd == "build-image":
        build_image(Path("docker"))
    elif ns.cmd == "run":
        cmd_run(ns)
    elif ns.cmd == "summarize":
        _write_reports(Path(ns.run_dir))
    elif ns.cmd == "rejudge":
        cmd_rejudge(ns)
    elif ns.cmd == "count-tokens":
        print(count_file(Path(ns.file)))


if __name__ == "__main__":
    main()
