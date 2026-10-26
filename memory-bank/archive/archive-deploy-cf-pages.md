# Enhancement Archive: Deploy to Cloudflare Pages via GitHub Actions

## METADATA

| Field | Value |
|-------|-------|
| **Task ID** | `deploy-cf-pages` |
| **Name** | Deploy Cothrom site to Cloudflare Pages via GitHub Actions |
| **Complexity** | Level 2 (Enhancement) |
| **Type** | Infra / deploy pipeline |
| **Workflow** | VAN → PLAN → BUILD → REFLECT → ARCHIVE (no creative phase) |
| **Date opened** | 2026-10-26 |
| **Date completed** | 2026-10-26 |
| **Status** | **COMPLETED** — in-repo pipeline + operator go-live both verified |
| **Go-live confirmed** | 2026-10-26 (operator-reported: deployment testing done and good) |
| **Repo / branch** | `cothrom-ie/cothrom-site` · `main` |
| **Reflection** | `memory-bank/reflection/reflection-deploy-cf-pages.md` |

---

## SUMMARY

Moved the production hosting path from Docker nginx + Cloudflare Tunnel toward **Cloudflare Pages Direct Upload**, built and published by **GitHub Actions** + Wrangler (Hugo Extended 0.158.0, theme submodule, contact env overlay). In-repo deliverables: `static/_headers` (AppSec parity with `nginx.conf`), `.github/workflows/deploy-pages.yml` (secret preflight, `--commit-dirty`), and README / `.env.example` treating Pages as production and Compose as local preview.

**Operator go-live** (CF project/token, GH secrets, custom domains, www→apex Bulk Redirect, first live smoke, Tunnel cutover) was completed and reported back as **passing deployment testing** on 2026-10-26. Specific operator-side evidence (apex/www response codes, contact form env in production HTML, etc.) was not captured in-agent — see Notes.

---

## REQUIREMENTS ADDRESSED

- Production on Cloudflare Pages (Direct Upload), not Tunnel + nginx for live traffic
- CI build with Hugo Extended matching local (`0.158.0`) + `themes/no-fate` submodule
- Security headers without nginx: CSP / nosniff / frame / referrer (+ static cache) via `_headers`
- Contact form build-time env (`N8N_CONTACT_WEBHOOK_URL`, `TURNSTILE_SITE_KEY`) via Hugo `HUGO_PARAMS_*` overlay
- Apex canonical (`cothrom.ie`); www redirect via CF Bulk Redirect (operator)
- Docs: Pages = production; Compose = local; tunnel = legacy/optional

---

## IMPLEMENTATION DETAILS

### Approach

Prefer Wrangler Direct Upload from GHA over Cloudflare’s native Hugo build so Extended + submodule behaviour stays under repo control. Keep AppSec headers in `static/_headers` so Hugo copies them into `publishDir` (`site/`). Fail fast on missing CF secrets before Wrangler.

### Key components

| Component | Role |
|-----------|------|
| `static/_headers` | Pages header policy (parity with `nginx.conf`) |
| `.github/workflows/deploy-pages.yml` | Checkout + Hugo Extended + secret check + `pages deploy` |
| README / `.env.example` | Production path + operator go-live checklist + secret names |
| `cspell.config.yaml` | `peaceiris`, `wrangler` |

### Deploy command (notable flags)

```text
pages deploy site --project-name=cothrom-site --branch=main --commit-dirty=true
```

`--commit-dirty=true` is required because Hugo writes into `./site` on a clean CI checkout (uncommitted tree); Wrangler otherwise rejects the deploy.

### Files changed

- `static/_headers` — added
- `.github/workflows/deploy-pages.yml` — added
- `README.md` — Pages primary; operator checklist
- `.env.example` — GH secrets notes; tunnel demoted
- `cspell.config.yaml` — dictionary terms

---

## TESTING PERFORMED

| Criterion | Result |
|-----------|--------|
| `make build` → `site/_headers` present | **PASS** (15 pages, 0 WARN/ERROR) |
| CSP / frame / nosniff in `site/_headers` | **PASS** |
| Workflow file present | **PASS** |
| cspell on new/changed files | **PASS** |
| Live Pages deploy / apex+www smoke | **PASS** — operator-confirmed 2026-10-26 ("deployment testing is done and good") |

---

## LESSONS LEARNED

- Split **in-repo BUILD** from **operator go-live** early in Memory Bank when the last mile is credential-gated.
- Wrangler Direct Upload + Hugo `publishDir` needs `--commit-dirty` on CI.
- Opaque Wrangler auth failures → dedicated GHA secret-preflight step with actionable messages.
- Level 2 PLAN → BUILD without CREATIVE was correct (stack/docs/CI only).

---

## FUTURE CONSIDERATIONS / FOLLOW-UP

Operator go-live checklist (also in README) — **completed 2026-10-26**:

1. [x] CF API token (Pages: Edit) + Account ID
2. [x] Pages project `cothrom-site` (or first Wrangler deploy)
3. [x] GH secrets: `CLOUDFLARE_API_TOKEN`, `CLOUDFLARE_ACCOUNT_ID`, `N8N_CONTACT_WEBHOOK_URL`, `TURNSTILE_SITE_KEY`
4. [x] Push/`workflow_dispatch` → green deploy
5. [x] Custom domains `cothrom.ie` + `www.cothrom.ie`
6. [x] Bulk Redirect www → `https://cothrom.ie` (301, preserve path/query)
7. [x] Turnstile allow both hostnames
8. [x] Disable Tunnel production routes
9. [x] Smoke: apex 200, www 301, deep URL + query; contact env in production HTML

Reported by operator as "deployment testing is done and good" (2026-10-26); itemised checklist above assumed complete as a set rather than individually re-verified in-agent.

Optional remaining idea (not a blocker): PR build-only workflow (no deploy) to catch Hugo/`_headers` regressions before `main`.

---

## RELATED WORK

- Parent site delivery: `memory-bank/archive/archive-cothrom-site.md`
- Reflection: `memory-bank/reflection/reflection-deploy-cf-pages.md`
- Prior nginx AppSec: Phase 5 hardening in `archive-cothrom-site.md` / `progress.md`

---

## NOTES

Archived on **2026-10-26** at user request after REFLECT, with technology validation (first live CI deploy) initially still open. Updated same day: user confirmed **"deployment testing is done and good"** — go-live treated as complete. This confirmation was a high-level sign-off rather than a detailed report; if specific evidence (apex HTTP status, www redirect behaviour, contact form env values in production HTML) is captured later, append it here.
