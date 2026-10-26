# Quick Fix: Nav chrome — light-only + logo beside site name

**Task ID:** `nav-chrome-light-logo`
**Complexity:** Level 1 (Quick Fix / small UI polish)
**Date:** 2026-10-26
**Workflow:** VAN → BUILD → REFLECT (no PLAN/CREATIVE needed)

## Issue

The header carried a dark/light Theme toggle button (literal "Theme" text, already flagged as deferred polish in the Phase 5 reflection) and showed only the text label "Cothrom" with no brand mark.

## Root Cause

No Fate's default header always renders `#theme-toggle` when `showThemeToggle`/`disableThemeToggle` allow it, and ships light/dark/auto JS to go with it; the site had no logo image wired into `params.label`, so the header fell back to the plain text label only.

## Solution

- Locked the site to light mode and turned the toggle fully off via config (`defaultTheme = "light"`, `disableThemeToggle = true`, `noFate.showThemeToggle = false`), which also suppresses the `theme-toggle.js` bundle via the existing `footer.html` conditional.
- Added a site-level override of `layouts/_partials/header.html` (theme submodule untouched) that drops the `#theme-toggle` markup outright and renders the kraft triskelion mark (`<img class="nf-site-logo">`, 28×28, decorative `alt=""`) before the "Cothrom" label inside the existing `.nf-site-title` link — no extra CSS needed since the theme's flex `column-gap` already spaces logo + text.
- Published the mark at `static/images/logos/cothrom-mark-kraft.svg` and locked the previously-"candidate" `img-101` register row for this new use.

## Files Changed

- `hugo.toml`
- `layouts/_partials/header.html` (new)
- `static/images/logos/cothrom-mark-kraft.svg` (new)
- `cspell.config.yaml`
- `docs/image-register.md`

## Verification

- `make build`: 15 pages, 0 WARN/ERROR.
- Grep/find confirmed no `#theme-toggle` id and no `theme-toggle.js` anywhere in `site/`.
- Playwright: `data-theme="light"` even with `colorScheme: 'dark'` forced (proves the lock isn't just a default that OS prefs could override); `.nf-site-logo` present at 28×28 before the label on both desktop (1440×900) and mobile (390×844) screenshots.
- cspell clean after adding `triskelion`.

## Notes

- This directly resolves the "Theme-toggle label polish" item carried as deferred from the Phase 5 / full-site reflection (`memory-bank/reflection/reflection-cothrom-site.md`) — no longer an open follow-up.
- `footer.html`'s pre-existing conditional script-bundling (from the earlier Contact/LinkedIn work) meant only one new file (`header.html`) was needed to fully remove the toggle, not two — reinforces the value of keeping site overrides tracking the same feature flags as the theme originals.
- No creative-phase or architecture impact; a straightforward Level 1 config + one-partial-override fix.
