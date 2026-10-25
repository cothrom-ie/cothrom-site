# Progress

## Completed

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

- [ ] Phase 4 — Contact (form + n8n webhook, per C5)

## Not started

- [ ] Phase 5 (hardening)
- [ ] Full-task reflect / archive (after Gate 5)

## Blockers

| Item | Status |
|------|--------|
| ADR-01 / Hugo upgrade | Cleared (Phase 0) |
| Gate 0 | Passed |
