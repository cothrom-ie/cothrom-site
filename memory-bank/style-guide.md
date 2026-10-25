# Style Guide (site)

## Voice & writing (authoritative)

Primary source: `assets-general/personal/biography/cappy_writing_style_guide.md`

Also apply: Website-Wide Editorial Principles in `docs/pages.md`.

Summary constraints for implementers:

- Professional, confident, collaborative
- No exaggerated marketing language
- Audience-appropriate clarity per service page
- Problems/value first; not bare duty lists
- Do not invent experience

## Brand / visual (site) — C1 locked

**Direction:** Kraft-led (V1), photography dominant.  
**Theme:** No Fate, base style `clean`, kraft/ink overrides via site extended CSS.  
**Colour mode:** System (`prefers-color-scheme`) + toggle if available.  
**Detail:** `memory-bank/creative/creative-theme-visual-system.md`

### Tokens

| Token | Value | Use |
|-------|-------|-----|
| `--brand-kraft` | `#BE9E6C` | Surfaces, logo ground, soft accents |
| `--brand-ink` | `#1D120D` | Mark, text on kraft, dark accents |

### Rules of thumb

- Cothrom mark/logo is a hero-level brand signal on Home — not nav-only
- Prefer real production photography over abstract decoration
- Kraft as material/accent; do not turn the whole site into a flat cream+terracotta template
- No cards in hero; one composition in the first viewport
- Service pages: imagery from dedicated folders; Gallery: central visual record
- Preserve No Fate patterns unless a later CREATIVE phase overrides

## Home composition (C2 locked)

Detail: `memory-bank/creative/creative-home-composition.md`

- **Hero (H2):** Full-bleed photo (prefer **panoramic/wide** event shots) + grounded kraft brand plate
- **Brand (N1):** Cothrom mark/wordmark only in hero — Dominic named in bio
- **CTAs (C2):** Primary **Services**; secondary Contact + Gallery
- **Below fold (B2):** Service links → bio → **Writing** stub (no papers yet; one soon)
- **Bio:** 150–250 words, **third person**, from long-form biography

## Service pages (C3 locked)

Detail: `memory-bank/creative/creative-service-page-template.md`

- **Skeleton (S1):** Hero → Who it’s for → What it’s for → How it works → Evidence → Often paired with → Contact CTA
- **Hero (H1):** Panoramic full-bleed + kraft plate with **service title** (site mark in nav)
- **Images (E1):** Hero only; at most one optional inline if uniquely available
- **Related (R1):** ≤2 quiet text links; no comparison tables
- **Voice (V1):** Light “you” for audience; third person for evidence
- **No Fate mode:** `editorial`

## Gallery (C4 locked)

Detail: `memory-bank/creative/creative-gallery-autoscroll.md`

- **Motion (M1):** Continuous horizontal marquee; pause on hover/focus
- **Layout (L1):** Single full-bleed row (panoramic-friendly)
- **Interaction (I1):** Click → lightbox; **A3:** OS reduced-motion → static grid + always-visible Pause control
- **Set (G1):** Curated 12–24 leftovers only (unique vs Home/services)
- **Chrome (P1):** Title + one short line; No Fate mode deferred at build

## Content length targets

- Home biography: 150–250 words
- Service pages: follow editorial direction in `docs/pages.md`; keep scannable

## Contact (C5 locked)

Detail: `memory-bank/creative/creative-contact-n8n.md`

- **T1** HTML POST to n8n; URL from **Docker/env** (`N8N_CONTACT_WEBHOOK_URL`) — not committed
- **F1** Name, email, message + honeypot
- **U1** `/contact/thanks/`
- **S2** Honeypot + Turnstile (site key via env; secret only in n8n)
- **L1** LinkedIn on Contact **and in footer on every page**
- **H1** Kraft plate invite; no phone/email anywhere
- n8n side-effects (email/Slack/etc.): defer to ops
