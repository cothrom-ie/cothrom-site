# 🎨 CREATIVE PHASE: Gallery — Tiled Justified Grid

**Status:** COMPLETE
**Type:** UI/UX
**Supersedes:** `memory-bank/creative/creative-gallery-autoscroll.md` — Motion (M) and Layout (L) rows only
**Date opened:** 2026-10-30
**Date closed:** 2026-10-30

## Problem statement

The continuous marquee (C4 original) was not landing for the site owner ("I really don't like
the gallery"). Replace it with a tiled layout that:

1. Auto-sorts/packs photos to fit the available width (no awkward gaps or overflow).
2. Needs no disciplined manual cropping — the owner doesn't want that maintenance burden.
3. Stays easy to extend — adding photos should not require re-laying-out anything by hand.
4. Clicking a photo opens a larger version in a frame, with the `alt` text shown as a caption.

## Options considered

| ID | Option | Notes | Result |
|----|--------|-------|--------|
| A | CSS multi-column ("Pinterest" masonry) | Zero JS; `column-count` + `break-inside: avoid`. Columns have independent heights — doesn't "fit the width" per row, can leave a ragged bottom edge, reading order becomes column-major (bad for screen readers/tab order). | Rejected |
| B | Fixed-aspect CSS grid (`object-fit: cover`) | Simple `grid-template-columns: repeat(auto-fill, …)` + a locked aspect-ratio per cell. Requires every photo to be visually fine when cropped to that shared ratio — exactly the "disciplined crop" the owner wants to avoid. | Rejected |
| C | **Justified row-packing** (Flickr/Google-Photos style) | Greedy algorithm: accumulate tiles into a row until their combined width (at a target height) reaches the container width, then solve `rowHeight = (containerWidth − gaps) / Σaspect_i` so the row ends flush with both edges. Each tile's box aspect ratio is set to **exactly** match its photo — no crop, no stretch, ever. "Auto-sorts to fit the width" is literally what this algorithm does. | **Selected** |
| D | Third-party layout library (e.g. `flickr/justified-layout`) | Same algorithm as C, but as an npm dependency. This repo has no Node/npm build step at all (Hugo + vanilla JS/CSS only) — adding one JS dependency would mean standing up a packaging pipeline for a ~100-line, publicly documented algorithm, and triggers the AppSec "no new dependency without explicit approval + review" rule for no real benefit. | Rejected (reimplemented the public technique ourselves instead) |

## Decision

**Option C** — a small, dependency-free, hand-written justified-layout script (inline in
`layouts/section/gallery.html`), paired with a CSS-only (no-JS) fallback that still respects
each photo's native aspect ratio via an inline `aspect-ratio` style, so there's no layout
shift and no cropping in either path.

| Topic | Choice |
|-------|--------|
| Motion | **Static** — no autoscroll/marquee (supersedes C4's M1) |
| Layout | **Full-justified rows** — every row including the last packs to fill container width exactly (supersedes C4's L1 single row). A short last row becomes taller; no photo editing required. |
| Cropping | **None** — every tile's aspect ratio matches its photo exactly; nothing to recrop when adding photos |
| Interaction | **I1 unchanged** — click → lightbox; **new:** visible `<figcaption>` under the enlarged photo showing the photo's `alt` text |
| Updates | Drop a file into `content/gallery/photos/`, add one `image`/`alt` pair to the page's front matter `photos` list — the script repacks rows on load/resize, no manual layout |
| Reduced motion | Mostly moot now (nothing animates); only disables the small hover scale on tiles |
| Dependencies | **None added** — algorithm implemented directly, no npm/node pipeline introduced |

## Validation

- [x] Rows auto-sort/pack to the container's exact width (C)
- [x] Zero manual cropping — tile aspect ratio == photo aspect ratio, always
- [x] Adding a photo is a 2-line content-file edit; no layout maintenance
- [x] Click → lightbox with visible caption (photo's `alt` text)
- [x] No new runtime dependency; no Node/npm pipeline introduced
- [x] Reduced-motion users see the same static grid (no special-casing needed)

## 🎨 EXITING CREATIVE PHASE
