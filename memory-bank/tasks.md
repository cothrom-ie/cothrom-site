# Task: Complete Cothrom CV/Portfolio Website

## Description

Ship a professional Hugo CV/portfolio for Dominic Capparelli / Cothrom Productions (`https://cothrom.ie/`) with Home, Contact, Gallery, and four service pages. Page copy is derived only from the long-form biography, writing style guide, and `superCV.yaml`, with careful per-page content review. Images come from `images/` with unique-first assignment (editing allowed). Delivery is slow and test-gated.

## Complexity

| Field | Value |
|-------|-------|
| **Level** | **4** (Complex System) |
| **Type** | Full professional website / multi-subsystem product |
| **Workflow** | VAN → PLAN → CREATIVE → BUILD (phased) → REFLECT → ARCHIVE |

## Status

- [x] Initialization complete (VAN)
- [x] Planning complete (this document)
- [x] Creative **C1** complete — `memory-bank/creative/creative-theme-visual-system.md`
- [x] Creative **C2** complete — `memory-bank/creative/creative-home-composition.md`
- [x] Creative **C3** complete — `memory-bank/creative/creative-service-page-template.md`
- [x] Creative **C4** complete — `memory-bank/creative/creative-gallery-autoscroll.md`
- [x] Creative **C5** complete — `memory-bank/creative/creative-contact-n8n.md`
- [x] All creative phases C1–C5 complete
- [x] Technology validation complete (Phase 0 / Gate 0)
- [x] Phase 0 foundation complete
- [x] Phase 0 reflection complete — `memory-bank/reflection/reflection-phase-0.md`
- [x] Phase 1 Home complete (Gate 1 passed)
- [x] Phase 2 Service pages complete (Gate 2.1–2.4 passed)
- [x] Phase 3 Gallery complete (Gate 3 passed)
- [ ] Phased implementation complete (Phases 4–5)
- [ ] Full-task reflection / archive (after Gate 5)

### Phase 0 Reflection Highlights

- **What Went Well:** Gate evidence matched plan; C1 kraft via extended CSS; pinned No Fate v0.1.0; local Hugo 0.158; image register with dup rule
- **Challenges:** Host Hugo too old; submodule/tag + `.git/config` busy; Hugo cache path; `static/`/`images/` gitignored
- **Lessons:** Pin toolchain at Gate 0; No Fate stubs need content-model FM; register before heroes; phase reflect ≠ task reflect
- **Next Steps:** `/build` Phase 1 Home; commit policy for logos; remove kraft hello-world plate

**→ NEXT:** **`/build`** Phase 4 — Contact (form + n8n webhook, per C5).

---

## Technology Stack

| Layer | Selection | Notes |
|-------|-----------|--------|
| SSG | **Hugo Extended** | Build path: `./bin/hugo` **v0.158.0+extended** (`make hugo-install`) |
| Theme | **No Fate** v0.1.0 (`themes/no-fate`) | Pinned `f2703f64`; style `clean` + kraft CSS |
| Language / content | Markdown + YAML front matter; `en-GB` | Sources stay in `assets-general/` (not published raw) |
| Images | Hugo page bundles and/or `static/` + optional Hugo image processing | Source inventory in `images/` |
| Serving | NGINX (`compose.yml` → port 8039, volume `./site`) | Cloudflare tunnel noted as future front |
| Contact backend | **TBD in Creative** (static-friendly) | Candidates: Formspree/Basin/Getform, Cloudflare Worker, self-hosted endpoint |
| Spellcheck | cspell | `cspell.config.yaml` present |
| Build / ops | Makefile stubs; `hugo` CLI | Expand `make` targets during Phase 0 |

### Technology Validation Checkpoints

- [x] Project initialization present (`hugo.toml`, standard Hugo dirs)
- [x] Hugo CLI available and version documented
- [x] Empty/default build succeeds (`hugo` exit 0 → `public/`)
- [x] Theme selection **and** Hugo version path resolved (ADR-01 → Option A)
- [x] Hugo upgraded to ≥ 0.158 Extended on build path (`./bin/hugo`)
- [x] Theme vendored (submodule), pinned v0.1.0
- [x] Hello-world page with No Fate + kraft CSS (`make build` → kraft plate on Home)
- [x] Image pipeline path verified (`site/images/logos/cothrom-mark-kraft-32.png`)
- [x] Contact backend preference chosen (n8n webhook); spam/validation in C5
- [x] Deploy path aligned: `publishDir = "site"` matches compose `./site`

