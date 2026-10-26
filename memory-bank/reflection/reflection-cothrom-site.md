# Task Reflection: Complete Cothrom CV/Portfolio Website

**Task ID:** cothrom-site  
**Complexity:** Level 4 (Complex System)  
**Date:** 2026-10-26  
**Workflow:** VAN → PLAN → CREATIVE (C1–C5) → BUILD (Phases 0–5) → REFLECT  
**Gates:** 0–5 all **PASSED**  
**Related:** Phase-0-only reflection at `memory-bank/reflection/reflection-phase-0.md` (kept; this document covers the full task)

---

## Summary

Shipped a professional Hugo Extended + No Fate (`clean` + kraft) static site for Dominic Capparelli / Cothrom Productions (`cothrom.ie`): Home, four service pages, Gallery marquee, Contact (n8n webhook + Turnstile + LinkedIn-only), favicons/SEO/404/a11y hardening, and NGINX/compose deploy path with documented env contract.

Delivery followed the locked plan: evidence-only copy (biography + `superCV.yaml` + style guide), unique-first image register, theme overrides without forking, and slow per-phase content/visual/build gates. Final regression: 15 pages, zero Hugo WARN/ERROR, axe-core 0 violations (light + dark), all 8 routes 200 at desktop and mobile with zero broken internal links.

---

## System Overview

### System Description

A static CV/portfolio that presents four distinct live-events services (Production Management, Technical Direction, Creative Technology, System Design), a visual gallery, and a LinkedIn-primary contact path. No phone or email is published. The only dynamic edge is an HTML form POST to an external n8n webhook (optional at build time).

### System Context

Visitor → Cloudflare Tunnel (optional) → NGINX `:8039` → `./site` (Hugo `publishDir`). Editorial sources stay offline in `assets-general/` (gitignored). Working photo library stays in root `images/` (gitignored, anchored); published selects live as page-bundle resources or `static/` chrome.

### Key Components

| Component | Purpose |
|-----------|---------|
| Hugo Extended 0.158 + Makefile | Build/serve; env → `HUGO_PARAMS_*` for contact |
| No Fate v0.1.0 (submodule) | Base theme; site overrides only |
| Content IA | Home + 4 leaf-bundle services + Gallery/Contact branch bundles + thanks leaf |
| Image register | Unique-first assignment; 28 locked published roles |
| Contact edge | Form → n8n; Turnstile public key in HTML; secret in n8n only |
| NGINX + compose | Static serve, security headers, CSP, 404, asset cache |

### System Architecture

Static-first SSG; kraft visual system via extended CSS; structural customization via same-path `layouts/` and section-name templates. Patterns documented in `systemPatterns.md` (leaf vs branch bundles, env-var underscore nesting, section vs mode overrides).

### System Boundaries

**In scope:** Public marketing/portfolio surface, build/deploy glue, form HTML + spam controls, image pipeline into Hugo.  
**Out of scope / deferred:** Live n8n workflow authoring beyond the env contract; white papers (Home stub only); theme upstream PR for the opengraph path bug; Turnstile secret handling inside Hugo.

### Implementation Summary

Phases 0–5 over ~2 calendar days of gated build after Creative C1–C5. Site-level overrides for Home hero, editorial service heroes, Gallery marquee, Contact/thanks, footer LinkedIn, opengraph fix, 404, and head-end manifest link. Playwright + axe-core used as the visual/a11y gate tooling.

---

## Project Performance Analysis

### Timeline Performance

- **Planned:** Multi-phase Level 4 delivery with creative first, then serial build gates (no fixed calendar in PLAN).
- **Actual:** Creative locked before BUILD; Phases 0–3 on 2026-10-25; Phases 4–5 + full reflect on 2026-10-26.
- **Variance:** Compressed calendar; quality gates were not skipped. Phase reflection for Phase 0 was done early; full-task reflect deferred correctly until Gate 5.
- **Explanation:** Clear ADRs and content source map reduced rework; serial service pages and hardening still took real time for diagnosis (theme OG bug, gitignore, Hugo env overlay).

### Resource Utilization

