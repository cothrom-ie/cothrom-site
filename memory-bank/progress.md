# Progress

## Completed

- [x] **optimize-content-images** Level 1 (2026-10-30) — `make optimize-images` (Pillow venv) resizes/re-encodes `content/` to JPG max-width 1920 in place
- [x] **gallery-tiled-grid** Level 2 (2026-10-30) — marquee replaced with justified tiled grid (no manual crop); lightbox caption added
- [x] **footer-layout-breadcrumbs** Level 1 (2026-10-30) — breadcrumbs off; LinkedIn SVG icon left / copyright centre
- [x] VAN: Memory Bank; Level 4
- [x] PLAN: Phased plan + architecture
- [x] CREATIVE **C1**: Theme & visual system locked
- [x] CREATIVE **C2**: Home composition locked
- [x] CREATIVE **C3**: Service page template locked
- [x] CREATIVE **C4**: Gallery autoscroll locked
- [x] CREATIVE **C5**: Contact/n8n locked (T1, F1, U1, S2, L1+footer, H1, Docker env webhook)
- [x] All creative phases C1–C5 complete
- [x] **Phase 0 / Gate 0** — foundation green (2026-10-25)
- [x] **Phase 0 reflection** — `memory-bank/reflection/reflection-phase-0.md`
- [x] **Phase 1 / Gate 1** — Home live, reviewed (2026-10-25)
- [x] **Phase 2 / Gate 2.1–2.4** — all four service pages live, reviewed (2026-10-25)
- [x] **Phase 3 / Gate 3** — Gallery marquee live, reviewed (2026-10-25)
- [x] **Phase 4 / Gate 4** — Contact form + thanks page + sitewide LinkedIn footer live, reviewed (2026-10-26)
- [x] **Phase 5 / Gate 5** — Hardening & polish complete, full regression passed (2026-10-26)
- [x] **Full-task reflection** — `memory-bank/reflection/reflection-cothrom-site.md` (2026-10-26)
- [x] **Full-task archive** — `memory-bank/archive/archive-cothrom-site.md` (2026-10-26) — **TASK COMPLETE**
- [x] **deploy-cf-pages** (Level 2) — BUILD + REFLECT + ARCHIVE (2026-10-26) — `memory-bank/archive/archive-deploy-cf-pages.md` (operator go-live still open)

## Phase 5 observations

