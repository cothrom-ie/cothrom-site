# Tech Context

## Stack

| Layer | Choice | Status |
|-------|--------|--------|
| SSG | Hugo Extended **0.158.0** (`./bin/hugo`) | Gate 0 OK — arch-aware `make hugo-install` (amd64/arm64) |
| Theme | No Fate **v0.1.0** (`f2703f64`), style `clean` | `themes/no-fate` submodule |
| Content | Markdown under `content/` | IA stubs present |
| Images | Source `images/`; register `docs/image-register.md` | Static smoke logo under `static/images/logos/` (dir gitignored) |
| Serving | NGINX `compose.yml` :8039 → `./site` | `publishDir = "site"` |
| Contact | Form POST → **n8n webhook** | Phase 4; env wiring still TBD |
| Visual | Kraft `#BE9E6C` / ink `#1D120D`; system colour | `assets/css/extended/kraft.css` |
| Spellcheck | cspell | Present |
| Make | `build` / `serve` / `clean` / `hugo-install` | `HUGO_CACHEDIR=./temp/hugo_cache` |

## Technology validation

| Check | Result |
|-------|--------|
| Hugo CLI Extended ≥ 0.158 | YES — `./bin/hugo` v0.158.0+extended |
| Theme hello-world | YES — kraft plate + CSS on Home |
| Image pipeline smoke | YES — `/images/logos/cothrom-mark-kraft-32.png` in `site/` |
| Deploy path (`./site`) | YES — `publishDir = "site"`; `make build` |

## Source assets (not site content)

- `assets-general/personal/...` — reference only
- `superCV.yaml` includes **email** and **phone** — never publish on site

## Local / platform

- OS: Linux (amd64 or aarch64) · Shell: zsh · Workspace: `/home/cappy/code/cothrom-site`
- First-run: `git submodule update --init themes/no-fate` then `make hugo-install`

## Testing expectations

- `hugo` / `make build` after each meaningful change
- Visual check desktop + mobile per page
- Content review against bio/CV/style guide
- Image uniqueness via register
- Contact: validation, spam controls, no PII logging
