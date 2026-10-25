# Phase Reflection: Phase 0 — Foundation & Inventory

**Parent task:** Complete Cothrom CV/Portfolio Website (Level 4)  
**Phase ID:** phase-0 / S0 Foundation  
**Date:** 2026-10-25  
**Gate:** Gate 0 — **PASSED**  
**Scope note:** This reflection covers Phase 0 only. Full-site `/reflect` + `/archive` wait until Phases 1–5 complete.

---

## Summary

Phase 0 closed the technology and inventory gap that blocked BUILD: Hugo Extended ≥ 0.158 on the project build path, No Fate pinned at **v0.1.0**, kraft hello-world via site extended CSS (C1), IA content stubs + menus, `publishDir = "site"` aligned with compose, Makefile targets, and `docs/image-register.md` with unique-first duplicate rules. `make build` produces 22 pages under `site/` with all planned routes present.

Creative C1–C5 were already locked before BUILD; Phase 0 implemented C1’s tech validation without reopening visual ADRs.

---

## System Overview (Phase 0 slice)

### What was implemented

| Component | Outcome |
|-----------|---------|
| Hugo | `./bin/hugo` Extended **0.158.0**; `make hugo-install` |
| Theme | Submodule `themes/no-fate` @ **v0.1.0** (`f2703f64`) |
| Config | `hugo.toml`: theme, menus, `params.noFate` (`clean`), `publishDir=site` |
| Kraft | `assets/css/extended/kraft.css` + Home plate via `hooks/body-end.html` |
| Content | Stubs for Home, Contact, Gallery, four services |
| Images | Register 107 rows; 17 dup basenames → service owns / gallery omit |
| Ops | `make build` / `serve` / `clean`; `HUGO_CACHEDIR` under `temp/` |

### Architecture decisions exercised

- **ADR-01 Option A:** Upgrade Hugo + pin No Fate (not fork / not stay on 0.123)
- **Override, don’t fork:** kraft and hooks in site tree only
- **Deploy contract:** Hugo → `./site` ↔ NGINX compose volume

### Boundaries

Phase 0 did **not** ship real Home bio, service copy, gallery behaviour, or contact form. Those remain Phases 1–4.

---

## What Went Well

1. **Plan ↔ Gate alignment** — Phase 0 checklist mapped 1:1 to Gate 0 evidence (`make build`, routes, register, kraft).
2. **C1 carried cleanly** — `clean` + kraft tokens (`#BE9E6C` / `#1D120D`) via `assets/css/extended/` without theme edits.
3. **Pinned theme, not `main`** — Tag checkout avoided floating HEAD; matches No Fate install guidance.
4. **Project-local Hugo** — `./bin/hugo` + Makefile install avoids depending on host 0.123.7 and keeps Extended requirement explicit.
5. **Image register automation** — Scripted inventory + dup rule produced a usable living register for Phases 1–3.
6. **No Fate content contract** — Stub front matter (`content.format`, `visual.mode`, gallery archive fields) kept `validateContentModel` quiet enough for a green build.

---

## Challenges

1. **Host Hugo too old (0.123.7)**  
   - **Impact:** Blocked No Fate entirely.  
   - **Resolution:** Project-local Extended 0.158.0 under `bin/` (gitignored via `[Bb]in/`).  
   - **Prevent:** Document `make hugo-install` as first-run step in README (Phase 5 hardening).

2. **Submodule add friction**  
   - **Impact:** `-b v0.1.0` failed (tag ≠ branch); `.git/config` “Device or resource busy” left submodule status as uninitialized (`-` prefix) despite correct gitlink SHA.  
   - **Resolution:** Clone + `checkout v0.1.0`; `.gitmodules` + gitlink `160000 f2703f64` recorded.  
   - **Unresolved:** Fresh checkouts may need `git submodule update --init` once config is writable.  
   - **Prevent:** Prefer `git submodule add <url> && git -C themes/no-fate checkout <tag>` in docs.

3. **Hugo cache outside workspace**  
   - **Impact:** Sandbox/permission deny on `~/.cache/hugo_cache`.  
   - **Resolution:** `HUGO_CACHEDIR=$(CURDIR)/temp/hugo_cache` in Makefile.  
   - **Reuse:** Keep for CI/agents.

4. **`static/` and `images/` gitignored**  
   - **Impact:** Logo smoke file and source inventory won’t ship via git as currently ignored.  
   - **Resolution:** Documented; pipeline verified locally.  
   - **Path forward (Phase 1/5):** Decide what under `static/` must be committed (favicons/logos) vs stay ignored.

