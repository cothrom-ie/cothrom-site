# Enhancement Archive: Service page secondary images

## METADATA

| Field | Value |
|-------|-------|
| **Task ID** | `service-secondary-images` |
| **Name** | Service page secondary images (right-aligned, hero-width, flexible aspect) |
| **Complexity** | Level 2 (Simple Enhancement) |
| **Type** | Content / layout |
| **Workflow** | VAN → PLAN → BUILD → REFLECT → ARCHIVE (no creative phase — executes locked C3 E1) |
| **Date opened** | 2026-10-27 |
| **Date completed** | 2026-10-27 |
| **Status** | **COMPLETED** |
| **Repo / branch** | `cothrom-ie/cothrom-site` · `main` |
| **Reflection** | `memory-bank/reflection/reflection-service-secondary-images.md` |

---

## SUMMARY

Added one secondary/evidence image to each of the four service pages, floated to the right of the body copy so the image's **right edge aligns with the hero's right edge**, with **native aspect ratios preserved** (no forced uniform crop). Sources were the `*Second*`/`*Sec*` files in `images/new/`; the five new hero/home images in that folder were left untouched (reserved for a different project). Fulfils Creative **C3 decision E1** once spare unique shots existed.

BUILD discovered that the planned single CSS override was insufficient: a second theme width cap on `.nf-prose` clipped the float; a naïve per-child `ch` fix then auto-centred headings. Final pattern: uncapped editorial prose container + one `.nf-service-text` measure wrapper + floated `.nf-service-secondary`.

---

## REQUIREMENTS ADDRESSED

- One secondary image per service page (production-management, technical-direction, creative-technology, system-design)
- Image sits to the right alongside body text
- Secondary image's right edge aligns with the hero's right edge
- Flexibility in aspect ratio across pages
- Ignore / do not use `images/new/*Hero*.png` and `homeHero.png` (different project)
- Theme files untouched; site-level overrides only

---

## IMPLEMENTATION DETAILS

### Approach

- Page resources `content/<page>/secondary.jpg` from PIL resize (long edge ≤2400px, never upscale, PNG→JPG q85)
- Front matter `visual.secondary` / `visual.secondary_alt` (theme `content-model.html` ignores unknown keys)
- Site override `layouts/_partials/modes/editorial/body.html`: floated figure as first child of `.post-content`; when secondary is set, wrap `{{ .Content }}` in `.nf-service-text`; `errorf` if `secondary` without `secondary_alt`
- CSS in `assets/css/extended/kraft.css`:
  - `--nf-article-width: none` on `.nf-article__body--editorial`
  - `max-width: none` on editorial `.post-content.nf-prose`
  - `max-width: var(--nf-reading-measure)` on `.nf-service-text`
  - `.nf-service-secondary { float: right; width: clamp(14rem, 34vw, 24rem); … }` — unfloats under 40rem

### Image mapping

| Source | Published | Size after prep |
|--------|-----------|-----------------|
| `images/new/prodMan_second.png` | `content/production-management/secondary.jpg` | 2400×2238 |
| `images/new/techDirSec.png` | `content/technical-direction/secondary.jpg` | 1452×1512 (native) |
| `images/new/creatTechSecond.png` | `content/creative-technology/secondary.jpg` | 1893×2400 |
| `images/new/sysDes_second.png` | `content/system-design/secondary.jpg` | 1858×2400 |

### Key files modified

- `content/{production-management,technical-direction,creative-technology,system-design}/index.md`
- `content/{…}/secondary.jpg` (4 new page resources)
- `layouts/_partials/modes/editorial/body.html`
- `assets/css/extended/kraft.css`
- `docs/image-register.md` (4 locked + 5 reserved rows)
- `cspell.config.yaml` (`creat` for `creatTech*` filenames)

### Theme files

None edited.

---

## TESTING PERFORMED

| Criterion | Result |
|-----------|--------|
| `make build` (incl. clean rebuild) | **PASS** — 15 pages, 0 WARN/ERROR |
| Playwright @1440×900: secondary `right` vs hero `right` | **PASS** — both `1376px` on all 4 pages (after final CSS fix) |
| Playwright: reading measure (`.nf-service-text`) | **PASS** — ~721px, left-aligned, no heading auto-centre |
| Playwright @390×844: unfloat + overflow | **PASS** — `float:none`, overflow 0px |
| Alt text in rendered HTML | **PASS** — all 4 pages |
| `cspell` on changed files | **PASS** |
| Visual screenshots (4×2 breakpoints) | **PASS** — reviewed |

### Bug found during BUILD (resolved)

1. After `--nf-article-width: none` only: secondary still at `right:785` (591px gap) — `.nf-prose` separately capped at 68ch in theme `40-typography.css`.
2. Per-child `max-width: 68ch` fixed alignment but mis-centred headings (`ch` is font-relative; theme `h2` uses `margin: … auto …`).
3. Final: `.nf-service-text` wrapper capped once at body font-size.

---

## LESSONS LEARNED

- When aligning to a hero/full content box, inventory **all** max-width ancestors during VAN — not only `--nf-article-width`.
- Prefer one body-size measure wrapper over applying `ch` to each markdown child (headings resolve `ch` differently).
- Floats must share a normal-flow container with wrapped text; do not float as a sibling of a CSS Grid item.
- Geometric Playwright acceptance criteria catch misses a clean Hugo build will not.

---

## RELATED WORK

- Reflection: `memory-bank/reflection/reflection-service-secondary-images.md`
- Creative decision executed: C3 E1 (service page template — optional one inline image)
- Parent site: `memory-bank/archive/archive-cothrom-site.md`
- Service heroes (Phase 2): same leaf-bundle + editorial mode pattern

---

## NOTES

- Level 2 without CREATIVE was correct: layout was user-specified; C3 E1 already locked.
- Reserved assets (`images/new/*Hero*`, `homeHero.png`) remain on disk and in the register as `reserved` — do not reassign without a new task.
- Ephemeral working detail from `tasks.md` is preserved in this archive and the reflection doc.