Single-agent / single-operator delivery with Memory Bank as the coordination surface. No separate design/QA roles; Playwright and axe-core substituted for manual QA at gates.

### Quality Metrics

| Target | Result |
|--------|--------|
| Build green, no WARN/ERROR | Met (15 pages final) |
| Content review + style guide | Met; Phase 5 re-pass clean |
| No published email/phone | Met (full-site grep) |
| Image uniqueness | Met (register audit) |
| a11y WCAG 2A/2AA spot-check | Met (0 axe violations light+dark) |
| Deploy path verified | Met (real nginx container + README) |

### Risk Management Effectiveness

| Risk (from PLAN) | Outcome |
|------------------|---------|
| R1 Theme/Hugo mismatch | Mitigated at Gate 0 (local Extended + pin) |
| R2 Content drift | Mitigated by review protocol + Phase 5 style re-pass |
| R3 System Design image scarcity | Mitigated (service-owned dup from register) |
| R4 Form PII leak | Mitigated (no CV PII published; secrets out of repo) |
| R5 Gallery a11y/perf | Mitigated (reduced-motion grid, pause, native dialog) |

**Unforeseen:** Upstream opengraph partial path bug; Hugo `HUGO_PARAMS_*` underscore nesting; compounding `.gitignore` depth matching; theme 404 CSS only fit for `wild` style.

---

## What Went Well

1. **Creative locks held through BUILD** — C1–C5 decisions (kraft/`clean`, H2 Home, S1 services, M1 gallery, n8n contact) were implemented without reopening ADRs; deviations were content-model fixes, not design churn.
2. **Evidence-over-marketing discipline** — Copy stayed third-person where locked, facts traced to biography/`superCV.yaml`, LinkedIn-only contact, British English / style guide held under Phase 5 re-verification.
3. **Theme override, don’t fork** — Every structural fix (Home, services, gallery, contact, footer, OG, 404, manifest) stayed in site `layouts/` / `assets/css/extended/`; temporary theme diagnostic edit was reverted and verified clean.
4. **Image register as a real control** — Unique-first rule prevented gallery/service collisions; Phase 5 reverse audit closed the loop (31 published files → 28 locked rows, 0 orphans).
5. **Gate evidence culture** — Each phase left a results table in `tasks.md`; Playwright screenshots and axe-core runs made “visual OK / a11y OK” falsifiable.
6. **Hardening found real bugs** — Phase 5 was not cosmetic: gitignore deploy breaks, upstream OG bug, clean-style 404, empty taxonomies in sitemap, nginx headers/MIME — all fixed with verification against production-shaped nginx, not only `hugo server`.

---

## Challenges

1. **No Fate content Kind vs mode dispatch (Phase 2)**  
   - **Impact:** Service stubs as branch bundles looked configured but rendered as plain lists with no hero; build stayed green.  
   - **Resolution:** Converted services to leaf bundles; shared editorial opening/body overrides.  
   - **Prevent:** Document leaf vs branch rule early (now in `systemPatterns.md`).

2. **Hugo `HUGO_PARAMS_*` underscore nesting (Phase 4)**  
   - **Impact:** Webhook/Turnstile env wiring silently no-op’d.  
   - **Resolution:** Unbroken param keys (`webhookurl`, `turnstilesitekey`); Makefile bridge; documented gotcha.  
   - **Prevent:** Always verify with `hugo config` when adding env-injected params.

3. **Compounding `.gitignore` patterns (Phases 0/3/5)**  
   - **Impact:** `static/`, then unanchored `images/`, hid committed chrome; earlier `memory-bank/` class of bug.  
   - **Resolution:** Remove blanket `static/`; anchor `/images/`; verify with `git check-ignore -v`.  
   - **Prevent:** Treat “is this path tracked?” as a Gate 0 / Gate 5 checklist item.

4. **Upstream opengraph partial path bug (Phase 5)**  
   - **Impact:** `og:image` never used page heroes; Twitter cards worked (correct path).  
   - **Resolution:** Site override of `opengraph.html` with one-line path fix; Home `seo.image` for bespoke hero.  
   - **Prevent:** Spot-check OG and Twitter independently; don’t assume sibling partials share correctness.

