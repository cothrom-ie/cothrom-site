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

**Proven (Phase 4):** The section-name-template pattern and the single-page equivalent compose cleanly for a section with mixed Kinds: Contact's main page (`content/contact/_index.md`, Kind `section`) uses `layouts/section/contact.html`; its one child leaf page (`content/contact/thanks/index.md`, Kind `page`) uses `layouts/contact/single.html`. Since each Hugo template-lookup chain (`section/*.html` vs `<type>/single.html`) only ever matches its own Kind, the two overrides don't collide even though they live in the same content section — no need to fork a shared layout or juggle mode dispatch for either.

## Hugo env-var config overlay (gotcha, Phase 4)

Hugo's `HUGO_PARAMS_*` environment-variable config overlay treats **every underscore as a new nesting level**, not a literal character within a key. `HUGO_PARAMS_CONTACT_WEBHOOK_URL` therefore sets `params.contact.webhook.url` (three levels), **not** the probably-intended `params.contact.webhook_url` (two levels, with an underscore in the leaf key) — confirmed via `hugo config` with the env var set. Any `hugo.toml` param key that needs to be overridden this way at build time must be a single unbroken word (e.g. `webhookurl`, `turnstilesitekey`), not snake_case. Verify any new env-injected param with `HUGO_PARAMS_<PATH>=value ./bin/hugo config | grep -A3 params.<section>` before wiring it into a template — a silent no-op (falls back to the empty default) is the only symptom otherwise, no warning or error.

## Deploy pattern

`hugo` publish directory must match compose volume (`./site` preferred). Makefile owns the contract (`HUGO`, `HUGO_CACHEDIR=./temp/hugo_cache`, `publishDir=site`).

**Proven (Phase 5):** NGINX serves `./site` with baseline AppSec headers (`X-Content-Type-Options`, `X-Frame-Options`, `Referrer-Policy`, scoped CSP allowing Cloudflare Turnstile), explicit `application/manifest+json` for `.webmanifest`, and `error_page 404 /404.html`. Verify hardening against a **real** nginx container (`docker compose up -d --force-recreate nginx`), not only `hugo server` — MIME, headers, and true 404 status only show up on the compose path. README documents Build / Env / Deploy contracts.

## Hardening patterns (Phase 5)

- **Gitignore:** Never blanket-ignore `static/`; anchor root photo library as `/images/` so `static/images/` chrome stays trackable. Verify with `git check-ignore -v`.
- **Open Graph site override:** Upstream No Fate v0.1.0 `opengraph.html` called `partial "_funcs/get-page-images"` (wrong path; sibling `twitter_cards.html` uses `templates/_funcs/get-page-images`). Fix via same-path site override — do not edit the theme. Home’s bespoke `opening.image` also needs `seo.image` so social cards resolve.
- **404 under `clean`:** Theme `.not-found` CSS assumes richer `wild` overrides; site override uses kraft-plate language (`layouts/404.html` + `assets/css/extended/404.css`).
- **Taxonomies:** Empty `[taxonomies]` when unused — otherwise Hugo publishes empty `/tags/` `/categories/` into the sitemap.
- **a11y gate:** axe-core via Playwright across all routes, light **and** dark (`colorScheme: "dark"`); chain Hugo server start + scan in one shell call (sandbox network isolation).

## Contact / footer patterns (C5) — implemented Phase 4

- Form: HTML POST → n8n webhook URL from **`hugo build`-time env** (`N8N_CONTACT_WEBHOOK_URL`), bridged into Hugo's config overlay by the Makefile (`-include .env`); see the env-var-overlay gotcha above for why the `hugo.toml` keys are `webhookurl`/`turnstilesitekey`, not snake_case
- Fields: name, email, message + honeypot (`name="website"`, visually hidden via clip-to-1px, not `display:none`, + `tabindex="-1"` + `aria-hidden`); Turnstile site key from env, widget/script only rendered when the key is set
- Success: `/contact/thanks/` (leaf page, link list generated from `site.Menus.main` + `site.Params.social.linkedin`)
- Error: n8n redirects failures to `/contact/?error=1`; inline script reveals `#nf-contact-error` on that query param
- LinkedIn in Contact (L1, `layouts/section/contact.html`) **and global footer** on every page (`layouts/_partials/footer.html` site override, full theme-file copy + one added link)
- Turnstile secret verifies in n8n only — never read by Hugo or present in static output
- `.env.example` (committed) documents the env contract; real `.env` stays gitignored; build degrades gracefully (empty action, dev note) with no env vars set

## Security patterns

- Never publish email/phone from CV
- Contact: validate input; spam protection; no secret logging
- No hardcoded credentials / webhook URLs in git
- Static assets only in public tree (no raw `assets-general` exposure)