### ADR-01 — Theme vs Hugo version — **ACCEPTED: Option A**

Upgrade Hugo Extended to **≥ 0.158**, vendor **No Fate** pinned (tag/SHA), base style **`clean`**, kraft overrides via site CSS. Visual direction **V1 kraft-led**; colour mode **system** (+ toggle if available).  
Documented in `memory-bank/creative/creative-theme-visual-system.md`.

### ADR-02 — Image pipeline (decide in Phase 0 / Creative)

| Option | Use when |
|--------|----------|
| Page bundles (`content/.../index.md` + images) | Service pages & Home heroes |
| `static/images/...` | Gallery bulk, logos, favicons |
| Hugo assets + resources.Get | When theme image processing is enabled |

**PLAN recommendation:** Logos → `static/`; service heroes → page bundles from assigned pool; Gallery → `static/images/gallery/` or data-driven list; keep `images/` as **source of truth / working inventory**, copy processed selects into Hugo paths (do not serve `assets-general`).

### ADR-03 — Contact form backend — **Preference locked: n8n webhook**

Static form **POST → n8n Webhook** (HTTPS). LinkedIn on page; **no phone/email**. Spam/honeypot/Turnstile, CORS, and rate limits designed in **C5**. Do not commit webhook secrets; treat public webhook URL as semi-sensitive.

---

## Architectural Overview

### System context

```text
[Visitor] → [Cloudflare tunnel / DNS] → [NGINX :8039]
                                              ↓
                                    [Static site root ./site]
                                              ↑
                                    [hugo build → public/ → sync]
                                              ↑
                         [content/ + layouts/theme + static images]
                                              ↑
              [Editorial sources: bio, style guide, superCV — offline]
```

### Subsystems

| ID | Subsystem | Responsibility |
|----|-----------|----------------|
| S0 | Foundation | Hugo config, theme/layouts, nav chrome, build/deploy glue |
| S1 | Content system | Drafts, review protocol, source traceability |
| S2 | Image system | Register, uniqueness, edit/export into Hugo paths |
| S3 | Home | Brand-first landing, short bio, nav to services |
| S4 | Services | Four pages with shared skeleton, distinct audiences |
| S5 | Gallery | Autoscrolling visual archive |
| S6 | Contact | Form + LinkedIn; PII policy |
| S7 | Hardening | SEO, a11y, cross-site audits, NGINX |

### Architectural principles

1. **Evidence over marketing** — every claim traces to bio/CV
2. **Audience-fit language** — per `docs/pages.md`
3. **Unique-first imagery** — document exceptions
4. **Static-first** — no app server for content; form is the only dynamic edge
5. **PII minimization** — no email/phone on site
6. **Slow gates** — content review + build/visual tests before next page
7. **Theme overrides, don’t fork** — if using No Fate, customize via site layouts/assets

### Content IA (target Hugo paths)

```text
content/
  _index.md                          # Home
  contact/_index.md
  gallery/_index.md
  production-management/_index.md
  technical-direction/_index.md
  creative-technology/_index.md
  system-design/_index.md
```

(White papers: future section; Home stub link only.)

---

## Content Source Map

