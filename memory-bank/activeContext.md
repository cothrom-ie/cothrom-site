# Active Context

## Mode

**BUILD** — in-repo work complete; awaiting operator go-live, then **`/reflect`**

## Current task

| Field | Value |
|-------|-------|
| **Task** | Deploy to Cloudflare Pages via GitHub Actions |
| **Task ID** | `deploy-cf-pages` |
| **Complexity** | Level 2 |
| **Source of truth** | `memory-bank/tasks.md` |

## Shipped in-repo

- `.github/workflows/deploy-pages.yml`
- `static/_headers` (verified in `site/` via `make build`)
- README Deploy (Cloudflare Pages) + local Compose demoted
- `.env.example` GH-secrets notes

## Blocked / external

Cloudflare + GitHub secrets, custom domains, Bulk Redirect www→apex, first live deploy verification.

## Next

1. Operator completes go-live checklist (README / `tasks.md`)
2. **`/reflect`** when deploy verified (or reflect on in-repo delivery if go-live deferred)
