# 🎨 CREATIVE PHASE C2: Home Composition

**Status:** COMPLETE  
**Type:** UI/UX  
**Depends on:** C1 (kraft-led, No Fate `clean`, system colour)  
**Date opened:** 2026-10-25  
**Date closed:** 2026-10-25

## Problem statement

Define the Home page first viewport and below-fold structure so Phase 1 can implement a brand-first landing: greeting, links, 150–250 word biography, and a future Writing stub — without cluttering the hero.

## Requirements

- Brand-first first viewport; photography dominant; kraft plate material
- Biography 150–250 words from long-form bio; careful review at build
- Links to services, Gallery, Contact; Writing stub for future papers
- No phone/email; no hero cards/chips/stats

## Decisions (locked)

| Topic | Choice |
|-------|--------|
| Hero layout | **H2** — full-bleed (edge-to-edge) photo + grounded kraft brand plate |
| Photo aspect | Prefer **panoramic / wide** event photography; compose plate so wide frames are not cropped into a tall “poster” by default |
| CTA set | **C2** — Primary: **Services**; Secondary: **Contact** + **Gallery** |
| Below-fold | **B2** — Service links → Bio → Writing stub |
| Naming | **N1** — **Cothrom** only in hero; Dominic named in bio |
| Bio voice | **Third person** |
| Writing stub | Label **“Writing”**; below fold only; no candidates yet (one soon); placeholder OK |
| Hero image | **No candidate yet** — assign in image register (Phase 0/1); prefer unused panoramic production shot |

## Options considered (summary)

| ID | Options | Selected |
|----|---------|----------|
| H | H1 overlay / H2 kraft plate / H3 split | **H2** |
| C | C1 Contact-primary / C2 Services-primary / C3 Gallery-primary | **C2** |
| B | B1 bio-first / B2 services-first / B3 bio+nav only | **B2** |
| N | N1 brand-only / N2 dual / N3 person-first | **N1** |

### Rationale

- **H2 + panoramic:** Event photos are often wide; a grounded kraft plate keeps contrast/a11y while letting the full-bleed plane read as a wide stage/landscape, not a forced square crop.
- **C2:** Services are the product offering; Contact/Gallery support without making the hero a contact form pitch.
- **B2:** Visitors see what Cothrom offers immediately under the fold, then the bio for trust.
- **N1:** Passes brand test (Cothrom is the hero signal); person identity lives in the reviewed bio.
- **3rd person:** Matches source biography; avoids inventing a first-person voice.
- **Writing:** Future-proof label; quiet placement until content exists.

## First-viewport composition (spec)

```text
┌─────────────────────────────────────────────────────────────┐
│  FULL-BLEED / EDGE-TO-EDGE PHOTO (prefer panoramic wide)    │
│                                                             │
│                                                             │
│  ┌─────────────────────────────────────┐                    │
│  │ KRAFT PLATE (grounded, not floating)│                    │
│  │  [Cothrom mark / wordmark]          │                    │
│  │  One headline                       │                    │
│  │  One short support sentence         │                    │
│  │  [Services]  [Contact]  [Gallery]   │  ← Services = primary style
│  └─────────────────────────────────────┘                    │
└─────────────────────────────────────────────────────────────┘
Nav may repeat links; hero brand must still read if nav were removed.
```

### Copy slots (draft at build; review gate)

- **Headline:** Short, measured; not louder than the brand mark (e.g. production / creative-tech framing — exact words at build from style guide)
- **Support:** One sentence; **do not** put “Dominic Capparelli” here (N1)
- **CTAs:** Services (primary) → scrolls/links to below-fold service list or services index; Contact; Gallery

### Panoramic image guidelines

- Prefer wide aspect (roughly ≥ 2:1 or strong landscape); allow horizontal crop/edit
- Avoid forcing panoramic sources into tall portrait heroes
- On narrow viewports: keep plate readable; photo may crop center-weighted or left/right per shot — decide per locked image at build
- Image must remain unique vs service/gallery locks in the register

## Below-fold structure (spec)

1. **Services** — text links (or simple linked headings) to the four service pages; **not** a card grid in the sense of bordered marketing cards; one job: route to services
2. **Biography** — 150–250 words, third person, from long-form bio + style guide; content review gate
3. **Writing** — single stub link/section (“Writing”); empty or “Coming soon” until first paper; future Hugo white-paper hosting
4. Footer / site chrome

## Implementation guidelines (Phase 1)

1. Map H2 onto No Fate home modules + site overrides (opening / visual interruption as needed); do not edit theme core
2. Kraft plate: use `--brand-kraft` / `--brand-ink`; ensure contrast in light and dark (system mode)
3. Primary button style on Services; quieter text/secondary on Contact & Gallery
4. Service link block: accessible list; no stat strips
5. Bio and Writing are separate sections with one purpose each
6. Hero image: placeholder acceptable until register assigns a panoramic candidate
7. Content review protocol applies to headline, support, and bio before Home Gate 1

## Validation

- [x] Brand-first first viewport (N1 + H2)
- [x] One headline, one support, one CTA group, one dominant image
- [x] No hero cards/chips
- [x] Bio length/voice/placement defined
- [x] Writing stub defined without inventing papers
- [x] Panoramic photo preference recorded
- [x] C2-only scope (C3–C5 not started here)

## 🎨 EXITING CREATIVE PHASE C2
