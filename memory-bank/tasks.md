# Tasks

## Active Enhancements

- **deploy-cf-pages** — In-repo BUILD complete; operator go-live remaining → then `/reflect`

---

## Enhancement Details

### Deploy Cothrom site to Cloudflare Pages via GitHub Actions

| Field | Value |
|-------|-------|
| **Task ID** | `deploy-cf-pages` |
| **Complexity** | Level 2 (Enhancement) |
| **Status** | In-repo implementation complete; external go-live pending |
| **Priority** | High |
| **Created** | 2026-10-26 |
| **Repo / branch** | `cothrom-ie/cothrom-site` · `main` |

### Description

Move production hosting from Docker nginx + Cloudflare Tunnel to **Cloudflare Pages** (Direct Upload), built and deployed by **GitHub Actions** + Wrangler. Serve **both** apex (`cothrom.ie`) and `www.cothrom.ie`, with apex as the canonical host.

### Subtasks (BUILD order)

1. [x] Add `static/_headers`; verify with `make build` that `site/_headers` exists and matches policy intent
2. [x] Add `.github/workflows/deploy-pages.yml` (Hugo Extended + submodule + Wrangler)
3. [x] Update README + `.env.example` (Pages primary, apex/www, secrets)
4. [ ] Operator: CF project + secrets + custom domains + Bulk Redirect (**blocked on credentials** — checklist in README)
5. [ ] Trigger deploy; verify apex 200 + www 301 + contact env in production HTML

### Implementation notes (2026-10-26)

| Deliverable | Result |
|-------------|--------|
| `static/_headers` | AppSec parity with `nginx.conf` CSP + nosniff / frame / referrer; 7d cache on static extensions |
| `.github/workflows/deploy-pages.yml` | `main` + `workflow_dispatch`; checkout submodules; Hugo Extended 0.158.0 (`peaceiris/actions-hugo@v3`); Wrangler `pages deploy site --project-name=cothrom-site` |
| README | Pages = production; Compose = local preview; secrets + apex/www Bulk Redirect checklist |
| `.env.example` | Notes GH secrets for contact vars; tunnel = local/legacy |
| `cspell.config.yaml` | Added `peaceiris`, `wrangler` |

### Test results

| Criterion | Test | Result |
|-----------|------|--------|
| `_headers` in publish output | `make build` → `test -f site/_headers` | **PASS** (15 pages, 0 WARN/ERROR) |
| CSP / frame / nosniff present | `rg` on `site/_headers` | **PASS** |
| Workflow file present | path `.github/workflows/deploy-pages.yml` | **PASS** |
| Spell check | cspell on new/changed files | **PASS** (after dictionary update) |
| Live Pages deploy / apex+www | needs CF + GH secrets | **PENDING** (operator) |

### Commands executed

```sh
make build   # → Built → site/; site/_headers present
npx cspell … # 1 unknown (peaceiris) → dictionary updated → clean
```

### Operator go-live checklist (remaining)

1. Create CF API token (Pages: Edit) + note Account ID
2. Create Pages project `cothrom-site` (or first Wrangler deploy)
3. Set GH secrets: `CLOUDFLARE_API_TOKEN`, `CLOUDFLARE_ACCOUNT_ID`, `N8N_CONTACT_WEBHOOK_URL`, `TURNSTILE_SITE_KEY`
4. Push workflow to `main` (or `workflow_dispatch`) and confirm green deploy
5. Attach custom domains `cothrom.ie` + `www.cothrom.ie`
6. Bulk Redirect www → `https://cothrom.ie` (301, preserve path/query)
7. Turnstile allow both hostnames
8. Disable Tunnel production routes
9. Smoke-test: apex 200, www 301, deep URL redirect keeps query

### Status checklist

- [x] Initialization (VAN) complete
- [x] Planning complete
- [x] Technology stack documented
- [x] In-repo implementation complete
- [ ] Technology validation (first live/CI deploy) — operator
- [ ] Reflection
- [ ] Archive

### Progress

`[########--] ~80%` — in-repo BUILD done; go-live + reflect remain

### Creative phases

None.

---

## Completed Enhancements

- [x] cothrom-site Level 4 full site (2026-10-26) — `memory-bank/archive/archive-cothrom-site.md`