5. **Agent sandbox network isolation**  
   - **Impact:** Hugo server / Docker started in one shell call unreachable from the next; false connection failures.  
   - **Resolution:** Chain start + verify in one invocation.  
   - **Prevent:** Encode this as a standing ops note for agent-driven gates.

6. **Theme style variants incomplete for `clean` (404)**  
   - **Impact:** Broken giant 404 under locked C1 style.  
   - **Resolution:** Branded site 404 override matching kraft plate language.  
   - **Prevent:** Smoke-test error pages under the locked style, not only happy paths.

---

## Lessons Learned

1. **Silent Hugo failures are the default failure mode** — Wrong partial paths, wrong Kind, wrong env nesting, and over-broad gitignore all produce green builds with wrong runtime behaviour. Prefer explicit verification of the *user-visible* contract (OG tags, tracked static files, form `action`, 404 body).
2. **Creative docs pay for themselves when BUILD is serial** — Locked skeletons (S1, H1, M1, C5) prevented four divergent service templates and Contact redesign mid-build.
3. **Phase reflect ≠ task reflect** — Phase 0 reflection captured foundation lessons early without blocking; full-task reflect after Gate 5 is where cross-phase patterns (gitignore class bugs, override patterns) become strategic.
4. **Chrome vs content imagery must be separate rules** — Favicon/OG derivatives from one kraft source are allowed; content photography uniqueness is not negotiable. The register’s chrome exemption must stay explicit.
5. **Hardening should include “real serve path”** — `hugo server` gates miss nginx MIME, headers, error_page status, and volume freshness; Phase 5’s Docker nginx pass caught that class.

---

## Process Improvements

1. **Add a “tracked static chrome” checklist at Gate 0 and Gate 5** — `git check-ignore -v` on favicons, manifest, logos; never reintroduce blanket `static/` ignores.
2. **Split social-meta verification** — Assert both `og:image` and `twitter:image` per page type (hero pages vs fallback pages) at SEO gate.
3. **Keep agent verify commands single-shell** — Document in Makefile comments or a small `scripts/` note: start server + test in one process tree.
4. **Content Kind decision at stub time** — When scaffolding, choose leaf vs branch based on whether mode/hero dispatch is required; don’t discover at Gate 2.
5. **Dictionary hygiene as a Phase N habit** — Extend cspell with technical terms when they appear in layouts/makefile, not only after a big regression dump.
6. **Consider upstream contribution** — File/PR the No Fate opengraph path fix after archive so future pins inherit it.

---

## Technical Improvements

1. **Codify override patterns** (already in `systemPatterns.md`): Home full-bleed override; editorial mode partials; section-name templates; mixed Kind contact; env-var unbroken keys.
2. **CSP still allows `'unsafe-inline'`** — Acceptable for Phase 5 given theme FOUC script + site inline Gallery/Contact scripts; future improvement: nonces/hashes if theme supports them.
3. **n8n workflow remains external** — Site is ready; production still needs webhook + Turnstile secret configured outside the repo.
4. **Theme toggle label “Theme”** — Noted from Gate 1 as polish; still deferred (not a Gate 5 blocker). Optional follow-up.
5. **Optional automation:** small script to assert register basenames ⊆ published files and no locked basename collision.

---

## Achievements and Successes (evidence)

1. **Full IA live and gated** — 8 content routes + custom 404; Gates 0–5 tables in `tasks.md`.
2. **Zero a11y violations at ship** — axe-core WCAG 2A/2AA + best-practice, light and dark.
3. **PII policy held** — Grep of built output for CV email/phone: no matches.
4. **Deploy contract documented and exercised** — README Build/Env/Deploy; nginx headers + webmanifest MIME verified in container.
5. **Creative fidelity** — Brand-first Home, kraft plates, gallery pause/reduced-motion, LinkedIn footer sitewide.

---

## Business / Product Insights

