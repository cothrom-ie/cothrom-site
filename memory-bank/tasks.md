# Tasks

## Active Enhancements

_(none — ready for next `/van`)_

---

## Completed Enhancements

- [x] **contact-hero-center** Level 1 (2026-11-01)
  - Issue: On Contact, the kraft plate and portrait sat left, with empty space on the right. The form was already centered.
  - Solution: `justify-content: center` on `.nf-contact-hero__layout--with-portrait` so the pair shares the form's center. Phone layout still stacks full width.
  - Files: `assets/css/extended/contact.css`
- [x] **home-bio-above-links** Level 1 (2026-11-01)
  - Issue: Home below-fold order put the Services links above the About biography.
  - Solution: Reordered `layouts/home.html` to Biography, then Services links, then Writing stub.
  - Files: `layouts/home.html`
- [x] **home-contact-portraits** Level 2 (2026-10-31)
  - Issue: Add home About secondary + Contact self-shot from new exports.
  - Solution: Optimized to `content/cothrom-home-secondary.jpg` (360×468, no upscale)
    and `content/contact/me.jpg` (1920×1504); Home floats secondary beside bio via
    `about.image` / `about.image_alt`; Contact shows portrait beside kraft plate via
    `portrait.image` / `portrait.image_alt` (C5 H1 photo optional). Register locked.
  - Files: `content/_index.md`, `content/cothrom-home-secondary.jpg`,
    `content/contact/_index.md`, `content/contact/me.jpg`, `layouts/home.html`,
    `layouts/section/contact.html`, `assets/css/extended/kraft.css`,
    `assets/css/extended/contact.css`, `docs/image-register.md`
- [x] **gallery-lightbox-role-event** Level 1 (2026-10-30)
- [x] **optimize-content-images** Level 1 (2026-10-30)
- [x] **gallery-tiled-grid** Level 2 (2026-10-30)
- [x] **footer-layout-breadcrumbs** Level 1 (2026-10-30)
- [x] **service-secondary-images** Level 2 (2026-10-27)
- [x] nav-chrome-light-logo Level 1 (2026-10-26)
- [x] deploy-cf-pages Level 2 (2026-10-26)
- [x] cothrom-site Level 4 (2026-10-26)
