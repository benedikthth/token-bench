"""Run one program input inside the token-bench Docker image."""
import subprocess
import uuid
from pathlib import Path

from bench.judge import Runner
from bench.languages import Lang

IMAGE = "token-bench"
# Hard limit, in seconds, for one program run inside the container. The
# token-bench run script applies it itself. A custom image gets it through
# a `timeout` entrypoint. A program that loops forever is killed inside
# the container, so the container exits and is removed.
RUN_TIMEOUT = 120
MEMORY = "1g"


def docker_cmd(lang: Lang, cell_dir: Path, name: str | None = None) -> list[str]:
    mount = f"{Path(cell_dir).resolve().as_posix()}:/work"
    base = ["docker", "run", "--rm", "-i", "--network", "none", "--memory", MEMORY]
    if name:
        base += ["--name", name]
    if lang.image:
        return base + ["--entrypoint", "timeout", "-v", mount, lang.image,
                       "-s", "KILL", str(RUN_TIMEOUT), lang.entrypoint,
                       f"/work/{lang.file}"]
    return base + ["-v", mount, IMAGE, "run", lang.id, lang.file]


def make_runner(lang: Lang, cell_dir: Path, timeout: float = 240) -> Runner:
    # 240 s on the client side: the in-container limit is 120 s, and a
    # loaded host can make Docker start-up (Dyalog above all) slow.

    def run(stdin: str) -> tuple[str, str, int]:
        # Two attempts: a client-side timeout is almost always Docker Desktop
        # stalling under host load, not the program, which has its own
        # in-container limit. Killing the client does not stop the container,
        # so kill it by name before trying again.
        for attempt in (1, 2):
            name = f"bench-{uuid.uuid4().hex[:12]}"
            cmd = docker_cmd(lang, cell_dir, name=name)
            try:
                p = subprocess.run(cmd, input=stdin.encode("utf-8"),
                                   capture_output=True, timeout=timeout)
            except subprocess.TimeoutExpired:
                subprocess.run(["docker", "kill", name], capture_output=True)
                if attempt == 2:
                    return "", f"timeout after {timeout}s, twice", -2
                continue
            return (p.stdout.decode("utf-8", "replace"),
                    p.stderr.decode("utf-8", "replace"), p.returncode)

    return run


def build_image(context: Path) -> None:
    subprocess.run(["docker", "build", "-t", IMAGE, str(context)], check=True)
