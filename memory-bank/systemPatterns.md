# System Patterns

## Architecture style

**Static site generation (Hugo) + NGINX static serve.** Editorial sources remain offline; published site is Markdown-driven HTML with deliberate image assignment. Only dynamic edge is the contact form submission target.

## Site structure (target)

```text
content/_index.md
content/contact/
content/gallery/            (branch bundle; photos/ subfolder of page resources)
content/production-management/   (leaf bundle; hero.jpg)
content/technical-direction/     (leaf bundle; hero.jpg)
content/creative-technology/     (leaf bundle; hero.jpg)
content/system-design/           (leaf bundle; hero.jpg)
```

Shared chrome: nav, footer, logos from `images/logos/` → `static/`.

## Content pipeline pattern

1. Read page brief (`docs/pages.md`)
2. Pull facts from `superCV.yaml` + narrative from biography
3. Apply writing style guide
4. Draft → content review gate → revise → lock
5. Assign unique images from register → edit if needed → copy into Hugo paths

## Image pattern

- Working inventory: `images/{prodMan,techDir,creativeTech,sysDesign,gallery,logos}/`
- Register: `docs/image-register.md` (Phase 0)
- Duplicate basenames: one published role only (service preferred over gallery)
- Logos: brand chrome / favicons only
- Prefer page bundles for service heroes; static for gallery bulk

## Service page skeleton (Creative C3)

Hero (full-bleed + kraft plate + service title) → Who it's for → What it's for → How it works → Evidence (bio/CV) → Often paired with (≤2 links) → Next step CTA — one shared skeleton, distinct copy per page; no cards.

**Proven (Phase 2):** No Fate's mode-based rendering (`modes/%s/opening.html` / `modes/%s/body.html` dispatch, hero figure, OG/Twitter/schema image wiring) only applies to pages of Kind `page` — i.e. **leaf bundles** (`index.md` inside the content directory). A content directory using `_index.md` (**branch bundle**) is Kind `section`/`home`/etc. and is rendered by the theme's generic `list.html` instead, which has no mode dispatch and never shows a hero image, even with `content.format`/`visual.mode`/`visual.hero` all set correctly in front matter. Symptom: `make build` stays green (no warnings — `validate-content-model.html` also only runs for `.IsPage`, so it silently skips section pages too), but the rendered page is a plain archive-style list with none of the intended editorial chrome. **Rule of thumb:** any content page that should render via `single.html` (editorial/poster/archive/record modes, hero images, mode dispatch) must be a leaf bundle (`index.md`), matching how the theme's own leaf-bundle content types (artefact/essay/history/note/project/question) are structured. Reserve `_index.md` branch bundles for true list/section pages and for Kind-`home` (Home always uses `home.html` regardless of filename).

## Theme pattern

No Fate: configure via `params.noFate`; override via site `layouts/` and `assets/css/extended/`; **do not edit** `themes/no-fate`. Pin tag/commit (**v0.1.0** / `f2703f64` as of Phase 0).

**Proven (Phase 0):** kraft remap of `--nf-*` tokens in `assets/css/extended/kraft.css`.

**Proven (Phase 1):** Full template override via same-path site files (`layouts/home.html`, `layouts/_partials/home/opening.html`) to change structure (theme's 2-col split → full-bleed + overlay plate) while reusing theme CSS classes (`.nf-home-module`, `.nf-home-module__heading/__items`) for free styling consistency. Visual check via locally-installed Playwright Chromium (`npm install --no-save playwright` + `npx playwright install chromium`) since the IDE browser tool cannot reach the project's local dev server (separate network namespace) — use this pattern for future phase visual gates.

**Proven (Phase 2):** Narrow, mode-scoped partial overrides (`layouts/_partials/modes/editorial/opening.html` + `.../body.html`, not the shared `article-shell.html` used by poster/archive/record too) keep a structural change — H1 full-bleed hero + kraft plate, reusing the native `visual.hero` front-matter key for free OG/Twitter/schema wiring — scoped to exactly the mode/pages that need it, written once and reused by all four service pages. `body.html` is a trimmed copy of the theme's `article-shell.html` body with the hero/cover branch removed (since the opening override already renders it full-bleed), avoiding a duplicate image further down the page.

**Proven (Phase 3):** For a page that needs a *fully custom* layout with no relationship to No Fate's article modes at all (Gallery's marquee), the cleanest override point is a **section-name template** — `layouts/section/<name>.html` — which Hugo's template lookup picks ahead of the theme's `_default/list.html` for that one section only, leaving every other section on the theme default. No mode dispatch, no `content-model.html` involvement; the section stays a plain branch bundle (`_index.md`). Contrast with Phase 2: use this pattern when the page's rendering has nothing to do with No Fate's editorial/poster/archive/record modes; use the mode-partial-override pattern when it's a variation *within* one of those modes.

## Deploy pattern

`hugo` publish directory must match compose volume (`./site` preferred). Makefile owns the contract (`HUGO`, `HUGO_CACHEDIR=./temp/hugo_cache`, `publishDir=site`).

## Contact / footer patterns (C5)

- Form: HTML POST → n8n webhook URL from **Docker/env** (`N8N_CONTACT_WEBHOOK_URL`)
- Fields: name, email, message + honeypot; Turnstile site key from env
- Success: `/contact/thanks/`
- LinkedIn in Contact (L1) **and global footer** on every page
- Turnstile secret verifies in n8n only — never in static output

## Security patterns

- Never publish email/phone from CV
- Contact: validate input; spam protection; no secret logging
- No hardcoded credentials / webhook URLs in git
- Static assets only in public tree (no raw `assets-general` exposure)
