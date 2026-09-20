"""Compare program output with expected output."""
from dataclasses import dataclass, field, asdict
from typing import Callable

Runner = Callable[[str], tuple[str, str, int]]


@dataclass(frozen=True)
class Case:
    name: str
    stdin: str
    expected: str


@dataclass
class CaseResult:
    name: str
    passed: bool
    expected: str
    actual: str
    stderr: str
    returncode: int


@dataclass
class Verdict:
    passed: bool
    n_passed: int
    n_total: int
    cases: list[CaseResult] = field(default_factory=list)

    def to_dict(self) -> dict:
        return asdict(self)


def normalize(text: str) -> str:
    lines = [line.rstrip() for line in text.replace("\r\n", "\n").split("\n")]
    while lines and lines[-1] == "":
        lines.pop()
    return "\n".join(lines)


def judge(cases: list[Case], runner: Runner) -> Verdict:
    results: list[CaseResult] = []
    for case in cases:
        try:
            out, err, rc = runner(case.stdin)
        except Exception as exc:  # a runner failure is a failed case
            out, err, rc = "", f"runner error: {exc}", -1
        actual = normalize(out)
        expected = normalize(case.expected)
        # Only stdout counts. The visible test.sh ignores the exit code, so
        # the hidden judge must do the same.
        results.append(CaseResult(case.name, actual == expected,
                                  expected, actual, err[-2000:], rc))
    n_passed = sum(r.passed for r in results)
    return Verdict(n_passed == len(results) and len(results) > 0,
                   n_passed, len(results), results)
