"""Load problems from problems/<id>/."""
from dataclasses import dataclass
from pathlib import Path

from bench.judge import Case

PROBLEMS_DIR = Path("problems")


@dataclass
class Problem:
    id: str
    statement: str
    visible: list[Case]
    hidden: list[Case]


def _load_cases(folder: Path) -> list[Case]:
    cases = []
    for inp in sorted(folder.glob("*.in")):
        out = inp.with_suffix(".out")
        cases.append(Case(inp.stem, inp.read_text(encoding="utf-8"),
                          out.read_text(encoding="utf-8")))
    return cases


def load_problem(root: Path, pid: str) -> Problem:
    folder = root / pid
    statement = (folder / "PROBLEM.md").read_text(encoding="utf-8")
    return Problem(pid, statement, _load_cases(folder / "tests"),
                   _load_cases(folder / "hidden"))


def load_all(root: Path) -> list[Problem]:
    ids = sorted(p.name for p in root.iterdir()
                 if (p / "PROBLEM.md").exists())
    return [load_problem(root, pid) for pid in ids]
