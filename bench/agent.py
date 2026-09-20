"""Build the prompt and run one headless claude -p session."""
import json
import shutil
import subprocess
from pathlib import Path

from bench.languages import Lang
from bench.problems import Problem

PROMPT = """\
You are solving a small programming problem in {name}.

Write the complete program to the file `{file}` in the current folder.
The program reads standard input and writes standard output.

Inside a Linux container the program runs with this command:

    {run}

Two helper scripts are in the current folder:

- `./test.sh` runs every visible test in `tests/` and prints a diff for
  each failure.
- `./run.sh < tests/01.in` runs the program on one input file.

Rules:

- Write the program only in {name}. Do not use another language for any
  part of the solution.
- Write or change only the file `{file}`.
- Do not read or use any file outside the current folder.
- Do not use the web.
- Stop as soon as `./test.sh` reports that every test passes. Hidden
  tests will also run later, so solve the general problem, not only the
  visible cases.

The problem:

{statement}
"""

EMPTY_USAGE = {"input_tokens": 0, "output_tokens": 0,
               "cache_read_input_tokens": 0, "cache_creation_input_tokens": 0,
               "output_tokens_details": {"thinking_tokens": 0}}


def build_prompt(lang: Lang, problem: Problem) -> str:
    return PROMPT.format(name=lang.name, file=lang.file,
                         run=lang.run.format(file=lang.file),
                         statement=problem.statement.rstrip())


def claude_cmd(model: str, max_turns: int) -> list[str]:
    exe = shutil.which("claude") or "claude"
    return [exe, "-p", "--model", model, "--output-format", "json",
            "--max-turns", str(max_turns),
            "--strict-mcp-config", "--setting-sources", "",
            "--no-chrome",
            "--allowedTools", "Read", "Write", "Edit", "Bash"]


def _failure(text: str) -> dict:
    return {"is_error": True, "error": text, "usage": dict(EMPTY_USAGE),
            "num_turns": 0, "duration_ms": 0, "total_cost_usd": 0.0}


def parse_result(text: str) -> dict:
    try:
        d = json.loads(text)
    except json.JSONDecodeError as exc:
        return _failure(f"not json: {exc}: {text[:300]}")
    if not isinstance(d, dict):
        return _failure(f"unexpected json shape: {text[:300]}")
    d.setdefault("usage", dict(EMPTY_USAGE))
    d.setdefault("is_error", False)
    d.setdefault("error", "")
    return d


def run_agent(model: str, cell_dir: Path, prompt: str,
              max_turns: int = 40, timeout: float = 600) -> dict:
    cmd = claude_cmd(model, max_turns)
    try:
        p = subprocess.run(cmd, input=prompt.encode("utf-8"), cwd=str(cell_dir),
                           capture_output=True, timeout=timeout)
    except subprocess.TimeoutExpired:
        return _failure(f"timeout after {timeout}s")
    except OSError as exc:
        return _failure(f"cannot start claude: {exc}")
    out = p.stdout.decode("utf-8", "replace")
    if p.returncode != 0 and not out.strip().startswith("{"):
        return _failure(f"exit {p.returncode}: {p.stderr.decode('utf-8', 'replace')[-500:]}")
    return parse_result(out)
