# Bug Fix Archive: Nav chrome — light-only + logo beside site name

## Date

2026-10-26

## Summary

Removed the header's dark/light Theme toggle (site is now light-only, no `prefers-color-scheme`/localStorage flip) and added the Cothrom kraft triskelion mark to the left of the "Cothrom" site label in the header. Implemented via Hugo config + a new site-level `header.html` override; theme submodule untouched.

## Implementation

- **Config lock:** `hugo.toml` sets `defaultTheme = "light"`, `disableThemeToggle = true`, `params.noFate.showThemeToggle = false`. This also suppresses No Fate's `theme-toggle.js` bundle via the pre-existing `footer.html` site override's conditional.
- **Logo wiring:** `params.label.logo = "/images/logos/cothrom-mark-kraft.svg"`.
- **Header override:** new `layouts/_partials/header.html` drops the `#theme-toggle` button markup entirely (not just hidden) and renders `<img class="nf-site-logo">` (28×28, decorative `alt=""`) before the label inside the existing `.nf-site-title` link. No new CSS needed — the theme's flex `column-gap` on `.logo a` already spaces logo and text.
- **Asset:** kraft mark (`img-101` in `docs/image-register.md`, previously "candidate") copied to `static/images/logos/cothrom-mark-kraft.svg` and locked for this use.
- **Dictionary:** `triskelion` added to `cspell.config.yaml`.

## Files Changed

- `hugo.toml`
- `layouts/_partials/header.html` (new)
- `static/images/logos/cothrom-mark-kraft.svg` (new)
- `cspell.config.yaml`
- `docs/image-register.md`

## Testing Performed

| Criterion | Test | Result |
|-----------|------|--------|
| Clean build | `make build` | **PASS** — 15 pages, 0 WARN/ERROR |
| Toggle button removed | `grep 'id="theme-toggle"'` across `site/` | **PASS** — none |
| Toggle JS not bundled | `find site -iname '*theme-toggle*'` | **PASS** — none |
| Light locked regardless of OS pref | Playwright, `colorScheme: 'dark'` → `document.documentElement.dataset.theme` | **PASS** — `light` |
| Logo renders beside label | Playwright `.nf-site-logo` present, 28×28, before "Cothrom" | **PASS** (desktop 1440×900 + mobile 390×844) |
| Spelling | `cspell` on changed files | **PASS** (after adding `triskelion`) |

## Lessons Learned

- Keeping site overrides (`header.html`, `footer.html`) tracking the same theme feature flags as the originals meant this fix only needed one new override file, not two — `footer.html`'s script-bundling conditional (from earlier Contact/LinkedIn work) already matched the toggle flag.
- Hugo theme toggles backed by `localStorage`/`prefers-color-scheme` need an explicit test with a forced OS preference (not just default browser state) to prove the lock actually holds.

## Related Work

- Reflection: `memory-bank/reflection/reflection-nav-chrome-light-logo.md`
- Resolves the deferred "Theme-toggle label polish" item from `memory-bank/reflection/reflection-cothrom-site.md`
- Parent site: `memory-bank/archive/archive-cothrom-site.md`

## Notes

Level 1 quick fix — no creative phase, no architecture impact.