| Page | Brief | Primary narrative | Primary facts (CV) | Image pool (prefer) |
|------|-------|-------------------|--------------------|---------------------|
| **Home** | Greeting, 150–250w bio, links, WP stub | Bio opening + freelance focus (Oulu, Pi, Cirque/Encore arc condensed) | Name, location, LinkedIn only; high-level roles | Logos + 0–1 unique hero (not reused on services) |
| **Production Management** | Audience/purpose/scope from docs | Cothrom / festival / large-event PM; Encore P&L/crewing where relevant | Cothrom PM highlights; Encore Senior AV PM; Cirque coordination | `images/prodMan/` first |
| **Technical Direction** | Docs brief | On-site technical leadership; department coordination | Cirque electronics; festival TD-adjacent work; Encore delivery | `images/techDir/` first |
| **Creative Technology** | Docs brief | Helping creatives realise technical ideas | Cothrom creative tech; Tait R&D; Cirque custom electronics; film/TV credits carefully | `images/creativeTech/` first |
| **System Design** | Docs brief | Requirements → architecture → commission | Pi inquiries; QUB AVoIP; EOS design; broadcast skills | `images/sysDesign/` first |
| **Gallery** | Autoscroll | Minimal copy | N/A | `images/gallery/` after service assignments reserved |
| **Contact** | Form + LinkedIn | Short invite; collaborative tone | LinkedIn username only | Optional brand mark only |

### Content review protocol (gate every copy page)

- [ ] Matches audience / purpose / editorial direction in `docs/pages.md`
- [ ] Facts traceable to biography and/or `superCV.yaml`
- [ ] Tone matches `cappy_writing_style_guide.md` (direct, measured, no hype)
- [ ] No phone/email published
- [ ] Distinguishes this service from the other three where relevant
- [ ] Images unique vs other published pages (or exception logged in image register)
- [ ] cspell clean on new copy

---

## Image Register Plan

### Snapshot

| Folder | Count | Role |
|--------|------:|------|
| gallery | 69 | Gallery primary; many basename duplicates with service folders |
| prodMan | 9 | Production Management |
| techDir | 7 | Technical Direction |
| creativeTech | 9 | Creative Technology |
| sysDesign | 4 | System Design (tightest pool) |
| logos | 9 | Brand chrome / favicons only |

### Duplicate basenames (same file in gallery + service)

`A01_0491-1`, `A01_0550-1`, `IMAGE_012-1`, `IMG_0003-1`, `IMG_0004-1`, `IMG_0023-1`, `IMG_0214-1`, `IMG_0266`, `IMG_0770`, `IMG_0980`, `IMG_1572-1`, `PA080012-1`, `PA080013-1`, `PB070058-1`, `PB080085-1`, `PC300072-1`, `152B3A8A-…`

**Rule:** Assign each basename to **one** published role (service hero **or** gallery). Prefer service folder ownership for that service page; remove/omit the gallery twin from the gallery set.

### Register artifact (create in Phase 0)

Path: `docs/image-register.md` (or `memory-bank/` working copy then promote)

Columns: `id | source_path | basename | assigned_page | status (candidate/locked/edited) | notes`

---

## Phased Implementation Plan

### Phase 0 — Foundation & inventory

**Depends on:** ADR-01 theme decision (Creative kickoff may run in parallel for visual direction)

1. Resolve Hugo version + theme (ADR-01); vendor theme or establish custom layout baseline
2. Align deploy dirs: document `hugo -d site` vs `public/` vs compose `./site`
3. Scaffold content stubs for all IA paths; wire menu in `hugo.toml`
4. Create **content source map** working notes (this section) → living checklist in progress
5. Create **image register** file; mark duplicates; pre-reserve service candidates
6. Add Makefile targets: `build`, `serve`, `clean`
7. Test baseline checklist template (below)

**Gate 0:** Theme/layouts render stub Home; all routes 200; image register exists; `hugo` build green

**Gate 0 result (2026-10-25): PASSED**

| Check | Result |
|-------|--------|
| `make build` | OK — 22 pages → `site/` |
| Routes | `/`, `/contact/`, `/gallery/`, `/production-management/`, `/technical-direction/`, `/creative-technology/`, `/system-design/` |
| Theme | No Fate v0.1.0 @ `f2703f64` |
| Kraft | `--brand-kraft` / plate in Home HTML + extended CSS |
| Image register | `docs/image-register.md` (107 entries, 17 dups marked omit) |
| Commands | `make hugo-install` · `make build` · `make serve` · `make clean` |

**Phase 0 reflection:** `memory-bank/reflection/reflection-phase-0.md` (2026-10-25)

### Phase 1 — Brand chrome & Home

