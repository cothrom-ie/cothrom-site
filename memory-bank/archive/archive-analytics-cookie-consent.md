# Enhancement Archive: analytics-cookie-consent

## METADATA

| Field | Value |
|-------|-------|
| **Task ID** | `analytics-cookie-consent` |
| **Name** | Wire CF Web Analytics + privacy disclosure |
| **Complexity** | Level 2 (Simple Enhancement) |
| **Type** | Metrics / privacy / AppSec CSP |
| **Workflow** | VAN → PLAN → BUILD → REFLECT → ARCHIVE (no creative phase) |
| **Date opened** | 2026-11-05 |
| **Date completed** | 2026-11-05 |
| **Status** | **COMPLETED** (in-repo) — operator token/secret still open |
| **Reflection** | `memory-bank/reflection/reflection-analytics-cookie-consent.md` |

---

## SUMMARY

Wired production site metrics with **Cloudflare Web Analytics** (manual cookieless `beacon.min.js` embed) and appropriate privacy disclosure for `cothrom.ie`. Consent surface is a `/privacy/` page + footer link (Turnstile + analytics + contact form), not a CMP. Google Analytics was rejected to avoid cookie-gated Level 3 scope.

Token flows: `CF_WEB_ANALYTICS_TOKEN` → Makefile/CI → `HUGO_PARAMS_ANALYTICS_CFTOKEN` → `params.analytics.cftoken`. Beacon emits only when production **and** token set. CSP in `static/_headers` allows insights script/connect hosts alongside Turnstile.

---

## REQUIREMENTS ADDRESSED

1. Production metrics beacon when token configured
2. Dev/local omit beacon when not production or token empty
3. CSP allows beacon without dropping Turnstile rules
4. Privacy disclosure + footer link
5. No GA, no CMP, no secrets in git
6. README + `.env.example` + CI document the env contract

---

## IMPLEMENTATION DETAILS

### Approach

Reuse Contact’s build-time env overlay pattern. Prefer manual CF beacon over dashboard auto-inject so CSP and HTML stay repo-owned. Treat “cookie acceptance” as disclosure for a cookieless analytics stack.

### Key files

| Path | Change |
|------|--------|
| `hugo.toml` | `[params.analytics] cftoken = ""` |
| `makefile` | Map `CF_WEB_ANALYTICS_TOKEN` → `HUGO_PARAMS_ANALYTICS_CFTOKEN` |
| `.github/workflows/deploy-pages.yml` | Inject analytics secret; assert `site/privacy/index.html` |
| `layouts/_partials/hooks/head-end.html` | Production beacon via `jsonify` token dict |
| `static/_headers` | CSP: `static.cloudflareinsights.com` + `cloudflareinsights.com` |
| `content/privacy/_index.md` | Privacy disclosure page |
| `layouts/_partials/footer.html` | Privacy link |
| `.env.example` | Restored + analytics token placeholder |
| `README.md` | Env table, secrets, Web Analytics setup |
| `cspell.config.yaml` | `cftoken`, `CFTOKEN`, `cloudflareinsights` |

### Beacon contract

```html
<script defer src="https://static.cloudflareinsights.com/beacon.min.js"
  data-cf-beacon='{"token":"…"}'></script>
```

Gates: `hugo.IsProduction` ∧ non-empty `site.Params.analytics.cftoken`.

---

## TESTING PERFORMED

| Criterion | Result |
|-----------|--------|
| `hugo config` binds `params.analytics.cftoken` from env | **PASS** |
| `make build` without token → no beacon in HTML | **PASS** |
| Build with token → beacon + token in head | **PASS** |
| `site/_headers` CSP insights + Turnstile hosts | **PASS** |
| `/privacy/` content + footer `/privacy/` link | **PASS** |
| Live prod beacon after real secret | **PENDING** (operator) |

---

## LESSONS LEARNED

- Lock metrics **provider + consent scope** in VAN/PLAN; CF vs GA decides Level 2 vs 3.
- Manual CF beacon CSP needs **both** script and connect hosts (`cloudflareinsights.com` for manual RUM).
- Reuse unbroken `HUGO_PARAMS_*` leaf keys (`cftoken`) — same gotcha as Contact.
- Split in-repo complete from credential-gated go-live (same as `deploy-cf-pages`).
- Privacy copy must not overclaim “no cookies” while Turnstile may set security cookies.

---

## FUTURE CONSIDERATIONS / FOLLOW-UP

Operator (outside repo):

1. [ ] Cloudflare Dashboard → Web Analytics for `cothrom.ie`; copy site token
2. [ ] GitHub Actions secret `CF_WEB_ANALYTICS_TOKEN`
3. [ ] Redeploy / push `main`; confirm `beacon.min.js` in production (or note adblock)
4. [ ] Optional polish: suppress RSS chrome on Privacy section template

If GA4 is ever required: new Level 3 task with CMP + gated scripts — do not extend this disclosure-only model.

---

## RELATED WORK

- Reflection: `memory-bank/reflection/reflection-analytics-cookie-consent.md`
- Prior deploy path: `memory-bank/archive/archive-deploy-cf-pages.md`
- Contact env pattern / Turnstile: `memory-bank/archive/archive-cothrom-site.md`, `systemPatterns.md` Hugo underscore gotcha

---

## NOTES

- `.env.example` had been missing while README still referenced it; restored as part of this task.
- `make serve` will not show the beacon even with a token (`hugo.IsProduction` false); use `make build` for beacon smoke tests.
- Ad blockers may hide client RUM; CF edge analytics remain available for proxied traffic.
