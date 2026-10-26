# TASK ARCHIVE: Complete Cothrom CV/Portfolio Website

## METADATA

| Field | Value |
|-------|-------|
| **Task ID** | `cothrom-site` |
| **Name** | Complete Cothrom CV/Portfolio Website |
| **Complexity** | Level 4 (Complex System) |
| **Type** | Full professional website / multi-subsystem product |
| **Workflow** | VAN → PLAN → CREATIVE (C1–C5) → BUILD (Phases 0–5) → REFLECT → ARCHIVE |
| **Date opened** | ~2026-10-25 (VAN/PLAN) |
| **Date completed** | 2026-10-26 |
| **Gates** | 0–5 all PASSED |
| **Status** | **COMPLETED** |
| **Site** | https://cothrom.ie/ |
| **Reflection** | `memory-bank/reflection/reflection-cothrom-site.md` |
| **Phase 0 reflection** | `memory-bank/reflection/reflection-phase-0.md` |

---

## SUMMARY

Shipped a Hugo Extended + No Fate (`clean` + kraft) static CV/portfolio for Dominic Capparelli / Cothrom Productions: Home, four service pages, Gallery marquee, Contact (n8n webhook + Turnstile + LinkedIn-only), favicons/SEO/404/a11y hardening, and NGINX/compose deploy with documented env contract.

Delivery followed evidence-only copy (biography + `superCV.yaml` + style guide), unique-first image register, theme overrides without forking, and slow per-phase gates. Final state: **15 pages**, zero Hugo WARN/ERROR, axe-core **0 violations** (light + dark), all **8 routes** 200 at desktop/mobile with zero broken internal links.

---

## REQUIREMENTS

### Business / product

- Professional portfolio for Cothrom Productions / Dominic Capparelli
- Pages: Home, Contact, Gallery, Production Management, Technical Direction, Creative Technology, System Design
- Copy derived only from long-form biography, writing style guide, and `superCV.yaml` — no invented experience
- **No phone or email** published; LinkedIn is the primary contact channel
- British English; measured professional tone (no marketing hype)

### Functional

- Brand-first Home (first viewport)
- Four service pages with shared skeleton, distinct audiences
- Autoscrolling Gallery with reduced-motion fallback and lightbox
- Contact form POST → n8n; optional Turnstile; thank-you page
- Favicons, SEO meta, custom 404, a11y baseline
- Deploy via Hugo → `./site` → NGINX (compose)

### Non-functional

- Unique-first imagery (`docs/image-register.md`)
- Theme customize via site overrides only — do not edit `themes/no-fate`
- Secrets never in git (`.env` gitignored; `.env.example` placeholders)
- Slow delivery: content review + build/visual gates before next page

---

## ARCHITECTURE & DESIGN DECISIONS

### ADRs (locked in Creative)

| ADR | Decision | Source |
|-----|----------|--------|
| ADR-01 | Hugo Extended ≥ 0.158 + No Fate pinned **v0.1.0** (`f2703f64`); style **`clean`**; kraft via extended CSS | C1 |
| Visual | Kraft-led (`#BE9E6C` / ink); system colour + theme toggle | C1 |
| Home | H2 panoramic full-bleed + grounded kraft plate; services-primary CTAs; B2 below-fold; 3rd-person bio | C2 |
| Services | S1 skeleton; H1 hero; R1 ≤2 related links; V1 voice; No Fate `editorial` mode | C3 |
| Gallery | M1 CSS marquee; L1 full-bleed row; I1 native `<dialog>`; A3 reduced-motion grid; G1 12–24 images | C4 |
| Contact | T1 HTML POST → n8n; F1 name/email/message + honeypot; U1 thanks; S2 Turnstile; L1 LinkedIn + footer; H1 kraft plate no photo | C5 / ADR-03 |

### Content model rules (proven in BUILD)

| Page type | Bundle | Kind | Layout pattern |
|-----------|--------|------|----------------|
| Home | `_index.md` | home | `layouts/home.html` + `home/opening.html` |
| Services (×4) | `index.md` leaf | page | `modes/editorial/*` site overrides |
| Gallery | `_index.md` branch | section | `layouts/section/gallery.html` |
| Contact | `_index.md` branch | section | `layouts/section/contact.html` |
| Thanks | `index.md` leaf | page | `layouts/contact/single.html` |

**Critical:** No Fate mode/hero dispatch only runs for Kind `page` (leaf bundles). Branch bundles silently fall back to `list.html` with a green build.

### Hugo env overlay gotcha

`HUGO_PARAMS_*` treats every underscore as a nesting level. Contact keys must be unbroken: `webhookurl`, `turnstilesitekey` (not snake_case).

---

## IMPLEMENTATION

