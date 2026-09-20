"""Prepare and run one cell: (model, language, problem)."""
import json
import shutil
import tempfile
import time
from pathlib import Path

from bench.agent import build_prompt, run_agent
from bench.docker_runner import docker_cmd, make_runner
from bench.judge import Verdict, judge
from bench.languages import Lang
from bench.problems import Problem
from bench.tokens import count_file

ROW_FIELDS = [
    "model", "lang", "problem", "passed", "cases_passed", "cases_total",
    "input_tokens", "output_tokens", "cache_read_tokens", "cache_create_tokens",
    "thinking_tokens", "total_tokens", "num_turns", "duration_ms", "cost_usd",
    "solution_tokens_o200k", "solution_tokens_cl100k", "solution_bytes",
    "error",
]

RUN_SH = """\
#!/bin/bash
# Run the program on one input: ./run.sh < tests/01.in
export MSYS_NO_PATHCONV=1
exec {cmd} "$@"
"""

TEST_SH = """\
#!/bin/bash
# Run every visible test. Print PASS or FAIL per case and a diff on failure.
export MSYS_NO_PATHCONV=1
pass=0; fail=0
for f in tests/*.in; do
  name="${{f%.in}}"
  actual="$({cmd} < "$f" 2>.stderr.txt | sed -e 's/[[:space:]]*$//')"
  expected="$(sed -e 's/[[:space:]]*$//' "$name.out")"
  if [ "$actual" == "$expected" ]; then
    pass=$((pass+1)); echo "PASS $name"
  else
    fail=$((fail+1)); echo "FAIL $name"
    diff <(echo "$expected") <(echo "$actual") | head -20
    head -c 1500 .stderr.txt
  fi
done
echo "$pass passed, $fail failed"
[ "$fail" -eq 0 ]
"""


def cell_dir(run_dir: Path, model: str, lang: Lang, problem: Problem) -> Path:
    return Path(run_dir) / model / lang.id / problem.id


def _quote(cmd: list[str]) -> str:
    return " ".join(f'"{a}"' if " " in a else a for a in cmd)


def prepare_cell(d: Path, lang: Lang, problem: Problem) -> None:
    d.mkdir(parents=True, exist_ok=True)
    (d / "PROBLEM.md").write_text(problem.statement, encoding="utf-8", newline="\n")
    tests = d / "tests"
    tests.mkdir(exist_ok=True)
    for case in problem.visible:
        (tests / f"{case.name}.in").write_text(case.stdin, encoding="utf-8", newline="\n")
        (tests / f"{case.name}.out").write_text(case.expected, encoding="utf-8", newline="\n")
    cmd = _quote(docker_cmd(lang, d))
    (d / "run.sh").write_text(RUN_SH.format(cmd=cmd), encoding="utf-8", newline="\n")
    (d / "test.sh").write_text(TEST_SH.format(cmd=cmd), encoding="utf-8", newline="\n")


def row_from(model: str, lang: Lang, problem: Problem, result: dict,
             verdict: Verdict | None, sizes: dict, solution_bytes: int,
             error: str) -> dict:
    u = result.get("usage") or {}
    inp = u.get("input_tokens", 0) or 0
    out = u.get("output_tokens", 0) or 0
    cr = u.get("cache_read_input_tokens", 0) or 0
    cc = u.get("cache_creation_input_tokens", 0) or 0
    think = (u.get("output_tokens_details") or {}).get("thinking_tokens", 0) or 0
    return {
        "model": model, "lang": lang.id, "problem": problem.id,
        "passed": bool(verdict and verdict.passed),
        "cases_passed": verdict.n_passed if verdict else 0,
        "cases_total": verdict.n_total if verdict else len(problem.hidden),
        "input_tokens": inp, "output_tokens": out,
        "cache_read_tokens": cr, "cache_create_tokens": cc,
        "thinking_tokens": think, "total_tokens": inp + out + cr + cc,
        "num_turns": result.get("num_turns", 0) or 0,
        "duration_ms": result.get("duration_ms", 0) or 0,
        "cost_usd": result.get("total_cost_usd", 0.0) or 0.0,
        "solution_tokens_o200k": sizes.get("o200k", 0),
        "solution_tokens_cl100k": sizes.get("cl100k", 0),
        "solution_bytes": solution_bytes,
        "error": error,
    }


# The agent works in a throwaway folder outside the runs tree, so it cannot
# browse other cells (other problems, other models) or the problems folder.
# The folder is copied into the run tree afterwards and deleted.
ISOLATION_ROOT = Path(tempfile.gettempdir()) / "token-bench"


def run_cell(run_dir: Path, model: str, lang: Lang, problem: Problem,
             max_turns: int, timeout: float,
             agent=run_agent, runner_factory=make_runner) -> dict:
    d = cell_dir(run_dir, model, lang, problem)
    row_path = d / "row.json"
    if row_path.exists():
        return json.loads(row_path.read_text(encoding="utf-8"))

    ISOLATION_ROOT.mkdir(parents=True, exist_ok=True)
    work = Path(tempfile.mkdtemp(prefix=f"{model}-{lang.id}-{problem.id}-", dir=ISOLATION_ROOT))
    prepare_cell(work, lang, problem)
    prompt = build_prompt(lang, problem)
    (work / "prompt.txt").write_text(prompt, encoding="utf-8", newline="\n")
    started = time.time()
    result = agent(model, work, prompt, max_turns, timeout)
    # keep everything except build artefacts, then point the scripts at the kept copy
    shutil.copytree(work, d, dirs_exist_ok=True, ignore=shutil.ignore_patterns(".build"))
    shutil.rmtree(work, ignore_errors=True)
    prepare_cell(d, lang, problem)
    (d / "result.json").write_text(json.dumps(result, indent=1), encoding="utf-8")

    solution = d / lang.file
    error = result.get("error", "") if result.get("is_error") else ""
    verdict = None
    sizes = count_file(solution)
    solution_bytes = solution.stat().st_size if solution.exists() else 0
    if not solution.exists():
        error = error or "no solution"
    else:
        verdict = judge(problem.hidden, runner_factory(lang, d))
        (d / "verdict.json").write_text(json.dumps(verdict.to_dict(), indent=1),
                                        encoding="utf-8")
    row = row_from(model, lang, problem, result, verdict, sizes, solution_bytes, error)
    row["wall_s"] = round(time.time() - started, 1)
    row_path.write_text(json.dumps(row, indent=1), encoding="utf-8")
    return row


def rejudge_cell(run_dir: Path, model: str, lang: Lang, problem: Problem,
                 runner_factory=make_runner) -> dict | None:
    """Re-run the hidden tests on an existing cell. Keep the agent numbers."""
    d = cell_dir(run_dir, model, lang, problem)
    row_path = d / "row.json"
    result_path = d / "result.json"
    solution = d / lang.file
    if not (row_path.exists() and result_path.exists() and solution.exists()):
        return None
    old = json.loads(row_path.read_text(encoding="utf-8"))
    result = json.loads(result_path.read_text(encoding="utf-8"))
    verdict = judge(problem.hidden, runner_factory(lang, d))
    (d / "verdict.json").write_text(json.dumps(verdict.to_dict(), indent=1),
                                    encoding="utf-8")
    error = result.get("error", "") if result.get("is_error") else ""
    row = row_from(model, lang, problem, result, verdict, count_file(solution),
                   solution.stat().st_size, error)
    row["wall_s"] = old.get("wall_s", 0)
    row_path.write_text(json.dumps(row, indent=1), encoding="utf-8")
    return row