1. `/creative`: Home composition + nav/brand (brand-first first viewport)
2. Draft 150–250 word Home bio from sources → **content review**
3. Service + Gallery + Contact links; white-paper stub
4. Assign Home imagery (unique); logos in chrome
5. Desktop + mobile visual test

**Gate 1:** Content review OK; visual OK; build green

**Gate 1 result (2026-10-25): PASSED**

| Check | Result |
|-------|--------|
| `make build` | OK — 22 pages, zero WARN/ERROR |
| Hero | H2 full-bleed photo + grounded kraft plate (site override `layouts/_partials/home/opening.html` + `layouts/home.html`; theme untouched) |
| Hero image | `images/gallery/20150203_190036-1.png` → resized/converted `content/cothrom-home-hero.jpg`; locked in `docs/image-register.md` |
| CTAs | Services (primary, ink-filled) → `#services`; Contact + Gallery (secondary, outline) |
| Below-fold (B2) | Services list (4, plain accessible `<ul>`) → About Dominic (210-word 3rd-person bio) → Writing stub |
| Content review | Audience/purpose ✓; facts traced to longform bio + superCV + LinkedIn bio ✓; style guide tone ✓; no phone/email ✓; image uniqueness logged ✓; cspell clean ✓ |
| Visual check | Desktop 1440×900 + mobile 390×844 via local Playwright Chromium screenshots (`temp/screens/home-v2-*.png`) — kraft plate contrast ~7.26:1 both directions |
| cspell | Fixed broken `cspell.config.yaml` `import: [en-GB]`; added `Oulu`, `Soleil`, `Autoscrolling` to project words |

**Deferred / noted:** Nav theme-toggle renders visible text "Theme" (pre-existing theme chrome, not a Home-build regression) — candidate for Phase 5 polish, not a Gate 1 blocker.

### Phase 2 — Service pages (sequential)

**Order:** Production Management → Technical Direction → Creative Technology → System Design

For each:

1. Draft from docs brief + mapped CV/bio evidence + style guide
2. Content review gate
3. Lock images from register (edit/crop as needed)
4. Implement page; responsive + internal link tests
5. Only then start next

**Gate 2.x:** Per-page content + image uniqueness + build/visual

**Gate 2.1–2.4 result (2026-10-25): PASSED** — all four built in order; shared hero mechanism required a content-model fix (below) rather than per-page forks.

