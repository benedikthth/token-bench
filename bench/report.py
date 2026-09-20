"""Write cells.csv and summary.md for a run."""
import csv
import json
from collections import defaultdict
from pathlib import Path
from statistics import mean

from bench.cells import ROW_FIELDS

COLUMNS = [
    ("pass", None), ("rate", None), ("err", None),
    ("total tok", "total_tokens"), ("out tok", "output_tokens"),
    ("turns", "num_turns"), ("sol tok o200k", "solution_tokens_o200k"),
    ("cost $", "cost_usd"),
]
# Token and cost means use only cells whose agent run finished. A cell
# with an error (timeout, crash) has no usage data and would drag the
# mean toward zero. Solution size is available for every cell.
AGENT_KEYS = {"total_tokens", "output_tokens", "num_turns", "cost_usd"}


def load_rows(run_dir: Path) -> list[dict]:
    return [json.loads(p.read_text(encoding="utf-8"))
            for p in sorted(Path(run_dir).rglob("row.json"))]


def write_csv(rows: list[dict], path: Path) -> None:
    extra = [k for k in rows[0] if k not in ROW_FIELDS] if rows else []
    with Path(path).open("w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=ROW_FIELDS + extra, extrasaction="ignore",
                           lineterminator="\n")
        w.writeheader()
        w.writerows(rows)


def _fmt(value: float, key: str) -> str:
    if key == "cost_usd":
        return f"{value:.3f}"
    return f"{value:.0f}" if value >= 10 else f"{value:.1f}"


def summarize(rows: list[dict]) -> str:
    by_model = defaultdict(lambda: defaultdict(list))
    for r in rows:
        by_model[r["model"]][r["lang"]].append(r)
    out = ["# Token bench summary", ""]
    for model in sorted(by_model):
        out.append(f"## {model}")
        out.append("")
        out.append("| lang | " + " | ".join(c for c, _ in COLUMNS) + " |")
        out.append("|" + "---|" * (len(COLUMNS) + 1))
        langs = by_model[model]
        def _mean(rs: list[dict], key: str) -> float:
            pool = [r for r in rs if not r.get("error")] if key in AGENT_KEYS else rs
            return mean(r[key] for r in pool) if pool else 0.0

        ordered = sorted(langs, key=lambda l: _mean(langs[l], "total_tokens"))
        for lang in ordered:
            rs = langs[lang]
            n_pass = sum(1 for r in rs if r["passed"])
            n_err = sum(1 for r in rs if r.get("error"))
            cells = [f"{n_pass}/{len(rs)}", f"{100 * n_pass / len(rs):.0f}%", str(n_err)]
            for _, key in COLUMNS[3:]:
                cells.append(_fmt(_mean(rs, key), key))
            out.append(f"| {lang} | " + " | ".join(cells) + " |")
        out.append("")
    return "\n".join(out)


def write_summary(rows: list[dict], path: Path) -> None:
    Path(path).write_text(summarize(rows), encoding="utf-8", newline="\n")
