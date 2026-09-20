"""Count tokens of a solution with local tokenizers."""
from functools import lru_cache
from pathlib import Path

import tiktoken

ENCODINGS = {"o200k": "o200k_base", "cl100k": "cl100k_base"}


@lru_cache(maxsize=None)
def _enc(name: str):
    return tiktoken.get_encoding(name)


def count_tokens(text: str) -> dict[str, int]:
    return {key: len(_enc(name).encode(text, disallowed_special=()))
            for key, name in ENCODINGS.items()}


def count_file(path: Path) -> dict[str, int]:
    if not path.exists():
        return {key: 0 for key in ENCODINGS}
    return count_tokens(path.read_text(encoding="utf-8", errors="replace"))