- **Gitignore integrity:** found and fixed two compounding, deploy-breaking bugs — `static/` was blanket-ignored (hiding favicons/`site.webmanifest`, same class of bug as the Phase 3 `memory-bank/` issue) and the root-only `images/` pattern was unanchored and so also caught `static/images/` at depth. Fixed by removing the `static/` line and anchoring to `/images/`; verified independently via `git check-ignore -v`
- **Favicons/manifest:** full set generated via PIL from existing locked kraft-mark assets (no new artwork); wired through `site.Params.assets.*` plus a new `layouts/_partials/hooks/head-end.html` hook override for the `<link rel="manifest">` tag
- **Upstream theme bug found and fixed (not forked):** `themes/no-fate/layouts/_partials/templates/opengraph.html` calls the image-resolution partial by the wrong path (missing the `templates/` prefix the sibling `twitter_cards.html` uses correctly), so `og:image` silently never picked up a page's own hero. Diagnosed via binary-search debugging (confirmed params → resource resolution → the called function itself were each correct, isolating the bug to the caller's path string); fixed via a one-line site-level override. One temporary theme-file edit was made for diagnosis, then fully reverted and confirmed clean (`diff` + `git status` on the submodule)
- Home's bespoke `opening.image` hero needed its own fix — added `seo.image` front matter (the theme's supported override) since Home doesn't use the generic `visual.hero` key `get-page-images.html` checks
- Disabled Hugo's default `tag`/`category` taxonomies (nothing uses them; they were producing empty pages in `sitemap.xml`) — page count 19 → 15
- **404 page:** the theme's own `.not-found` CSS applies a blanket `font-size: 160px` apparently intended only for the "wild" style, breaking layout under this site's locked "clean" style. Fixed via a full site-level override (`layouts/404.html` + `assets/css/extended/404.css`) in the same kraft-plate language as Contact/Service heroes
- **Accessibility:** axe-core (WCAG 2A/2AA + best-practice) across all 8 routes, light and dark colour schemes: **0 violations** both times; 1 `<h1>` per page, correct `lang`, skip-link present everywhere
- **Image register audit:** every file in `content/`/`static/` (31 total) traces to exactly one `locked` register row (28 locked rows: 23 content photography 1:1, 8 favicon/OG derivatives from 5 chrome-category sources); 0 orphans, 0 duplicate basenames among locked rows
- **Style-guide re-pass:** grep sweep for clichés/American spellings/contractions across all published content — clean, aside from the already-locked `## Who it's for`/`## What it's for` heading skeleton (not first-person prose)
- **NGINX hardening:** added `X-Content-Type-Options`, `X-Frame-Options`, `Referrer-Policy`, and a scoped `Content-Security-Policy` (allowing the one real external origin, Cloudflare Turnstile) to `nginx.conf`, plus an explicit `application/manifest+json` MIME mapping. Verified against the **real** nginx container (via `docker compose up -d --force-recreate nginx` against the production build, not just `hugo server`) — all 8 routes 200, `/404.html` returns true 404 status with custom content, correct content types/caching on favicon/webmanifest, headers present on every response. Added README **Build & Development**, **Environment Variables**, and **Deploy (Docker Compose)** sections documenting `make` targets and the `.env`/`.env.example` contract
- **cspell:** 108 "unknown word" hits, all technical/infra vocabulary in config/templates/memory-bank docs — **zero in published content**. Added ~40 legitimate terms to the dictionary; re-run clean (0/46 files)
- **Full regression:** `make clean && make build` → 15 pages, zero WARN/ERROR; Playwright across all 8 routes × 2 breakpoints — all 200, zero console errors, zero broken internal links
- Sandbox note (recurring across all phases): starting the Hugo dev server or a Docker container in one Shell call and testing from a separate call fails due to per-call network/socket isolation; the reliable pattern is always to chain start + verification in one call

## Phase 4 observations

