# Project Brief: Cothrom Productions Site

## Purpose

Build a professional CV/portfolio website for Dominic Capparelli / Cothrom Productions (`https://cothrom.ie/`). The site presents four service lines, a visual gallery, and a contact path — with page copy derived carefully from verified source materials.

## Site Map

```
home
  |- Contact
  |- Gallery
  |- Production Management
  |- Technical Direction
  |- Creative Technology
  |- System Design
```

## Primary Content Sources (authoritative)

| Source              | Path                                                             | Use                                                    |
| ------------------- | ---------------------------------------------------------------- | ------------------------------------------------------ |
| Long-form biography | `assets-general/personal/biography/cappy_longForm_biography.md`  | Narrative, home bio, service evidence                  |
| Writing style guide | `assets-general/personal/biography/cappy_writing_style_guide.md` | Tone, voice, editorial constraints                     |
| Super CV (YAML)     | `assets-general/personal/Cappy_CV/superCV.yaml`                  | Roles, dates, highlights, facts                        |
| Page briefs         | `docs/pages.md` (mirrored in README)                             | Audience, purpose, scope, editorial direction per page |

**Rule:** Do not invent experience, project responsibilities, or achievements. Distinguish established experience from interests / future development. Review each page’s content carefully before considering it done.

## Images

- Location: `images/` (~107 files)
- Folders: `gallery/` (69), `prodMan/` (9), `techDir/` (7), `creativeTech/` (9), `sysDesign/` (4), `logos/` (9)
- Prefer unique images per use; avoid duplicate use across pages when possible
- Editing / resizing is allowed (sizes not a hard constraint)
- Note: some basenames appear in both `gallery/` and service folders — inventory and assign deliberately

## Architecture (planned)

- Hugo static site + NGINX (`compose.yml` → port 8039, publish dir `./site`)
- Theme intent: **No Fate** — blocked until ADR-01 (theme needs Hugo ≥ 0.158; host has 0.123.7)
- Contact: form + LinkedIn only (no phone/email on site)
- Gallery: autoscrolling photogallery
- White papers: future Hugo hosting (link placeholder on Home)
- Full plan: `memory-bank/tasks.md`

## Delivery Principles

- Go slowly; gate each phase with testing and content review
- One page (or coherent slice) at a time after foundation is solid
- Content review is a first-class gate, not an afterthought
- Prefer evidence from bio/CV over marketing language
