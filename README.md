# Token bench

How many tokens does an LLM coding agent spend to solve a small problem,
and does the programming language change the bill?

This repository holds the measurements. Four Claude models each solved ten
problems in up to twenty languages, inside a container, with no network.
The agent wrote the program, ran the visible tests and stopped when they
passed. Hidden tests then judged the result.

The data covers 838 cells. A cell is one model, one language and one
problem. The runs took place in September 2026.

## Layout

    cells.csv         one row per cell: the token bill, the cost and the verdict
    turns.csv         what the agent spent its turns on, per cell
    transcripts.csv   how the generated tokens split between code and prose
    solutions/        every program the agent wrote
    problems/         the ten problem statements, the visible tests and the hidden tests
    bench/            the driver that ran the bench
    docker/           the image that holds every interpreter and compiler

## cells.csv

| Column | Meaning |
| --- | --- |
| `run` | the run the cell belongs to |
| `model_id` | the exact model that did the work |
| `model` | the short model name used in the run |
| `lang` | the language the agent had to write |
| `problem` | the problem name |
| `passed` | `True` when every hidden test passed |
| `cases_passed`, `cases_total` | hidden test cases |
| `input_tokens`, `output_tokens` | tokens billed for the session |
| `cache_read_tokens`, `cache_create_tokens` | prompt cache tokens |
| `thinking_tokens` | the part of the output tokens spent on thinking |
| `total_tokens` | the four token columns added together |
| `num_turns` | agent turns. The cap was 40, and a capped cell reports 41 |
| `duration_ms` | time the agent spent |
| `cost_usd` | the cost the CLI reported, at list price |
| `solution_tokens_o200k`, `solution_tokens_cl100k` | size of the program, by tiktoken |
| `solution_bytes` | size of the program in bytes |
| `error` | empty when the cell ran to the end |
| `wall_s` | wall clock for the cell, including the container |

`turns.csv` and `transcripts.csv` join on `model`, `lang` and `problem`.

## How the runs worked

Each cell started a fresh headless session:

    claude -p --model <model> --output-format json --max-turns 40 \
      --strict-mcp-config --setting-sources "" --no-chrome \
      --allowedTools Read Write Edit Bash

The prompt template is in `bench/agent.py`. It names the language, the file
to write and the two helper scripts, and it forbids the web and any other
language. The agent had 600 seconds. Seven cells that hit that limit ran
again with 1800 seconds, and `cells.csv` carries the second result.

Every program ran inside the container in `docker/`, with `--network none`.
A test case had 120 seconds inside the container and 240 seconds outside it.

## Reproduce

1. Install Docker and the Claude Code CLI.
2. `python -m pip install tiktoken`
3. `python -m bench build-image`
4. `python -m bench run --models haiku --langs python,k --problems rle`

## What this data does not contain

- **The conversations.** The agent transcripts stay private. `turns.csv`
  and `transcripts.csv` are counts taken from them, so you can read those
  counts but you cannot re-derive them from this repository. Everything in
  `cells.csv` and `solutions/` is independent of them.
- **The CLI version.** The runs did not record it. The model ids in
  `model_id` are exact; the harness version is not.

## Read the numbers with these in mind

- **The contaminated runs.** 34 cells sit under `run` values that start
  with `contaminated/`. An earlier solution stayed in the folder, so the
  agent could see it. Drop them unless you want to study that effect.
- **A helper model.** The CLI uses a small model for side tasks. It
  produced 0.19 percent of all output tokens. The token columns include it;
  `model_id` names the model that did the work.
- **Three cells wrote nothing.** `sonnet`/`uiua` on `brackets`, `calc` and
  `primes` hit the turn cap with no file. They carry `error = no solution`
  and have no entry under `solutions/`.
- **84 cells hit the turn cap.** They report `num_turns = 41`. Their token
  bill is a floor, not the cost of a finished solution.
- **Failures are in the data.** Cells that failed still cost tokens. Keep
  them, or the token numbers will look better than they were.
- **Cost is list price.** `cost_usd` is what the CLI computed, not an
  invoice.
