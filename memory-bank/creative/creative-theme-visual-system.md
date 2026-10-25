# 🎨 CREATIVE PHASE C1: Theme & Visual System

**Status:** COMPLETE  
**Type:** Architecture + UI/UX  
**Date opened:** 2026-10-25  
**Date closed:** 2026-10-25

## Problem statement

Choose the Hugo theme/layout foundation and a coherent visual system for the Cothrom portfolio so Phase 0 can close. Blocking constraint was: README names **No Fate** (Hugo ≥ 0.158) while host had Hugo 0.123.7 Extended. Brand assets are kraft-paper logos.

## Requirements

- Professional CV/portfolio; brand-first Home; photo-led services/Gallery
- Evidence-based copy; measured tone
- Unique-first imagery; no phone/email on site
- Theme overrides preferred over forking
- Contact via webhook to an **n8n** instance (user preference)

## Constraints

- No Fate requires Hugo upgrade on this host (or Dockerized Hugo ≥ 0.158)
- Compose/NGINX static root `./site`
- Kraft brand IP is intentional (`#BE9E6C` / `#1D120D`); avoid generic cream+terracotta *cliché* by keeping **photography dominant** and kraft as surface/accent, not a full “AI portfolio” template look
- Frontend rules: one first-viewport composition; brand hero-level; no hero cards; full-bleed hero preference

## Options considered (ADR-01)

| Option | Summary | Result |
|--------|---------|--------|
| A | Upgrade Hugo ≥ 0.158 + pin No Fate | **SELECTED** |
| B | Keep 0.123 + alternate theme | Rejected |
| C | Custom layouts only | Rejected |
| D | Custom now, No Fate later | Rejected |

## Decision — ADR-01 Theme / Hugo

**Chosen: Option A — Upgrade Hugo to ≥ 0.158 Extended and vendor No Fate (pinned tag/commit).**

### Rationale

- Matches README architecture intent
- Editorial / archive / poster modes suit portfolio + Gallery
- Hugo-native image processing aligns with photo-led kraft direction
- User confirmed upgrade path is acceptable

### Implementation guidelines (Phase 0)

1. Install/upgrade Hugo Extended ≥ 0.158 (host binary and/or Docker image used by Makefile)
2. Add theme via Hugo Module **or** git submodule at `themes/no-fate`; **pin** release tag or exact SHA (do not float on `main`)
3. Set `theme = "no-fate"` (or module import); configure under `params.noFate`
4. Prefer **`style = "clean"`** as base (professional portfolio); kraft overrides via site `assets/css/extended/` and layout hooks — do **not** edit theme files
5. Default colour mode: **`system`** (respect `prefers-color-scheme`); enable theme toggle if No Fate supports it (`showThemeToggle = true`)
6. Publish dir: `hugo -d site` (or config `publishDir = "site"`) to match `compose.yml`

## Decision — Visual direction V1 (Kraft-led)

**Chosen: V1 — Kraft-led UI with photography as the primary visual plane.**

### Brand tokens (from logo SVG metadata)

| Token | Value | Role |
|-------|-------|------|
| `--brand-kraft` | `#BE9E6C` | Surfaces, soft fills, logo ground |
| `--brand-ink` | `#1D120D` | Mark, primary text on kraft, dark accents |
| Photography | Real production images | Heroes, Gallery, service evidence |

### Guidelines

- **First viewport:** Cothrom wordmark/mark as hero-level brand signal; one headline; one short support line; one CTA group; one full-bleed (or edge-to-edge) photo plane — no cards, chips, or stat strips in the hero
- Kraft is **material**, not a purple-gradient substitute: use sparingly for header bar, logo plates, borders, focus rings; let photos carry atmosphere
- Light scheme: kraft accents on warm-neutral page ground (not flat #F4F1EA cliché — prefer slightly cooler off-white or kraft-tinted paper with clear contrast)
- Dark scheme (system dark): ink-near backgrounds; kraft as accent/logo plate only; ensure WCAG contrast for text
- Typography: use No Fate’s type stack initially; override only if needed for brand — avoid Inter/Roboto/Arial as intentional brand fonts if replacing
- Motion: reserved for Gallery (C4) and subtle presence elsewhere — not noise

### No Fate preset

- Base style: **`clean`** (not `wild`)
- Accents overridden toward kraft/ink via extended CSS
- `defaultMode` per page type deferred to C2/C3 (Home may use editorial/poster; Gallery likely archive)

## Decision — Colour mode

**System** (`prefers-color-scheme`), with toggle if the theme provides one.

## Provisional — ADR-02 Image pipeline (confirmed for C1)

| Asset | Path |
|-------|------|
| Logos / favicons | `static/` from `images/logos/` |
| Service / Home heroes | Page bundles under `content/.../` |
| Gallery set | `static/images/gallery/` (or data file + static), after register locks |
| Working inventory | Keep `images/` as source; copy processed selects into Hugo paths |

## Provisional — ADR-03 Contact → n8n webhook

**Yes — a static Hugo form can POST to an n8n webhook.** Fits F2-style “own endpoint” without running app code in Hugo.

### Recommended pattern (detail in C5)

1. n8n workflow with **Webhook** trigger (HTTPS URL)
2. HTML form `method="POST"` `action="<webhook-url>"` **or** `fetch` to webhook (prefer server-side redirect/thank-you UX)
3. n8n: validate payload → email/Slack/CRM as desired → respond 200
4. **Security / spam (mandatory in C5):**
   - Do not put secrets in the repo; webhook URL via env at build/deploy or public URL treated as semi-sensitive
   - Honeypot field + optional Cloudflare Turnstile / similar
   - n8n: rate limit, reject empty/botty payloads, no logging of unnecessary PII
   - CORS: if using `fetch` from browser, configure n8n/proxy accordingly; classic form POST often simpler
5. Site still shows **LinkedIn only** for public identity — **no phone/email** displayed
6. Thank-you / error static pages or in-page states

**C5 will own UX + threat model;** C1 only locks the backend preference as **n8n webhook**.

## Architecture sketch

```text
Visitor
  → NGINX (./site)
      ← hugo build (Hugo ≥0.158 + theme no-fate, kraft CSS overrides)
  → Contact form POST
      → n8n Webhook → automation (email/notify/etc.)
```

## Validation against requirements

- [x] Matches README theme intent (No Fate)
- [x] Kraft brand tokens captured from real assets
- [x] Photo-led, brand-first direction documented
- [x] System colour mode decided
- [x] Contact path feasible (n8n webhook) recorded for C5
- [x] Implementation guidelines sufficient for Phase 0 tech validation

## Exit criteria

- [x] ADR-01 locked
- [x] Visual direction + tokens documented (also update `style-guide.md`)
- [x] No Fate base style = `clean`
- [x] Scope limited to C1 (C2–C5 not started)
- [x] Memory Bank updated

## 🎨 EXITING CREATIVE PHASE C1