### Phased delivery

| Phase | Gate | Date | Outcome |
|-------|------|------|---------|
| 0 Foundation | Gate 0 | 2026-10-25 | Hugo 0.158 local; No Fate pin; kraft; stubs; image register; Makefile; `publishDir=site` |
| 1 Home | Gate 1 | 2026-10-25 | H2 hero + kraft plate; 210w bio; CTAs; Writing stub |
| 2 Services | Gate 2.1–2.4 | 2026-10-25 | Leaf bundles; shared editorial hero; S1 copy ×4; unique heroes |
| 3 Gallery | Gate 3 | 2026-10-25 | 18-image marquee; pause; lightbox; reduced-motion grid |
| 4 Contact | Gate 4 | 2026-10-26 | Form + thanks; footer LinkedIn; env webhook/Turnstile; PII clean |
| 5 Hardening | Gate 5 | 2026-10-26 | Favicons; OG fix; 404; a11y; nginx headers; README; cspell; full regression |

### Key components / files

**Config / ops**

- `hugo.toml` — theme, menus, params (contact, assets, images, schema, empty taxonomies)
- `makefile` — `hugo-install`, `build`, `serve`, `clean`; `.env` → `HUGO_PARAMS_*`
- `compose.yml` — nginx `:8039` + optional cloudflare-tunnel
- `nginx.conf` — security headers, CSP, webmanifest MIME, 404, asset cache
- `.env.example` — `CLOUDFLARE_TUNNEL_TOKEN`, `N8N_CONTACT_WEBHOOK_URL`, `TURNSTILE_SITE_KEY`
- `.gitignore` — no blanket `static/`; anchored `/images/`
- `README.md` — Build / Env / Deploy sections
- `cspell.config.yaml` — en-GB + project technical words
- `docs/image-register.md` — 107 inventory rows; 28 locked published

**Layouts (site overrides; theme untouched)**

- `layouts/home.html`, `_partials/home/opening.html`
- `_partials/modes/editorial/opening.html`, `body.html`
- `section/gallery.html`, `_partials/gallery/item.html`
- `section/contact.html`, `contact/single.html`
- `_partials/footer.html` (LinkedIn)
- `_partials/templates/opengraph.html` (upstream path fix)
- `_partials/hooks/head-end.html` (manifest link)
- `layouts/404.html`

**CSS**

- `assets/css/extended/kraft.css`, `home.css`, `services.css`, `gallery.css`, `contact.css`, `404.css`

**Content**

- `content/_index.md` (+ `cothrom-home-hero.jpg`, `seo.image`)
- `content/{production-management,technical-direction,creative-technology,system-design}/index.md` + `hero.jpg`
- `content/gallery/_index.md` + `photos/g01–g18.jpg`
- `content/contact/_index.md`, `content/contact/thanks/index.md`

**Static chrome**

- `static/favicon.ico`, `static/images/icons/*`, `static/site.webmanifest`, `static/images/social/og-default.jpg`

### Creative phase documents (archived by reference; retained in place)

| ID | Path |
|----|------|
| C1 | `memory-bank/creative/creative-theme-visual-system.md` |
| C2 | `memory-bank/creative/creative-home-composition.md` |
| C3 | `memory-bank/creative/creative-service-page-template.md` |
| C4 | `memory-bank/creative/creative-gallery-autoscroll.md` |
| C5 | `memory-bank/creative/creative-contact-n8n.md` |

Creative docs remain live ADRs under `memory-bank/creative/` — not relocated — so future work can still open them. This archive is the index.

### Work-breakdown checklist (merged from tasks.md at completion)

#### S0 Foundation — Complete (Gate 0)

- [x] ADR-01 closed (Option A)
- [x] Upgrade Hugo ≥ 0.158 + pin No Fate
- [x] Theme/layouts baseline + kraft extended CSS
- [x] Content stubs + menus
- [x] Image register created
- [x] Makefile build/serve (`publishDir` → `site`)
- [x] Gate 0 passed

#### S3 Home — Complete (Gate 1)

- [x] C2 complete; bio reviewed; panoramic hero locked; Gate 1

#### S4 Services — Complete (Gates 2.1–2.4)

- [x] PM → TD → CT → SD

#### S5 Gallery — Complete (Gate 3)

- [x] C4; marquee + a11y; 18 images locked

#### S6 Contact — Complete (Gate 4)

- [x] C5; form + thanks + Turnstile + env webhook; footer LinkedIn

#### S7 Hardening — Complete (Gate 5)

- [x] Gitignore integrity; favicons/manifest; OG/SEO; taxonomies; 404; a11y; image audit; style re-pass; nginx/README; cspell; full regression

---

## TESTING

