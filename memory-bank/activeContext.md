# Active Context

## Mode

**IDLE** — last task **cothrom-site** archived. Ready for next task via `/van`.

## Last completed task

| Field | Value |
|-------|-------|
| **Task** | Complete Cothrom CV/Portfolio Website (Level 4) |
| **Archive** | `memory-bank/archive/archive-cothrom-site.md` |
| **Reflection** | `memory-bank/reflection/reflection-cothrom-site.md` |
| **Completed** | 2026-10-26 |

Site is buildable (`make build` → `./site`), serveable via `make serve` or `docker compose up -d nginx` (after build). Production contact still needs `.env` + n8n/Turnstile outside the repo.

## Standing site facts (carry forward)

- Hugo Extended **0.158** (`./bin/hugo`); No Fate **v0.1.0** pinned; style **`clean`** + kraft
- Theme overrides only — never edit `themes/no-fate`
- No phone/email on site; LinkedIn only
- Image uniqueness via `docs/image-register.md`
- Contact env: `N8N_CONTACT_WEBHOOK_URL`, `TURNSTILE_SITE_KEY` (see `.env.example`)
- Patterns: `memory-bank/systemPatterns.md` (leaf vs branch, `HUGO_PARAMS_*` nesting, OG override, nginx hardening)

## Creative ADRs (still valid)

| Phase | Locked summary |
|-------|----------------|
| C1 | No Fate + Hugo ≥ 0.158; kraft; system colour; n8n webhook pref |
| C2 | Home H2 panoramic + kraft plate; 3rd-person bio |
| C3 | Services S1/H1/R1/V1; `editorial` leaf bundles |
| C4 | Gallery M1 marquee; reduced-motion; native dialog |
| C5 | Contact form → n8n; Turnstile; LinkedIn + footer |

## Immediate next step

**`/van`** — initialize the next task when ready.
