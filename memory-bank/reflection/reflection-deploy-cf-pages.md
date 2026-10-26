# Level 2 Enhancement Reflection: Deploy to Cloudflare Pages

**Task ID:** `deploy-cf-pages`  
**Complexity:** Level 2 (Enhancement)  
**Date:** 2026-10-26  
**Scope reflected:** In-repo BUILD (workflow, `_headers`, docs) — operator go-live still pending  
**Workflow:** VAN → PLAN → BUILD → REFLECT (no creative phase)

---

## Enhancement Summary

Moved the production hosting path from Docker nginx + Cloudflare Tunnel toward **Cloudflare Pages Direct Upload**, driven by a GitHub Actions workflow (Hugo Extended 0.158.0 + Wrangler). In-repo deliverables: `static/_headers` with AppSec parity to `nginx.conf`, `.github/workflows/deploy-pages.yml` (submodules, contact env overlay, secret preflight, `--commit-dirty`), and README / `.env.example` updates treating Pages as production and Compose as local preview. Live CF project, secrets, custom domains, and www→apex Bulk Redirect remain operator steps.

---

## What Went Well

- **AppSec continuity without nginx:** `static/_headers` carries CSP / nosniff / frame / referrer and static-asset cache policy into Pages; verified with `make build` that Hugo copies `_headers` into `site/`.
- **Fail-fast CI UX:** Dedicated “Check Cloudflare secrets” step surfaces empty `CLOUDFLARE_API_TOKEN` / `CLOUDFLARE_ACCOUNT_ID` with actionable messages instead of Wrangler’s opaque exit code 1.
- **Contact env contract preserved:** Workflow sets `HUGO_PARAMS_CONTACT_WEBHOOKURL` and `HUGO_PARAMS_CONTACT_TURNSTILESITEKEY` from GH secrets — same single-word param keys already documented for the Hugo underscore-nesting gotcha.
- **Docs demotion of Tunnel:** README clearly states Pages = production, Compose nginx = local preview, tunnel = optional/legacy; operator go-live checklist is explicit and ordered.

---

## Challenges Encountered

- **Dirty publish dir on CI:** Hugo writes into `./site` on a clean checkout, so Wrangler rejected deploy as dirty working tree.
- **Credential-gated verification:** First live Pages deploy, apex/www behaviour, and Tunnel cutover cannot be proven in-agent without CF/GH credentials.
- **Scope boundary:** Full “production cutover” vs “in-repo pipeline ready” — reflection/archive timing depends on whether go-live is deferred.

---

## Solutions Applied

- Added `--commit-dirty=true` (and `--branch=main`) to `pages deploy` so Hugo’s uncommitted `site/` output is accepted on Direct Upload.
- Documented operator checklist in README + `tasks.md`; treated in-repo BUILD as complete with go-live as an explicit remaining gate.
- Reflected on in-repo delivery now (per activeContext option) while keeping go-live items as next steps rather than fake “done.”

---

## Key Technical Insights

- Cloudflare Pages Direct Upload via Wrangler on GitHub Actions is a better fit for this Hugo submodule workflow than “connect repo and hope CF’s Hugo build matches Extended + submodule needs.”
- `_headers` at the static root is the right place for security headers when leaving nginx; keep CSP in sync with Turnstile’s real external origin.
- Wrangler’s “create project on first successful deploy” behaviour means the first green run both creates `cothrom-site` and publishes — secret preflight before that step saves a confusing failure mode.

---

## Process Insights

- For infra enhancements that end in vendor credentials, split **in-repo BUILD** from **operator go-live** in `tasks.md` early so Memory Bank progress % and reflect timing stay honest.
- Level 2 PLAN → BUILD without CREATIVE was correct: no design tradeoffs, only stack/docs/CI choices.
- Keep operator checklists in README (human) and mirror status in Memory Bank (agent), not only in one place.

---

## Action Items for Future Work

1. **Operator:** Complete go-live checklist (CF token/account, GH secrets, first deploy, custom domains, Bulk Redirect www→apex, Turnstile hosts, disable Tunnel, smoke-test).
2. After first green deploy: confirm contact form env appears in production HTML; update archive with live verification evidence.
3. Optional follow-up: consider a lightweight workflow that builds-only (no deploy) on PRs so Hugo/`_headers` regressions catch before `main`.

---

## Time Estimation Accuracy

- **Estimated:** Half-day Level 2 enhancement (workflow + headers + docs).
- **Actual:** Same calendar day (2026-10-26); iteration on Wrangler flags and secret-check step after initial workflow land.
- **Variance:** Modest overrun on deploy-command edge cases (`--commit-dirty`, secret preflight) — expected for first-time Pages Direct Upload wiring.
- **Reason:** External go-live blocked; in-repo work finished within a reasonable Level 2 band once dirty-tree behaviour was understood.

---

## Reflection vs plan

| Plan item | Outcome |
|-----------|---------|
| `_headers` + build verify | Done |
| GHA Hugo Extended + submodule + Wrangler | Done |
| README + `.env.example` | Done |
| CF project / secrets / domains / redirect | Pending operator |
| Live smoke (apex 200, www 301) | Pending operator |

No creative-phase deviations (none required).

---

## Next Steps

- Operator executes go-live checklist.
- Then `/archive` for `deploy-cf-pages` (include live verify notes if available).
- Mark technology validation complete in `tasks.md` when first CI deploy is green.
