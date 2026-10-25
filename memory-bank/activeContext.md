# Active Context

## Mode

**BUILD** — Phase 0, Phase 1 (Home), Phase 2 (Services), Phase 3 (Gallery) done, Gates 0–3 passed → **Phase 4 Contact**

## Creative summary

| Phase | Locked |
|-------|--------|
| C1 | No Fate + Hugo ≥ 0.158; kraft V1; system colour; n8n webhook pref |
| C2 | Home H2 panoramic; Services-primary; B2; N1; 3rd bio; Writing |
| C3 | Services S1/H1/E1/R1/V1; `editorial` |
| C4 | Gallery M1/L1/I1/A3/G1/P1; mode defer |
| C5 | Contact T1/F1/U1/S2/H1; LinkedIn L1 + **footer everywhere**; webhook via **Docker env** |

## Phase 1 closed (Home)

- H2 full-bleed hero + kraft plate via site overrides (`layouts/home.html`, `layouts/_partials/home/opening.html`); theme untouched
- Hero image locked: `content/cothrom-home-hero.jpg` (from `images/gallery/20150203_190036-1.png`)
- Below-fold: Services list → About Dominic bio (210w) → Writing stub
- Gate 1 passed; build green; cspell clean; visual checked desktop + mobile

## Phase 2 closed (Services)

- All four built in locked order (PM → TD → CT → SD), one shared hero mechanism, each content-reviewed before the next started
- **Key fix:** Phase 0 stubs were branch bundles (`_index.md`, Kind `section`) — the theme renders sections with `list.html` (no mode dispatch, no hero at all). Converted all four to leaf bundles (`index.md`, Kind `page`) so `single.html` dispatches to `modes/editorial/*`, matching the theme's own leaf-bundle content types.
- H1 hero via two small site overrides, reused by all four pages: `layouts/_partials/modes/editorial/opening.html` (full-bleed hero + kraft plate with service title, driven by native `visual.hero`/`hero_alt` front matter so OG/Twitter/schema images keep working) + `layouts/_partials/modes/editorial/body.html` (theme's `article-shell.html` body minus its own hero figure, to avoid a duplicate image)
- Hero images locked: PM `images/prodMan/A01_0550-1.png`, TD `images/techDir/IMG_0266.png`, CT `images/creativeTech/IMG_0980.png`, SD `images/sysDesign/152B3A8A-...-1.png` — all were already the "service owns, gallery omits" duplicate rows from the Phase 0 register
- Body copy follows S1 (Who it's for → What it's for → How it works → Evidence → Often paired with → Next step), V1 voice, facts traced only to `superCV.yaml` + long-form biography
- "Next step" CTA is a plain Markdown link styled via a CSS attribute selector (`h2#next-step + p a`) — no raw HTML / unsafe goldmark needed
- Gate 2.1–2.4 passed; build green (18 pages); cspell clean; visual checked desktop + mobile; internal links 200

## Phase 3 closed (Gallery)

- `content/gallery/_index.md` stays a branch bundle — no No Fate mode dispatch needed, so `layouts/section/gallery.html` (Hugo section-name template, ahead of theme `_default/list.html`) fully replaces the default chronological list for this one route only
- M1 continuous marquee (CSS keyframes, duplicated photo set, paused on hover/focus/`.is-paused`) + A3 static-grid/no-Pause-control fallback under `prefers-reduced-motion: reduce` — both verified live via Playwright (including a `reducedMotion: 'reduce'` browser context)
- I1 lightbox via native `<dialog>.showModal()` (free focus trap + Esc-to-close) + backdrop-click close; verified click-to-open and Escape-to-close end to end
- G1: 18 curated images locked in `docs/image-register.md`, spanning Cirque touring, US corporate AV, entertainment, NI Assembly/Patrick Finucane Inquiry, broadcast systems, and the Oulu festival; one candidate (a personal certificate photo) deliberately excluded as off-brief
- Gate 3 passed; build green (18 pages); cspell clean; desktop/mobile/reduced-motion all visually checked

## Immediate next step

**`/build` Phase 4** — Contact (per C5: T1 HTML POST to n8n webhook via Docker/env `N8N_CONTACT_WEBHOOK_URL`; F1 name/email/message + honeypot; U1 `/contact/thanks/`; S2 honeypot + Turnstile; L1 LinkedIn on Contact **and** global footer; H1 kraft plate invite; no phone/email anywhere). Needs the webhook URL and Turnstile site key as env vars — not committed — before the form can actually submit; build the page/markup/validation regardless and document what's needed to wire the live endpoint.