| Gate / check | Method | Result |
|--------------|--------|--------|
| Build | `make build` / `make clean && make build` | Green; final 15 pages, 0 WARN/ERROR |
| Routes | curl / Playwright | 8 content routes + custom 404 |
| Content review | Per-page protocol vs docs/pages + sources | Passed Phases 1–4; Phase 5 style re-pass clean |
| PII | Grep built `site/` for CV email/phone | No matches |
| Image uniqueness | Register + Phase 5 reverse audit | 31 files → 28 locked rows; 0 orphans/dups |
| Visual | Playwright desktop 1440×900 + mobile 390×844 | All phases gated |
| Gallery a11y | Playwright pause/lightbox/reduced-motion | Passed Gate 3 |
| Contact functional | Playwright honeypot/tab/`?error=1`/env on-off | Passed Gate 4 |
| a11y | axe-core WCAG 2A/2AA + best-practice; light + dark | **0 violations** |
| cspell | Full project regression | **0 issues** (46 files) after dictionary update |
| NGINX | `docker compose` nginx against `./site` | Headers, MIME, 404 status, all routes 200 |
| Links | Playwright `page.request.get` on internal hrefs | 0 broken |

**Ops note:** Agent sandbox isolates network per shell call — always chain Hugo/Docker start + verification in one invocation.

---

## SECURITY & DEPLOY

- No CV email/phone in published output
- Contact: honeypot (clip, not `display:none`) + optional Turnstile; secret key only in n8n
- Webhook URL / Turnstile site key via build-time env; never committed
- NGINX: `nosniff`, `DENY` framing, referrer policy, scoped CSP (self + Turnstile + `'unsafe-inline'` for theme/site inline scripts)
- Cloudflare tunnel token via compose env only

**Production still required outside repo:** fill `.env`, run n8n workflow with Turnstile secret, set tunnel token.

---

## LESSONS LEARNED

1. **Silent Hugo failures** — Wrong Kind, wrong partial path, wrong env nesting, and over-broad gitignore all yield green builds with wrong runtime behaviour. Verify user-visible contracts.
2. **Creative locks pay off** under serial BUILD — little design thrash across five phases.
3. **Theme override, don’t fork** — Including temporary diagnostic theme edits: always revert and verify submodule clean.
4. **Hardening needs real nginx** — `hugo server` alone misses MIME, headers, error_page status, volume freshness.
5. **Gitignore anchoring** — Bare `images/` matches at any depth; use `/images/` for root-only.
6. **Phase reflect ≠ task reflect** — Keep both; merge checklists into archive at the end.

Full narrative: `memory-bank/reflection/reflection-cothrom-site.md`.

---

## FUTURE CONSIDERATIONS

| Item | Priority |
|------|----------|
| Wire production n8n + Turnstile secret | High |
| Upstream PR for No Fate opengraph path bug | Medium |
| White papers when content exists | Medium |
| Theme-toggle “Theme” label polish | Low |
| CSP nonce/hash to drop `'unsafe-inline'` | Low |
| Register uniqueness assert in `make check` | Low |

---

## REFERENCES

### Memory Bank

- Reflection: `memory-bank/reflection/reflection-cothrom-site.md`
- Phase 0 reflection: `memory-bank/reflection/reflection-phase-0.md`
- Creative C1–C5: `memory-bank/creative/creative-*.md`
- Patterns: `memory-bank/systemPatterns.md`
- Style: `memory-bank/style-guide.md`
- Progress (historical notes retained): `memory-bank/progress.md`

### Project docs / sources

- `docs/pages.md`, `docs/image-register.md`
- `README.md` (Build / Env / Deploy)
- Editorial sources (offline): `assets-general/personal/...` (gitignored)
- Theme: https://github.com/OliverObst/no-fate (pinned v0.1.0)

### Technology

| Layer | Selection |
|-------|-----------|
| SSG | Hugo Extended **0.158.0** (`./bin/hugo`) |
| Theme | No Fate **v0.1.0** / `f2703f64` |
| Serve | NGINX via `compose.yml` port **8039** |
| Contact | n8n webhook + Cloudflare Turnstile (optional) |
| Spellcheck | cspell en-GB |
| QA | Playwright + axe-core (local/dev, not shipped) |

---

## ARCHIVE VERIFICATION

- Reflection document reviewed? **YES**
- Archive document created with required sections? **YES**
- Location `memory-bank/archive/archive-cothrom-site.md`? **YES**
- Creative phases indexed (retained in `creative/`)? **YES**
- tasks.md marked COMPLETE and cleared for next task? *(follows)*
- progress.md updated with archive reference? *(follows)*
- activeContext.md reset for next task? *(follows)*

**Status: COMPLETED — 2026-10-26**
