# Tasks

## Active Enhancements

_(none — ready for next `/van`)_

---

## Completed Enhancements

- [x] **gallery-tiled-grid** Level 2 (2026-10-30)
  - Issue: Owner disliked the autoscrolling marquee; wanted photos to auto-pack to the
    page width without having to crop anything, stay easy to extend, and clicking a photo
    should show a larger framed version with a caption.
  - Decision: `memory-bank/creative/creative-gallery-tiled.md` — justified row-packing
    (Flickr/Google-Photos style), implemented as a small dependency-free vanilla JS
    algorithm (no npm/node pipeline in this repo; rejected adding a third-party layout
    library per AppSec "no new dependency without review"). Every tile's box aspect ratio
    is set to exactly match its photo, so nothing is ever cropped or stretched.
  - Solution: static grid replaces the marquee; rows auto-pack flush to the container
    width; CSS-only no-JS fallback also respects native aspect ratio via inline
    `aspect-ratio`; lightbox now shows a visible `<figcaption>` with the photo's `alt` text.
  - Verified: `make build` clean; browser-checked desktop row packing, narrow-viewport
    reflow, and lightbox+caption via a local nginx preview.
  - Files: `layouts/section/gallery.html`, `layouts/_partials/gallery/item.html`,
    `assets/css/extended/gallery.css`, `README.md`,
    `memory-bank/creative/creative-gallery-tiled.md`
- [x] **footer-layout-breadcrumbs** Level 1 (2026-10-30)
  - Issue: Breadcrumb links under page headings felt noisy; footer LinkedIn was a plain text link.
  - Solution: `ShowBreadCrumbs = false`; footer LinkedIn as standard “in” SVG icon flush left (LinkedIn blue), copyright centred in a thin full-width bar.
  - Files: `hugo.toml`, `layouts/_partials/footer.html`, `assets/css/extended/kraft.css`
- [x] **service-secondary-images** Level 2 secondary images on service pages (2026-10-27) — `memory-bank/archive/archive-service-secondary-images.md` — reflection: `memory-bank/reflection/reflection-service-secondary-images.md`
- [x] nav-chrome-light-logo Level 1 light-only + header logo (2026-10-26) — `memory-bank/archive/archive-nav-chrome-light-logo.md`
- [x] deploy-cf-pages Level 2 Cloudflare Pages GHA (2026-10-26) — `memory-bank/archive/archive-deploy-cf-pages.md` — **operator go-live confirmed 2026-10-26**
- [x] cothrom-site Level 4 full site (2026-10-26) — `memory-bank/archive/archive-cothrom-site.md`
