# IZ4 before migration

`iz4 migrate` converted IZ4 to the Is For format on 2026-09-17. The new
file keeps only what the software is for, who it is for, and the
invariants that must remain true. Everything else it held is kept here
word for word, so nothing was lost. Move each part to wherever it now
belongs - the README, an ADR, tests or issues - or delete what no
longer matters.

## Invariant numbers

Invariants 0-4 are now the inherited foundation, so project invariants
were renumbered by adding 4:

| before | after |
|---|---|
| 1 | 5 |
| 2 | 6 |
| 3 | 7 |
| 4 | 8 |
| 5 | 9 |
| 6 | 10 |
| 7 | 11 |
| 8 | 12 |
| 9 | 13 |

## gist

dosh ("do shell") turns a plain-language request typed at the shell into a
suggested shell command. You say what you want in your own words; dosh asks
an LLM for one command that would do it, shows you that command along with
an explanation of what it does and a warning if it would change anything,
and then asks whether to run it. Nothing runs unless you say yes. It is a
way to get at the power of the shell without remembering the exact
incantation, while keeping the person at the keyboard in charge of what
actually executes.

## behaviours

- Run `dosh <request in natural language>` and dosh suggests a single shell command that fulfils the request.
- Read an explanation, in plain language, of what the suggested command does before deciding anything.
- See a warning when the suggested command would change the system rather than only report on it.
- Confirm or decline execution at a prompt; declining says so plainly and nothing is run.
- Run `dosh config` to learn how to change LLM settings and which environment variables affect dosh.
- Run `dosh prompt` to see the exact prompt template dosh sends to the LLM.
- Run `dosh help` for usage and worked examples, and `dosh version` for the installed version.
- Set DOSH_DEBUG=1 to see the prompt sent and the raw LLM response.
- Set DOSH_NO_COLOR=1 to get output without colour escape codes.
- Install dosh as a Raku command-line utility with `zef install dosh`, and choose which LLM backs it through LLM::DWIM.

## constraints

- dosh is a Raku command-line utility; it requires a Raku installation and is installed with zef.
- dosh does not talk to an LLM itself; the model, credentials and configuration come from LLM::DWIM, and dosh is unusable until that is set up.
- Interaction is one request at a time through the terminal: one request in, one command suggested, one confirmation.

## decisions

- 2026-09-12: Migrated intent from the legacy dosh-do.spoz2 (retired since/until dialect, distilled at 9.0.0) into this root SPOZ2. All six legacy invariants carry over; the legacy file is removed and its history stays in git.

## references


## Comments

    # What is this project supposed to do?
    # Humans and AI tools should treat this file as the authoritative
    # expression of intent.  Edit it directly or use `spoz2 add ...`.

