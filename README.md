# Token bench

How many tokens does an LLM coding agent spend to solve a small problem,
and does the programming language change the bill?

This repository holds the measurements. Four Claude models each solved ten
problems in up to twenty languages, inside a container, with no network.
The agent wrote the program, ran the visible tests and stopped when they
passed. Hidden tests then judged the result.

The data covers 838 cells. A cell is one model, one language and one
problem.

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
| `input_tokens`, `output_tokens` | tokens billed for the main agent loop |
| `cache_read_tokens`, `cache_create_tokens` | prompt cache tokens |
| `thinking_tokens` | the part of the output tokens spent on thinking |
| `total_tokens` | the four token columns added together |
| `num_turns` | agent turns. The cap was 40, and a capped cell reports 41 |
| `duration_ms` | time the agent spent |
| `cost_usd` | the cost the CLI reported, at list price. It covers the whole session |
| `solution_tokens_o200k`, `solution_tokens_cl100k` | size of the program, by tiktoken |
| `solution_bytes` | size of the program in bytes. **Not characters.** See the warning below |
| `solution_chars` | size of the program in characters |
| `ct_haiku`, `ct_sonnet`, `ct_opus`, `ct_fable` | size of the program in each model's own tokens, from Anthropic's `count_tokens` endpoint. Empty for a cell that wrote no passing program |
| `ct_own` | the count under the model that wrote the program |
| `error` | empty when the cell ran to the end |
| `wall_s` | wall clock for the cell, including the container |

`turns.csv` and `transcripts.csv` join on `model`, `lang` and `problem`.

### Warning: measure programs with `solution_chars`, not `solution_bytes`

APL, BQN and Uiua write glyphs. One glyph takes several bytes in UTF-8, so
`solution_bytes` runs 1.3 to 1.4 times above the character count for those
three languages, and exactly equals it for the other seventeen. Divide
`solution_bytes` by a token count and the three densest languages look
about a third less dense than they are.

### Warning: `solution_tokens_o200k` is not Claude's tokenizer

`solution_tokens_o200k` and `solution_tokens_cl100k` come from tiktoken.
They undercount Claude by about 31 percent on this code. Use the `ct_`
columns for any ratio against the token bill, because the bill is in
Claude's tokens. Sonnet 5, Opus 5 and Fable 5.1 share one tokenizer and
give identical counts. Haiku 4.5 uses an older one that returns about
16 percent fewer tokens for the same text.

## Reproduce a published figure

Select the 800 core cells first:

    run does not start with "contaminated/" and does not end with "-forth"

That subset holds 800 rows and 727 passing programs. The 34 contaminated
cells and the 4 `-forth` re-runs sit outside it.

Then:

| To get | Use |
| --- | --- |
| turn counts per language | `num_turns` from `cells.csv`, not `turns.csv` |
| program size against the token bill | a `ct_` column, never `solution_tokens_o200k` |
| characters per token | `solution_chars` divided by `ct_opus` |
| fresh tokens | `total_tokens` minus `cache_read_tokens` |
| the floor per model | the smallest fresh-token run that model managed |
| a figure that excludes "the esoterics" | drop `apl`, `bqn`, `k`, `uiua`, `forth`, `gleam` and `zig` |

`turns.csv` covers 791 of the 800 core cells. It misses the seven cells
that ran again after a timeout and the cells that wrote no program, so its
means for Forth, Gleam and Uiua sit below the `cells.csv` means. Use
`cells.csv` for turn counts and `turns.csv` only for the tool-call split.

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
- **A side call in every session.** The CLI makes one small Haiku call per
  session, in all 808 sessions, whatever the main model is. It takes about
  1180 input tokens and returns about 13 output tokens. The token columns
  **exclude** it, because the CLI reports it outside the usage block.
  `cost_usd` **includes** it, so the cost columns carry about 0.44 percent
  more than the token columns account for.
- **Three cells spawned a subagent.** The agent had no Task tool, but three
  haiku cells spawned one anyway. Their subagent tokens sit outside the
  usage block, so the token columns understate those three rows badly:

  | Cell | Subagent | Output tokens missing | Cache reads missing |
  | --- | --- | --- | --- |
  | `gleam-1` haiku/gleam/lcs | general-purpose | 8,711 | 538,871 |
  | `uiua-1` haiku/uiua/brackets | Explore | 21,967 | 1,344,958 |
  | `uiua-1` haiku/uiua/calc | Explore | 2,927 | 54,587 |

  `cost_usd` for those three rows does include the subagent. Drop the three
  rows, or take their tokens as a floor.
- **Three cells wrote nothing.** `sonnet`/`uiua` on `brackets`, `calc` and
  `primes` hit the turn cap with no file. They carry `error = no solution`
  and have no entry under `solutions/`.
- **84 cells hit the turn cap.** They report `num_turns = 41`. Their token
  bill is a floor, not the cost of a finished solution.
- **Failures are in the data.** Cells that failed still cost tokens. Keep
  them, or the token numbers will look better than they were.
- **Cost is list price.** `cost_usd` is what the CLI computed, not an
  invoice.