| Check | Result |
|-------|--------|
| `make build` | OK — 18 pages, zero WARN/ERROR |
| Content-model fix | Service pages were Phase 0 **branch bundles** (`_index.md` → Kind `section` → theme `list.html`, no mode dispatch, no hero). Converted all four to **leaf bundles** (`index.md`, Kind `page`) so `single.html` dispatches to `modes/editorial/*`, matching how the theme's own leaf-bundle content types (artefact/project/etc.) work. |
| Hero (H1) | Full-bleed photo + kraft plate with **service title** + one-line purpose + quiet Contact link. Site overrides: `layouts/_partials/modes/editorial/opening.html` (renders hero via native `visual.hero`/`hero_alt` front matter, so OG/Twitter/schema images resolve automatically) + `layouts/_partials/modes/editorial/body.html` (trimmed copy of theme's `article-shell.html` body, omitting its own hero figure to avoid rendering the image twice). One shared pair of partials for all four pages — no per-page layout forks. Theme untouched. |
| Hero images | PM → `images/prodMan/A01_0550-1.png`; TD → `images/techDir/IMG_0266.png`; CT → `images/creativeTech/IMG_0980.png`; SD → `images/sysDesign/152B3A8A-...-1.png`. All four happened to be the pre-marked "service owns, gallery omits" duplicate rows from the Phase 0 register — resized to 2400px-wide JPG page resources (`content/<service>/hero.jpg`) and locked in `docs/image-register.md`. |
| Skeleton (S1) | Who it's for → What it's for → How it works → Evidence → Often paired with → Next step, for all four, as Markdown headings/prose (not bullet dumps) |
| Related (R1) | ≤2 quiet text links per page (PM↔TD/CT; TD↔PM/SD; CT↔SD/PM; SD↔TD/CT) — no comparison tables |
| Voice (V1) | Light "you"/audience framing in "Who it's for"; strictly third person in "Evidence", facts traced only to `superCV.yaml` + long-form biography (no reliance on LinkedIn bio or outreach/email drafts, per task scope) |
| Next-step CTA | Plain Markdown link (`## Next step {#next-step}` + link) styled as a kraft button via CSS attribute selector — no raw HTML, no `goldmark.renderer.unsafe` needed |
| Content review | Audience/purpose vs `docs/pages.md` ✓; facts traced to superCV/biography ✓; style guide tone ✓; no phone/email ✓; no invented experience ✓; image uniqueness logged ✓; service differentiation preserved (R1 pairs, distinct audiences) ✓ |
| Visual check | Desktop 1440×900 + mobile 390×844 via local Playwright Chromium, all four pages — kraft plate hero matches Home's H2 material language |
| cspell | Added `Finucane`, `multiview`, `Papercut`, `timecode` to project words; clean |
| Internal links | `/`, all four service routes, `/contact/`, `/gallery/` all return 200 |

### Phase 3 — Gallery

1. `/creative`: autoscroll behaviour, performance, a11y (`prefers-reduced-motion`)
2. Build gallery set from register leftovers
3. Implement; test load, scroll, mobile

**Gate 3:** UX + performance acceptable; no conflicting duplicates

**Gate 3 result (2026-10-25): PASSED**

| Check | Result |
|-------|--------|
| `make build` | OK — 18 pages, zero WARN/ERROR |
| Implementation | `content/gallery/_index.md` stays a **branch bundle** (`_index.md`, Kind `section`) — unlike the Phase 2 service pages, Gallery needs no No Fate mode dispatch at all, so a dedicated `layouts/section/gallery.html` override (Hugo's section-name template lookup, ahead of the theme's `_default/list.html`) fully replaces the chronological-index list view for `/gallery/` only; every other section still falls back to the theme default. Theme untouched. |
| Motion (M1) | Single `.nf-gallery__track` flex row, CSS `@keyframes` translateX(0→-50%) over the photo set duplicated once (visible set + `aria-hidden`/`tabindex="-1"` clone set), `animation: ... linear infinite` scoped inside `@media (prefers-reduced-motion: no-preference)`; `:hover`/`:focus-within`/`.is-paused` set `animation-play-state: paused` |
| Layout (L1) | Single full-bleed horizontal row, fixed row height (`46vh`, capped `26rem`), panoramic images read widest |
| Interaction (I1) | Each image is a `<button>`; click populates and opens a native `<dialog>` lightbox (`showModal()` — native focus trap + Esc-to-close); backdrop click also closes; verified via Playwright: pause toggles `aria-pressed`, lightbox opens on click and closes on Escape |
| Reduced motion (A3) | `@media (prefers-reduced-motion: reduce)` switches the track to a static CSS grid (all 18 images, clones hidden) and hides the Pause control entirely (nothing to pause); verified via Playwright with `reducedMotion: 'reduce'` — control not visible, clone not visible, grid renders cleanly |
| Set (G1) | 18 curated images (within locked 12–24 range), selected for variety across eras/venues: Cirque du Soleil touring (2), US corporate AV (6), entertainment/banquet (3), parliamentary/government (2: NI Assembly, Patrick Finucane Inquiry — both named, public credits per `superCV.yaml`), broadcast systems (3, incl. one portrait of Dominic at a control desk), Oulu festival crowd (1, closing image, most recent work). Excluded one strong candidate (`IMG_0896`, a personal Disney University certificate) as off-brief — not production/work imagery. |
| Chrome (P1) | Title "Gallery" + one support line: "A visual record of live events and technical production work spanning more than two decades." — traced to CV ("more than 20 years of experience"), no invented claims |
| No Fate mode | Deferred per C4 — Gallery doesn't use `editorial`/`archive`/etc. dispatch at all; front matter simplified to `title`/`description`/`date`/`content.format`/`photos` list only |
| Images | 18 PNGs (230MB total) resized to 1280px-tall JPGs (6.3MB total) as page-bundle resources under `content/gallery/photos/`; Hugo then produces `x640`/`x1400` × jpg/webp derivatives per image at build time via a shared `layouts/_partials/gallery/item.html` partial (called once per visible item, once per clone) |
| Image register | All 18 locked in `docs/image-register.md` (both the `Locked assignments` summary and the per-row `Full register` entries) |
| Accessibility | Marquee region `aria-label`; clone set `aria-hidden`+`tabindex="-1"` (out of tab order); Pause button is a real `<button>` with `aria-pressed`; lightbox uses native `<dialog>` for focus trap / Esc |
| cspell | Added `freestanding`, `kickoff` to project words; clean |
| Internal links | `/`, `/gallery/`, all four service routes, `/contact/` all return 200 |

### Phase 4 — Contact

1. `/creative`: form UX + backend selection (ADR-03) + threat/spam notes
2. Implement LinkedIn CTA; enforce no phone/email
3. Functional + security smoke tests

**Gate 4:** Form path works; PII policy held; build green

### Phase 5 — Hardening & polish

1. Cross-site image audit
2. Full style-guide content pass
3. Favicons, SEO meta, 404, a11y spot-check, cspell
4. NGINX config + compose path verified; deploy notes in README

**Gate 5:** Full regression → `/reflect` → `/archive`

---

## Creative Phases Required

| ID | Phase | Type | When | Outcome |
|----|-------|------|------|---------|
| C1 | **Theme & visual system** | Architecture + UI | Before/with Phase 0 close | **DONE** — A + V1 + system mode; No Fate `clean`; n8n webhook pref |
| C2 | **Home composition** | UI/UX | Start of Phase 1 | **DONE** — H2 panoramic + kraft plate; C2 services-primary; B2; N1; 3rd; Writing stub |
| C3 | **Service page template** | UI/UX | Before Phase 2 | **DONE** — S1, H1, E1, R1, V1, No Fate `editorial` |
| C4 | **Gallery autoscroll** | UI/UX + performance | Phase 3 | **DONE** — M1/L1/I1/A3/G1/P1; No Fate mode defer |
| C5 | **Contact form & backend** | UI/UX + security | Phase 4 | **DONE** — T1/F1/U1/S2/L1+footer/H1/W1; webhook via Docker env |

**Mandatory before BUILD of related phases:** C1 before finishing Phase 0; C2 before Home build; C3 before first service page; C4/C5 before Gallery/Contact builds.

---

## Testing Strategy (slow delivery)

### Per-change baseline

- [ ] `hugo` (or `make build`) succeeds
- [ ] `hugo server` spot-check of touched routes
- [ ] No new cspell failures on edited copy

### Per-page checklist

- [ ] Content review protocol passed
- [ ] Image register updated (locked assignment)
- [ ] Desktop layout acceptable
- [ ] Mobile layout acceptable
- [ ] Nav/footer links correct
- [ ] No published email/phone
- [ ] Lighthouse/a11y spot-check optional but encouraged on Gallery/Contact

### Phase regression

- [ ] All existing pages still build and link
- [ ] Image uniqueness audit script/list check

---

## Dependencies

```text
C1 (theme/visual) ──► Phase 0 complete ──► C2 ──► Phase 1 Home
                                              │
                                              └──► C3 ──► Phase 2 services (serial)
                                                              │
                         image register ──────────────────────┴──► Phase 3 needs leftovers
Phase 0 image register ──► all visual phases
C4 ──► Phase 3 Gallery
C5 ──► Phase 4 Contact
Phases 1–4 ──► Phase 5 hardening ──► Reflect ──► Archive
```

External: Hugo upgrade (if Option A); form provider account (if SaaS); NGINX/compose for local prod-like serve.

---

## Challenges & Mitigations

| Challenge | Mitigation |
|-----------|------------|
| No Fate needs Hugo ≥ 0.158; host has 0.123.7 | ADR-01: upgrade or alternate theme before page work |
| `sysDesign` only 4 images | Edit/crop; borrow carefully from gallery **without** duplicating published use; optional new crops |
| Gallery/service basename duplicates | Unique-first register; service wins for service pages |
| CV contains email/phone | Explicit Contact policy; review checklist item; never copy from YAML to front matter |
| Invented experience risk | Source map + review gate; quote facts from CV/bio only |
| Contact spam / abuse | Provider CAPTCHA/honeypot; rate limits; no custom unsafe handlers |
| Compose expects `./site`, Hugo defaults `public/` | Standardize publish dir in Makefile |
| Theme still pre-release maturity | Pin commit/tag; prefer site-level overrides |
| Slow pace vs scope | Strict one-page-at-a-time Phase 2; no parallel service drafts |

---

## Risk Register

| ID | Risk | Prob | Impact | Mitigation |
|----|------|------|--------|------------|
| R1 | Theme/Hugo mismatch blocks foundation | High | High | Resolve ADR-01 in Creative first |
| R2 | Content drift from style guide | Med | High | Review protocol; style guide always open during draft |
| R3 | Image exhaustion on System Design | Med | Med | Edit assets; controlled gallery reassignment |
| R4 | Form backend PII leak | Low | High | No email/phone fields required for display; don’t log bodies with secrets |
| R5 | Autoscroll a11y/perf issues | Med | Med | Creative C4; reduced-motion; lazy load |

---

## Milestones

| ID | Milestone | Status |
|----|-----------|--------|
| M0 | PLAN complete | **Done** |
| M1 | Creative C1 + Phase 0 foundation green | **Done** (Gate 0) |
| M2 | Home live (reviewed) | **Done** (Gate 1) |
| M3 | All four services live (reviewed) | Not started |
| M4 | Gallery + Contact live | Not started |
| M5 | Hardening + reflect + archive | Not started |

---

## Work Breakdown (tracking)

### S0 Foundation — Status: **Complete** (Gate 0)

- [x] ADR-01 closed (Option A)
- [x] Upgrade Hugo ≥ 0.158 + pin No Fate
- [x] Theme/layouts baseline + kraft extended CSS
- [x] Content stubs + menus
- [x] Image register created
- [x] Makefile build/serve (`publishDir` → `site`)
- [x] Gate 0 passed

### S3 Home — Status: **Complete** (Gate 1 passed)

- [x] C2 complete
- [x] Bio drafted + reviewed (3rd person, 210w)
- [x] Panoramic hero assigned in image register (`20150203_190036-1` → locked/home)
- [x] Built + Gate 1

### S4 Services — Status: Unblocked — **Phase 2 next**; C3 done

- [ ] PM → Gate 2.1
- [ ] TD → Gate 2.2
- [ ] CT → Gate 2.3
- [ ] SD → Gate 2.4

### S5 Gallery — Status: Blocked on S0 + image leftovers; C4 done

### S6 Contact — Status: Blocked on S0; C5 done

- [x] C5 complete
- [ ] Form + thanks + Turnstile + env webhook
- [ ] Footer LinkedIn sitewide
- [ ] Gate 4

### S7 Hardening — Status: Blocked on S3–S6

---

## Source References

- `assets-general/personal/biography/cappy_longForm_biography.md`
- `assets-general/personal/biography/cappy_writing_style_guide.md`
- `assets-general/personal/Cappy_CV/superCV.yaml`
- `docs/pages.md`
- `images/` (creativeTech, gallery, logos, prodMan, sysDesign, techDir)
- Theme: https://github.com/OliverObst/no-fate (if Option A)

## PLAN Verification

- [x] Requirements documented
- [x] Technology stack documented (+ validation gaps explicit)
- [x] Subsystems / components identified
- [x] Phased implementation plan detailed
- [x] Dependencies documented
- [x] Challenges & mitigations addressed
- [x] Creative phases identified
- [x] `tasks.md` updated with plan
- [x] Technology validation **fully** complete (Phase 0 / Gate 0)

## Routing

**All creative phases complete (C1–C5).**

**Phase 0 reflected. Phase 1 (Home) built and gated.** Full-task `/archive` deferred until Gate 5.

**→ `/build`** — Phase 2 Production Management next, then Technical Direction → Creative Technology → System Design → Gallery → Contact per plan gates.

Do not skip content-review or image-register gates.
