"""The language table. One entry per language the bench supports."""
from dataclasses import dataclass


@dataclass(frozen=True)
class Lang:
    id: str
    name: str
    file: str
    run: str  # the command that runs the program inside the container
    image: str = ""  # empty: the token-bench image and its run script
    entrypoint: str = ""  # used only with a custom image


LANGS: list[Lang] = [
    Lang("python", "Python", "solution.py", "python3 {file}"),
    Lang("javascript", "JavaScript", "solution.js", "node {file}"),
    Lang("typescript", "TypeScript", "solution.ts", "bun run {file}"),
    Lang("go", "Go", "solution.go", "go build -o .build/go {file} && .build/go"),
    Lang("rust", "Rust", "solution.rs", "rustc -O -o .build/rust {file} && .build/rust"),
    Lang("java", "Java", "Main.java", "javac -d .build {file} && java -cp .build Main"),
    Lang("c", "C", "solution.c", "gcc -O2 -o .build/c {file} -lm && .build/c"),
    Lang("ruby", "Ruby", "solution.rb", "ruby {file}"),
    Lang("haskell", "Haskell", "solution.hs", "ghc -O -outputdir .build -o .build/hs {file} && .build/hs"),
    Lang("perl", "Perl", "solution.pl", "perl {file}"),
    Lang("lisp", "Common Lisp", "solution.lisp", "sbcl --script {file}"),
    Lang("scheme", "Scheme", "solution.scm", "guile --no-auto-compile {file}"),
    Lang("prolog", "Prolog", "solution.pro", "swipl -q -g main -t halt {file}"),
    Lang("apl", "APL (Dyalog)", "solution.apl", "dyalogscript {file}",
         image="dyalog/dyalog:latest", entrypoint="dyalogscript"),
    Lang("bqn", "BQN", "solution.bqn", "bqn {file}"),
    Lang("k", "K", "solution.k", "k {file}"),
    Lang("forth", "Forth", "solution.fs", "gforth {file} -e bye"),
    Lang("zig", "Zig", "solution.zig", "zig build-exe {file} -O ReleaseFast -femit-bin=.build/zig && .build/zig"),
    Lang("gleam", "Gleam", "solution.gleam",
         "cp {file} /opt/gleamproj/src/solution.gleam && cd /opt/gleamproj && gleam run -m solution"),
    Lang("uiua", "Uiua", "solution.ua", "uiua run {file}",
         image="token-bench-uiua", entrypoint="uiua-run"),
]

# Languages that did not install in the image. Each entry is (id, reason).
NOT_AVAILABLE: list[tuple[str, str]] = []

_BY_ID = {l.id: l for l in LANGS}


def get_lang(lang_id: str) -> Lang:
    return _BY_ID[lang_id]
