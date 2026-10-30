# Active Context

## Mode

**Idle** — last task archived; ready for **`/van`**

## Current task

_(none)_

## Recently completed

- `gallery-lightbox-role-event` — Level 1 (2026-10-30): lightbox caption is YAML `role` / `event` with bold labels
- `optimize-content-images` — Level 1 (2026-10-30): `make optimize-images` resizes/re-encodes `content/` rasters to JPG max-width 1920 in place
- `gallery-tiled-grid` — Level 2 (2026-10-30): marquee → justified tiled grid, no manual crop, lightbox caption
- `footer-layout-breadcrumbs` — Level 1 (2026-10-30): breadcrumbs off; LinkedIn icon left / copyright centre in footer
- `service-secondary-images` — archive `memory-bank/archive/archive-service-secondary-images.md` (2026-10-27)
- `nav-chrome-light-logo` — archive `memory-bank/archive/archive-nav-chrome-light-logo.md`
- `deploy-cf-pages` — archive `memory-bank/archive/archive-deploy-cf-pages.md` (go-live confirmed)

## Notes for next task

- To shrink sources before Hugo: `make optimize-images` (preview with `DRY_RUN=1`). Then rebuild so derivatives refresh.
- Gallery is now a justified-row tiled grid (`memory-bank/creative/creative-gallery-tiled.md`) — adding a photo is just a file drop + one front-matter entry; no cropping or manual layout required.
- Service pages now have hero + optional secondary (C3 E1 fulfilled for all four).
- `images/new/*Hero*` and `homeHero.png` remain **reserved** in `docs/image-register.md` — use only under a new explicit task.