5. **Home kraft plate via body-end hook**  
   - **Impact:** Temporary marker, not C2 composition.  
   - **Resolution:** Acceptable for Gate 0; remove/replace in Phase 1.  
   - **Lesson:** Prefer hooks over enabling unsafe Markdown HTML for one-off markers.

---

## Lessons Learned

- **Pin early:** Theme tag + local Hugo version should be Gate 0 prerequisites, not deferred to “when we need features.”
- **Theme contracts need stub FM:** No Fate’s validator expects `content.format` / `visual.mode` (and archive metadata for archive mode)—stubs are not blank Markdown.
- **Inventory before beauty:** Image register + dup policy before Home/service heroes prevents later uniqueness fights.
- **Makefile owns the build path:** Single `HUGO` / cache / `publishDir` contract reduces “works on my host Hugo” drift.
- **Phase reflect ≠ task reflect:** Level 4 phased delivery benefits from per-gate reflection without claiming the parent task complete.

---

## Process Improvements

| Improvement | When to apply |
|-------------|----------------|
| First-run doc: `make hugo-install` → `make build` | Phase 5 README / Phase 1 kickoff |
| Submodule init recipe in techContext | Now / archive of Phase 0 |
| Gate evidence table in `tasks.md` at gate close | Repeat for Gates 1–5 |
| Decide commit policy for `static/images/logos/` before Home chrome | Phase 1 start |
| Remove kraft hello-world plate when Home H2 lands | Phase 1 |

---

## Technical Improvements

| Improvement | Detail |
|-------------|--------|
| Prefer relative menu URLs if baseURL staging differs | Menus currently absolute to `https://cothrom.ie/` — fine for prod; watch local `hugo server` absolute links |
| Keep home modules minimal until content exists | `modules = ["opening"]` avoided missing featured refs |
| `showSearch = false` until search page exists | Avoided broken Search nav |
| Extended CSS token remap | Override `--nf-signal` / paper/ink rather than forking `10-tokens.css` |
| Image register columns | Keep `status` (`candidate` / `omit` / later `locked` / `edited`) as the Phase 2–3 workflow API |

---

## Project Performance (Phase 0)

| Metric | Result |
|--------|--------|
| Plan items 1–7 | All done |
| Gate 0 | Passed same session as BUILD |
| Deviations from plan | Local Hugo binary instead of system upgrade; submodule init config write incomplete (content pin OK) |
| Quality | Build green; routes present; kraft visible in CSS + HTML; register complete |

---

## Strategic / Immediate Actions

1. **Phase 1 Home** — C2 H2 panoramic + kraft plate; 150–250w 3rd-person bio; assign unique hero in register; remove hello-world body-end plate.  
2. **Commit policy** — Un-ignore or selectively track logo/favicon assets needed for chrome.  
3. **Submodule hygiene** — On a writable `.git/config`, run `git submodule update --init` and confirm status without `-` prefix.  
4. **Do not** run full-site `/archive` yet — optional Phase 0 note archive only if desired; parent task continues.

---

## Knowledge Transfer

- **Pin:** No Fate `v0.1.0` / `f2703f64` — see `.gitmodules` + `themes/no-fate`
- **Build:** `make build` → `./site` (compose-compatible)
- **Brand CSS:** `assets/css/extended/kraft.css`
- **Images:** `docs/image-register.md` is the assignment source of truth
- **Creative upstream:** C1 visual system; C2–C5 unused until later phases

---

## Reflection Summary

### Key takeaways

1. Gate 0 is a **toolchain + inventory** gate; treating it as such unblocked the rest of the Level 4 plan.
2. Theme override path (`extended/` + hooks) is the right kraft strategy.
3. Operational friction (cache path, submodule config, gitignore of `static/`) is documented and actionable—not Gate 0 failures.

### Success patterns to replicate

- Evidence table at gate close  
- Project-local pinned tooling  
- Register before visual assignment  

### Issues to avoid

- Following theme `main`  
- Editing files under `themes/no-fate`  
- Publishing without unique-first register checks  

### Overall assessment

**Phase 0 succeeded.** Foundation matches plan and C1. Ready for Phase 1 without revisiting ADR-01.

### Next steps

→ **`/build` Phase 1** (Home). Full-task reflection/archive after Gate 5.

---

## Verification Checklist

- [x] Implementation (Phase 0) reviewed against plan  
- [x] What Went Well documented  
- [x] Challenges documented  
- [x] Lessons Learned documented  
- [x] Process Improvements identified  
- [x] Technical Improvements identified  
- [x] Next Steps documented  
- [x] `reflection-phase-0.md` created  
- [x] Memory Bank updated for Phase 0 reflection (parent task reflection still open)  