- `content/contact/_index.md` stays a **branch bundle** (same reasoning as Gallery: no No Fate mode dispatch needed) — `layouts/section/contact.html` fully replaces the theme's `list.html` for `/contact/` only. `content/contact/thanks/index.md` is a leaf bundle (the only Kind=`page` content under this section), rendered by its own `layouts/contact/single.html` override, so there's no template collision between the two
- H1: a standalone kraft plate (no photo) — Contact is a task page, not a hero page, per C5's own rationale; reuses the same kraft/ink/`.nf-cta` material language as Home and the service pages via new rules in `assets/css/extended/contact.css`
- **Hugo env-var gotcha (found and fixed):** Hugo's `HUGO_PARAMS_*` build-time config overlay treats every underscore in the variable name as a *new nesting level* — `HUGO_PARAMS_CONTACT_WEBHOOK_URL` sets `params.contact.webhook.url`, not the intended `params.contact.webhook_url`. Renamed the `hugo.toml` param keys to single unbroken words (`webhookurl`, `turnstilesitekey`); confirmed via `hugo config` and a real build with simulated env vars that the URL/key now land correctly. Documented inline in `hugo.toml` and in `systemPatterns.md` as a reusable gotcha
- T1/W1: classic HTML `POST`, `action` URL and Turnstile site key sourced from `hugo build`-time env vars (`N8N_CONTACT_WEBHOOK_URL`, `TURNSTILE_SITE_KEY`), bridged into Hugo's config overlay by the Makefile (`-include .env` + `export`); neither value is committed — `.env.example` documents the contract, real `.env` stays gitignored. The Turnstile *secret* key is never read by Hugo at all — it belongs only in the n8n workflow
- Graceful degradation verified both ways: no env vars → form still renders with `action=""`, no Turnstile widget, and a visible on-page dev note naming the missing variable; env vars present → correct `action` and `data-sitekey` both appear, widget script loads
- S2 honeypot: visually hidden via the standard "clip to 1×1px + `overflow:hidden`" technique (deliberately **not** `display:none`, which naive-but-CSS-aware bots specifically check for and skip) + `tabindex="-1"` + `aria-hidden="true"` wrapper. Verified via Playwright: the wrapper's real bounding box is 1×1px with `clip: rect(0,0,0,0)`, and keyboard Tab from the Name field skips straight to Email
- L1: LinkedIn (`https://www.linkedin.com/in/dominic-capparelli/`, from `superCV.yaml`'s `social_networks` username) on the Contact plate **and** sitewide in the footer, via a full site-level override of `layouts/_partials/footer.html` (theme file copied verbatim plus one added `<span><a>`) — confirmed present in the footer on all 8 built routes
- U1 thanks page link list (Home / 4 services / Gallery / LinkedIn) is generated from `site.Menus.main` + `site.Params.social.linkedin` rather than hardcoded, so it can't drift from the live nav
- Error path: n8n is documented to redirect failed submissions to `/contact/?error=1`; a small inline script reveals an `#nf-contact-error` banner on that query param — verified via Playwright
- Full-site PII sweep of the built `site/` output for the CV email and phone number (all formats) returns **no matches**, before and after adding the form
- `make build`: 19 pages, zero WARN/ERROR (both with and without simulated webhook/Turnstile env vars); cspell clean after adding `sitewide`, `vars`; visual + functional check via Playwright (desktop 1440×900 + mobile 390×844); all internal routes return 200

## Phase 3 observations

- Gallery stayed a **branch bundle** (`_index.md`) deliberately — unlike the Phase 2 service pages, it needs no No Fate mode dispatch at all, so a dedicated `layouts/section/gallery.html` (Hugo's section-name template, ahead of the theme's `_default/list.html`) fully replaces the chronological article index for `/gallery/` only, everywhere else untouched
- M1 continuous marquee via CSS `@keyframes` translateX over a duplicated photo set (visible + `aria-hidden` clone), scoped inside `@media (prefers-reduced-motion: no-preference)`; hover/focus/`.is-paused` pause it
- A3: `@media (prefers-reduced-motion: reduce)` swaps the track to a static CSS grid and hides the Pause control (verified with Playwright's `reducedMotion: 'reduce'` context — control and clones both correctly hidden)
- I1 lightbox uses a native `<dialog>` (`showModal()`) for free focus-trap + Esc-to-close, plus a backdrop-click handler; verified end-to-end with Playwright (pause → click item → lightbox opens → Escape → closes)
- G1: 18 curated images (gitignored working set down from 230MB PNGs to 6.3MB JPGs pre-processed, then Hugo-resized again at build time to `x640`/`x1400` jpg+webp via a shared `layouts/_partials/gallery/item.html` partial) spanning Cirque du Soleil touring, US corporate AV, entertainment, NI Assembly/Patrick Finucane Inquiry (both named public credits), broadcast systems, and the Oulu festival — deliberately excluded one candidate (a personal Disney University certificate) as off-brief
- `make build`: 18 pages, zero WARN/ERROR; cspell clean after adding `freestanding`, `kickoff`; all 18 images locked in `docs/image-register.md`

## Phase 2 observations

- Content.format stubs from Phase 0 were branch bundles (`_index.md`); the theme has no mode dispatch for section/list pages, so hero/`editorial` rendering silently fell back to a generic archive list with no image at all. Converted all four to leaf bundles (`index.md`, Kind `page`) so `single.html`'s `modes/%s/opening.html` / `modes/%s/body.html` dispatch applies — same pattern the theme's own leaf-bundle content types (artefact/project/etc.) use.
- H1 hero (full-bleed + kraft plate + service title) implemented once for all four via `layouts/_partials/modes/editorial/opening.html` + `.../body.html` overrides, driven by native `visual.hero`/`visual.hero_alt` front matter (keeps Open Graph/Twitter/schema.org image generation working for free); the theme's own hero figure in `article-shell.html` is skipped by the body override to avoid duplicating the image
- Hero images locked (all pre-marked "service owns, gallery omits" duplicates from the Phase 0 register): `images/prodMan/A01_0550-1.png`, `images/techDir/IMG_0266.png`, `images/creativeTech/IMG_0980.png`, `images/sysDesign/152B3A8A-...-1.png` → resized to 2400px-wide JPG page resources
- Copy follows S1 skeleton (Who it's for / What it's for / How it works / Evidence / Often paired with / Next step) as prose, not bullet dumps; V1 voice (light "you" for audience, third person for evidence); facts traced only to `superCV.yaml` + long-form biography per task scope (not LinkedIn bio or outreach/email drafts)
- "Next step" CTA is a plain Markdown link styled as a button via a CSS attribute selector (`.nf-prose h2#next-step + p a`) — avoids enabling `goldmark.renderer.unsafe`
- `make build`: 18 pages, zero WARN/ERROR; cspell clean after adding `Finucane`, `multiview`, `Papercut`, `timecode`; visual check (desktop 1440×900 + mobile 390×844) via local Playwright Chromium; all internal routes return 200

## Phase 1 observations

- Site overrides `layouts/home.html` + `layouts/_partials/home/opening.html` implement C2's H2 full-bleed hero + grounded kraft plate (theme's native home opening is a 2-col split; overridden to full-bleed per locked creative decision, theme files untouched)
- Hero image: `images/gallery/20150203_190036-1.png` (6080×3200) resized to 2400×1263 JPG, saved as `content/cothrom-home-hero.jpg` (page resource); locked in `docs/image-register.md`
- CTAs: Services (primary, ink-filled) → `#services`; Contact + Gallery (secondary, outline) — kraft/ink pairing holds ~7.26:1 contrast both directions
- Below-fold B2: Services (plain 4-item list with page descriptions) → About Dominic (210-word 3rd-person bio, sourced from longform bio + superCV + LinkedIn bio) → Writing stub (no papers yet, no link)
- `make build`: 22 pages, zero WARN/ERROR
- Visual check via local Playwright Chromium (installed this session) since the IDE browser tool cannot reach the project's local Hugo dev server (separate network namespace) — screenshots saved under `temp/screens/` (gitignored)
- Fixed broken `cspell.config.yaml` (`import: [en-GB]` was invalid); added `Oulu`, `Soleil`, `Autoscrolling` to dictionary; all content stubs + Home copy cspell-clean
- Deferred: nav theme-toggle shows literal "Theme" text (pre-existing theme chrome) — Phase 5 polish candidate, not a Gate 1 blocker

## Phase 0 observations

- Hugo Extended **0.158.0** via `./bin/hugo` (`make hugo-install` / `make build`)
- No Fate pinned **v0.1.0** (`f2703f64`) at `themes/no-fate` (submodule + `.gitmodules`)
- `publishDir = "site"` aligns with `compose.yml` `./site`
- Kraft hello-world: `assets/css/extended/kraft.css` + Home plate via `layouts/_partials/hooks/body-end.html`
- IA stubs + main menu for all routes; `docs/image-register.md` (107 rows, 17 dups → service owns)
- `make build` → 22 pages; static logo smoke at `/images/logos/cothrom-mark-kraft-32.png`
- Note: host `.git/config` was busy during submodule init; clone has theme at pin — run `git submodule update --init` if needed on a fresh checkout
- Reflection actions into Phase 1: remove hello-world plate; logo commit policy; unique Home hero from register

## In progress

_(none)_

## Completed (service-secondary-images)

- [x] **service-secondary-images** (Level 2) — ARCHIVE complete 2026-10-27 — `memory-bank/archive/archive-service-secondary-images.md`
- Reflection: `memory-bank/reflection/reflection-service-secondary-images.md`

### Build observations (service-secondary-images)

- 4 page-resource `secondary.jpg` files from `images/new/{prodMan_second,techDirSec,creatTechSecond,sysDes_second}.png` (2400px long-edge cap, never upscale, JPG q85); native aspect ratios kept
- `images/new/*Hero*` + `homeHero.png` left as register `reserved` (different project)
- Site override: floated `.nf-service-secondary` + `.nf-service-text` measure wrapper; theme untouched
- **BUILD bug:** `--nf-article-width: none` alone insufficient — theme also caps `.nf-prose` at 68ch; per-child `ch` re-cap mis-centred headings; final fix caps one body-size wrapper. Full writeup in archive + reflection
- Verified: Playwright right edges `1376px` match on all 4 pages; mobile unfloat; cspell clean; `make build` 15 pages 0 WARN/ERROR

## Completed (nav-chrome-light-logo)

- [x] **nav-chrome-light-logo** (Level 1) — ARCHIVE complete 2026-10-26 — `memory-bank/archive/archive-nav-chrome-light-logo.md`

### Build observations (nav-chrome-light-logo)

- `hugo.toml`: `defaultTheme="light"` + `disableThemeToggle=true` + `noFate.showThemeToggle=false` removes the toggle button/JS without touching the theme submodule; confirmed via Playwright that `colorScheme: 'dark'` OS preference still yields `data-theme="light"`
- Site override `layouts/_partials/header.html` drops the `#theme-toggle` markup outright (not just hidden) and adds `<img class="nf-site-logo">` (28×28, decorative `alt=""`) before the site label inside the existing `.nf-site-title` link — flex `column-gap` from theme CSS handles spacing automatically, no extra CSS needed
- Pre-existing `footer.html` site override (from the Contact/LinkedIn Phase 4 work) already conditionally bundles `theme-toggle.js` on the same flag, so no second edit was needed there
- Logo source: `img-101` (`cothrom-mark-kraft.svg`, previously a "candidate" chrome asset) copied to `static/images/logos/` and locked in `docs/image-register.md`
- `make build`: 15 pages, 0 WARN/ERROR; cspell clean after adding `triskelion`

## Completed (deploy-cf-pages)

- [x] **deploy-cf-pages** (Level 2) — ARCHIVE complete 2026-10-26 — `memory-bank/archive/archive-deploy-cf-pages.md`
- Reflection: `memory-bank/reflection/reflection-deploy-cf-pages.md`

### Build observations (deploy-cf-pages)

- `static/_headers` mirrors nginx AppSec CSP/nosniff/frame/referrer; Hugo copies into `site/` (verified `make build`, 15 pages)
- Workflow: `peaceiris/actions-hugo@v3` @ 0.158.0 extended + `cloudflare/wrangler-action@v4` → `pages deploy site --project-name=cothrom-site --commit-dirty=true`; checkout `submodules: true`; CF secret preflight before Wrangler
- README treats Pages as production; Compose nginx = local preview; tunnel = optional/legacy
- **2026-10-26 update:** operator reported live deployment testing done and good — go-live checklist (CF/GH secrets, domains, Bulk Redirect, Tunnel cutover, smoke) treated as complete. Detailed per-item evidence not captured in-agent; see archive Notes.

## Not started / follow-up

_(none — ready for next `/van`)_

## Blockers (operator) — RESOLVED 2026-10-26

| Item | Status |
|------|--------|
| Cloudflare account / Pages project / API token | **Resolved** |
| GH secrets (`CLOUDFLARE_*`, contact build vars) | **Resolved** |
| Custom domains + Bulk Redirect www→apex | **Resolved** |
| DNS cutover Tunnel → Pages | **Resolved** |

## Archive references

| Task | Archive | Completed |
|------|---------|-----------|
| service-secondary-images | `memory-bank/archive/archive-service-secondary-images.md` | 2026-10-27 |
| nav-chrome-light-logo | `memory-bank/archive/archive-nav-chrome-light-logo.md` | 2026-10-26 |
| deploy-cf-pages | `memory-bank/archive/archive-deploy-cf-pages.md` | 2026-10-26 |
| cothrom-site | `memory-bank/archive/archive-cothrom-site.md` | 2026-10-26 |
