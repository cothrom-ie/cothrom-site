# 🎨 CREATIVE PHASE C4: Gallery Autoscroll

**Status:** COMPLETE  
**Type:** UI/UX + performance  
**Depends on:** C1; image register leftovers after Home/services  
**Date opened:** 2026-10-25  
**Date closed:** 2026-10-25

## Problem statement

Design the Gallery as the central visual record: an autoscrolling photogallery that performs well, respects accessibility, and uses only images not locked to Home/service heroes.

## Decisions (locked)

| Topic | Choice |
|-------|--------|
| Motion | **M1** — Continuous horizontal marquee (infinite loop); pause on hover/focus |
| Layout | **L1** — Single full-bleed row (panoramic-friendly) |
| Interaction | **I1** — Pause on hover/focus; click → lightbox / larger view |
| Reduced motion | **A3** — Honour `prefers-reduced-motion` **and** always-visible **Pause motion** control |
| Set size | **G1** — Curated **12–24** best leftovers |
| Page chrome | **P1** — Title **Gallery** + one short support line |
| No Fate mode | **Defer** to implementer at build (try `archive` if it fits; not blocking) |

## Options considered (summary)

| ID | Options | Selected |
|----|---------|----------|
| M | M1 marquee / M2 carousel / M3 manual-primary | **M1** |
| L | L1 single row / L2 dual / L3 vertical masonry | **L1** |
| I | I1 lightbox / I2 pause-only / I3 click-pause | **I1** |
| A | A1 static grid / A2 prev-next / A3 OS + Pause control | **A3** |
| G | G1 curated / G2 all / G3 curated+more | **G1** |
| P | P1 title+line / P2 title / P3 + body links | **P1** |
| Mode | archive / editorial / defer | **defer** |

### Rationale

- **M1 + L1** match the “autoscrolling photogallery” brief and wide event photos.
- **I1** lets visitors inspect a frame without leaving the ambient scroll as default.
- **A3** avoids trapping vestibular-sensitive users and gives explicit control even when OS doesn’t reduce motion.
- **G1** keeps weight/perf manageable; quality over dumping all 69 files.
- **P1** minimal copy; one job = visual record.
- **Defer mode** avoids forcing a No Fate preset before theme is vendored.

## Page composition (spec)

```text
[Nav]

Gallery
One short support line (measured; no hype)

[ Pause motion ]     ← always visible when marquee is active

┌─────────────────────────────────────────────────────────────┐
│ ▶▶ continuous horizontal strip (full-bleed row) ▶▶          │
│    panoramic-friendly heights; seamless loop                │
└─────────────────────────────────────────────────────────────┘

Click image → lightbox / larger view (focus trap, Esc close)
Hover/focus strip → pause
```

### Reduced motion behaviour (A3)

| Condition | Behaviour |
|-----------|-----------|
| `prefers-reduced-motion: reduce` | Default to **static responsive grid** (same curated set); Pause control hidden or no-op |
| User activates **Pause motion** | Marquee stops; optional freeze on current offset; control becomes **Play** / resume |
| Resume | Restarts marquee from pause point or loop start (pick one at build; document in code comment) |

### Performance

- Lazy-load offscreen strip images (`loading="lazy"` / Intersection Observer as needed)
- Serve appropriately sized derivatives (Hugo image processing or pre-exported widths)
- Cap curated set at 12–24; prefer WebP/AVIF if theme pipeline supports it
- Avoid decoding full 16-bit source PNGs in the browser when possible (export web-sized copies in Phase 0/3)

### Image register rules

- Gallery candidates only from `images/gallery/` (or copies thereof) **not** locked to Home/services
- If basename exists in a service folder and that service locked it, **exclude** gallery twin
- Curate for variety and panoramic strength; document final 12–24 IDs in register as `gallery` locked

### Copy

- Title: **Gallery**
- Support line: one sentence (draft at build; content review); e.g. work across live events and technical production — exact words from style guide voice, no invented claims
- No captions required in v1 (lightbox may show filename or empty alt-appropriate description — prefer meaningful `alt` where content is known)

### Lightbox (I1) minimum

- Open on click/keyboard activate
- Focus trapped; Esc and backdrop click close
- Prev/Next optional in v1 (nice-to-have)
- Does not auto-advance while open

## Implementation guidelines (Phase 3)

1. Prefer CSS animation + small site JS over heavy libraries; override No Fate via site assets/partials
2. Mark marquee region with appropriate ARIA (`aria-label`, live region sparingly — avoid announcing every slide)
3. Ensure Pause is keyboard-accessible
4. Test mobile: touch pause/resume, scroll performance, lightbox
5. Gate 3: UX + perf + reduced-motion + uniqueness audit

## Validation

- [x] Autoscroll model matches brief (M1)
- [x] Panoramic-friendly layout (L1)
- [x] A11y path (A3) + lightbox (I1)
- [x] Curated set for performance (G1)
- [x] Minimal chrome (P1)
- [x] Mode deferred without blocking

## 🎨 EXITING CREATIVE PHASE C4
