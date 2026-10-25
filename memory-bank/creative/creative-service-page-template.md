# 🎨 CREATIVE PHASE C3: Service Page Template

**Status:** COMPLETE  
**Type:** UI/UX  
**Depends on:** C1 (kraft, No Fate `clean`), C2 (H2 panoramic + kraft plate)  
**Date opened:** 2026-10-25  
**Date closed:** 2026-10-25

## Problem statement

Define one shared layout skeleton for the four service pages so each can differ in audience, copy, and images while staying visually coherent — without card clutter, invented experience, or blurring service distinctions.

## Decisions (locked)

| Topic | Choice |
|-------|--------|
| Skeleton | **S1** — Hero → Who it’s for → What it’s for → How it works → Evidence → Related → Contact CTA |
| Hero | **H1** — Panoramic full-bleed + kraft plate with **service title** (Cothrom mark in nav) |
| Evidence imagery | **E1** — Hero only; optional **one** inline image only if the register has a spare unique shot |
| Related services | **R1** — Quiet “Often paired with…” (≤2 text links); no comparison tables |
| Body voice | **V1** — Light second person for audience framing; **third person** for evidence about Dominic |
| No Fate mode | **`editorial`** (default for all four service pages) |

## Options considered (summary)

| ID | Options | Selected |
|----|---------|----------|
| S | S1 stack / S2 narrative / S3 FAQ | **S1** |
| H | H1 Home-like / H2 band / H3 title-first | **H1** |
| E | E1 hero / E2 multi-inline / E3 thumbs | **E1** |
| R | R1 paired links / R2 compare / R3 none | **R1** |
| V | V1 you+3rd / V2 impersonal / V3 first person | **V1** |
| Mode | editorial / poster / defer | **editorial** |

### Rationale

- **S1** mirrors `docs/pages.md` and supports per-section content review.
- **H1** keeps visual continuity with Home H2; panoramic-friendly; service name is the page signal.
- **E1** respects small pools (especially `sysDesign`) and unique-first image policy.
- **R1** states overlap without artificial walls or marketing comparison blocks.
- **V1** speaks to the intended audience without turning evidence into first-person invention.
- **editorial** fits long-form, measured service copy in No Fate.

## Page skeleton (spec)

```text
┌─ HERO (H1) ─────────────────────────────────────────┐
│ Full-bleed panoramic photo                          │
│ Kraft plate: Service title + one-line purpose       │
│ (optional quiet secondary: Contact)                 │
└─────────────────────────────────────────────────────┘

## Who it’s for
Audience from docs (V1: light “you” OK)

## What it’s for
Purpose / problems addressed (value, not duty list)

## How it works
Approach + scope as readable prose (not a dump of bullets)

## Evidence
1–3 examples traced to bio/CV; third person; optional 1 inline image (E1)

## Often paired with
≤2 related service links (R1) — e.g. PM↔TD, CT↔SD as appropriate

## Next step
Primary CTA → Contact
```

### Suggested related pairs (R1 content hint)

| Page | Often paired with (examples) |
|------|------------------------------|
| Production Management | Technical Direction; Creative Technology |
| Technical Direction | Production Management; System Design |
| Creative Technology | System Design; Production Management |
| System Design | Technical Direction; Creative Technology |

Pick ≤2 per page at draft time; do not claim exclusivity.

## Hero spec (H1)

- Same material language as Home H2 (kraft plate, panoramic preference)
- Plate carries **service title** + one short purpose line — not the Cothrom wordmark as hero brand (nav holds site brand)
- No cards, chips, stats, or overlapping service menus in the hero
- Unique image from that service’s folder pool (register lock)

## Voice rules (V1)

- Audience sections: clear, accessible; occasional “you” when addressing the client type
- Evidence: third person, facts from biography / `superCV.yaml` only
- No hype; no invented projects; distinguish interest vs established experience

## Implementation guidelines (Phase 2)

1. One Hugo layout/partial (or archetype) for all four services; page content via Markdown sections or front matter + body
2. Front matter: `title`, hero image, `params.noFate` mode `editorial`, purpose one-liner
3. Do not fork four different layouts unless a later creative overrides
4. Primary CTA button → Contact; Related = text links only
5. Content review protocol per page before Gate 2.x
6. Image register: lock hero (and optional single inline) before mark page done
7. Build order unchanged: PM → TD → CT → SD

## Validation

- [x] Shared skeleton defined
- [x] Hero aligned with kraft/panoramic system
- [x] Evidence imagery constrained (E1)
- [x] Related services without false exclusivity
- [x] Voice compatible with style guide + Home bio
- [x] No Fate mode chosen

## 🎨 EXITING CREATIVE PHASE C3