1. **LinkedIn-only contact is a coherent product choice** — Reduces PII surface and matches the locked editorial policy; form is optional outreach, not the primary channel.
2. **Service differentiation without comparison tables works** — R1 “Often paired with” links + distinct audiences keep the four offers clear without marketing matrix clutter.
3. **Gallery as archive, not sales deck** — Minimal chrome + motion control communicates “visual record” without competing with service CTAs.
4. **White papers remain a deliberate stub** — Honest empty state beats invented content; aligns with evidence-over-marketing.

---

## Strategic Actions

### Immediate (before / with `/archive`)

| Action | Success criteria | Priority |
|--------|------------------|----------|
| Run `/archive` | Archive doc merges checklists; `tasks.md` cleared for next task | High |
| Ensure `.env` never committed | Still gitignored; only `.env.example` tracked | High |

### Short-term (1–3 months)

| Action | Success criteria | Priority |
|--------|------------------|----------|
| Wire production n8n + Turnstile | Form submits end-to-end on `cothrom.ie` | High |
| Upstream No Fate OG path fix | Issue/PR filed or noted for next theme bump | Medium |
| Optional theme-toggle label polish | No literal “Theme” chrome if replaced with icon/aria | Low |

### Medium / long-term

| Action | Success criteria | Priority |
|--------|------------------|----------|
| White papers section when content exists | Home Writing links to real pages | Medium |
| CSP nonce/hash migration | Drop `'unsafe-inline'` where feasible | Low |
| Register audit script in `make check` | CI-friendly uniqueness assert | Low |

---

## Knowledge Transfer

| Learning | Where documented |
|----------|------------------|
| Leaf vs branch + No Fate modes | `systemPatterns.md` |
| `HUGO_PARAMS_*` underscore nesting | `hugo.toml` comments + `systemPatterns.md` |
| Gitignore anchoring / no blanket `static/` | `.gitignore` comments + this reflection |
| Opengraph site override | `layouts/_partials/templates/opengraph.html` |
| Contact env contract | `.env.example`, README, makefile |
| Image uniqueness + chrome exemption | `docs/image-register.md` |
| Phase 0 foundation lessons | `reflection-phase-0.md` |

---

## Reflection Summary

### Key Takeaways

1. Level 4 slow gates + locked creative ADRs produced a coherent site with almost no design thrash.
2. The most expensive bugs were silent (Kind mismatch, env nesting, gitignore, wrong partial path) — invest in contract tests, not only build exit codes.
3. Hardening against the real nginx path was essential; Hugo-only gates would have shipped broken chrome/SEO/404 behaviour.

### Success Patterns to Replicate

1. Creative → serial phased build with per-gate evidence tables.
2. Theme override discipline with temporary diagnostic edits fully reverted.
3. Image register created before heroes; reverse-audited at the end.
4. Playwright + axe as standard visual/a11y gates.

### Issues to Avoid

1. Assuming `make build` green means the page rendered as designed.
2. Unanchored gitignore directory patterns.
3. Env var names that encode Hugo nesting accidentally.
4. Smoke-testing only the happy path under one theme style variant.

### Overall Assessment

**Success.** The planned Level 4 system was delivered: professional static portfolio with gated content, unique imagery, accessible gallery/contact, hardened deploy surface, and Memory Bank traceability from VAN through Gate 5. Remaining work is operational (live webhook) and optional polish/upstream, not incomplete core scope.

### Next Steps

1. **`/archive`** — Create `memory-bank/archive/archive-cothrom-site.md`, merge task checklists, clear ephemeral `tasks.md`, update progress/activeContext for idle/next-task state.
2. Production: set `.env` / tunnel token; confirm n8n workflow + Turnstile secret outside the repo.
3. Optional: contribute opengraph fix upstream; theme-toggle chrome polish; white papers when ready.

---

## Reflection Verification

- Implementation thoroughly reviewed? **YES**
- What Went Well completed? **YES**
- Challenges completed? **YES**
- Lessons Learned completed? **YES**
- Process Improvements identified? **YES**
- Technical Improvements identified? **YES**
- Next Steps documented? **YES**
- Level 4 system/performance/strategic sections present? **YES**
- `reflection-cothrom-site.md` created? **YES**
- Memory Bank status updates (tasks/progress/activeContext)? *(follows this file)*

→ Ready for **ARCHIVE** mode.
