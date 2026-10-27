# Level 2 Enhancement Reflection: Service page secondary images

**Task ID:** `service-secondary-images`  
**Complexity:** Level 2 (Simple Enhancement)  
**Date:** 2026-10-27  
**Workflow:** VAN → PLAN → BUILD → REFLECT (no creative phase — executes locked C3 E1)

---

## Enhancement Summary

Added one secondary/evidence image to each of the four service pages (production-management, technical-direction, creative-technology, system-design), floated right beside body copy so the image's right edge aligns with the hero's right edge, with each image keeping its native aspect ratio. Delivered via new page-resource JPGs from `images/new/*Second*`/`*Sec*` sources, `visual.secondary`/`visual.secondary_alt` front matter, a site-level editorial `body.html` override, and CSS in `kraft.css`. New hero images in `images/new/` were left untouched (different project). Fulfils Creative C3 decision E1 once spare unique shots existed.

---

## What Went Well

- **Scope inference from assets held:** Naming in `images/new/` (exactly one secondary per service, none for Home; five `*Hero*`/`homeHero` files to ignore) matched the user's intent without a clarifying round-trip.
- **Theme-safe content model:** Reading `content-model.html` confirmed unknown `visual.*` keys are ignored — safe to add `secondary`/`secondary_alt` without forking or extending the theme.
- **Float placement chosen correctly up front:** Figure lives as the first child inside `.post-content` (normal flow), not as a sibling of it inside the grid `.nf-article__body` — floats don't interact across grid items; that architectural call avoided a dead-end layout.
- **Image-prep convention reused:** Long-edge 2400px cap, never upscale, PNG→JPG q85 — `techDirSec` stayed at native 1452×1512; aspect-ratio flexibility came free.
- **Verification culture paid off:** Playwright geometric measurement (hero vs secondary `right` edges) caught a 591px miss that a clean `make build` alone would have passed; screenshots + mobile unfloat checks closed the loop.
- **Register discipline:** Four secondary rows locked; five reserved hero/home rows documented as out of scope so the next project doesn't re-discover the boundary.

---

## Challenges Encountered

- **Planned CSS fix incomplete:** VAN/PLAN measured only `.nf-article__body`'s `--nf-article-width` gap (~32px/side). After shipping `--nf-article-width: none`, secondary still sat at `right:785` vs hero `1376` — a second, independent theme cap was clipping the float.
- **Theme's prose container is width-capped, not just text:** `40-typography.css` sets `max-width: var(--nf-reading-measure)` (68ch) on `.md-content`/`.nf-prose` itself; the float lives inside that box.
- **Naïve per-child re-cap introduced a new bug:** Re-applying `68ch` to every markdown child individually made headings over-wide and auto-centred — `ch` resolves against the element's own font-size, and `.md-content h2 { margin: … auto … }` centres any width-constrained heading.
- **Hugo `with` scope trap (caught before ship):** An intermediate template edit used `{{ . }}` inside `with $secondary` for content — that would have rendered the filename, not body HTML. Fixed by capturing `$content := $page.Content` and using `$secondary` via `if`, not `with`.

---

## Solutions Applied

- Lifted `.nf-prose` max-width to `none` on the editorial body only; re-applied 68ch once to a dedicated `.nf-service-text` wrapper around `{{ .Content }}` (only when a secondary image is present).
- Wrapper inherits body font-size and has no `margin: auto` rule targeting it — consistent measure, no centring artefact; float can reach full hero width.
- Re-ran Playwright after the second fix: all four pages `secondary.right === hero.right === 1376`; text measure ~721px left-aligned; mobile `float:none`, overflow 0.

---

## Key Technical Insights

- **Measure before trusting a single token:** When aligning to another box, inventory *all* max-width / measure ancestors (article shell *and* typography containers), not just the obvious article-width token.
- **`ch` is font-relative:** Never apply a `ch`-based reading measure to headings (or any element with a larger font) if you need a consistent column; cap a plain wrapper at body size instead.
- **Float + grid don't mix as siblings:** Float must share a normal-flow container with the text it wraps; site-owned editorial body override is the right place for this pattern on No Fate.
- **Theme CSS can have two independent "reading" caps** (`--nf-article-width` and `--nf-reading-measure` on `.nf-prose`) that look like one system until you need a float to break out of the prose column while keeping text measure.

---

## Process Insights

- **Geometric acceptance criteria belong in the plan:** "right edges match (±1–2px)" as a Playwright check should have been paired, during VAN, with a cascade scan of *every* max-width on the float's ancestors — would have surfaced the second cap before the first BUILD attempt.
- **First failed verification is cheap; silent visual miss is expensive:** Prefer measuring the acceptance criterion immediately after the first build over assuming the planned one-liner CSS is enough.
- **Document the failed intermediate fix in tasks.md** (as done during BUILD) — it turns a reflection lesson into archive-ready evidence and stops the next agent from repeating the per-child `ch` mistake.
- Level 2 without CREATIVE was correct: layout was user-specified and C3 E1 was already locked.

---

## Action Items for Future Work

1. **When aligning site chrome to a hero/full content box:** During VAN, list every `max-width` / `width` / custom-property measure on the target element *and its ancestors* before drafting the CSS plan.
2. **Prefer a single measure wrapper** over per-child `max-width: …ch` whenever body and headings must share a column beside a float or aside.
3. **Optional follow-up (out of scope):** If/when the reserved `images/new/*Hero*` assets are used in another project, start from the register's `reserved` rows rather than re-scanning the folder.
4. Proceed to **`/archive`** for this task.

---

## Time Estimation Accuracy

- **Estimated:** Half-day Level 2 (image prep + front matter + template + CSS + register + visual check).
- **Actual:** Same calendar day (2026-10-27); one extra BUILD iteration for the second width-cap + heading-centring bug.
- **Variance:** Modest overrun (~one verification/fix cycle beyond the plan).
- **Reason:** VAN measured only the article-width gap; the typography-layer 68ch cap on `.nf-prose` was not in the plan, and the first remediation attempt introduced a second layout bug before the wrapper fix landed.

---

## Reflection vs plan

| Plan item | Outcome |
|-----------|---------|
| Image prep (4 JPGs, no upscale, flexible AR) | Done as planned |
| Front matter `visual.secondary` / `_alt` | Done as planned |
| Floated figure inside `.post-content` | Done as planned |
| `--nf-article-width: none` alone | **Insufficient** — needed `.nf-prose` lift + `.nf-service-text` wrapper |
| Mobile unfloat under 40rem | Done as planned |
| Register lock + hero exclusion note | Done as planned |
| Playwright right-edge + mobile checks | Done; failed once, then passed after fix |

---

## Cross-links

- Task detail: `memory-bank/tasks.md` (Active: `service-secondary-images`)
- Build observations: `memory-bank/progress.md`
- Creative decision executed: C3 E1 (service page template)
- Next: `/archive` → `memory-bank/archive/archive-service-secondary-images.md`
