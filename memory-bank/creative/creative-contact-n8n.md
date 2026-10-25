# 🎨 CREATIVE PHASE C5: Contact Form & n8n Webhook

**Status:** COMPLETE  
**Type:** UI/UX + security  
**Depends on:** C1 ADR-03 (n8n webhook); no phone/email on site  
**Date opened:** 2026-10-25  
**Date closed:** 2026-10-25

## Problem statement

Design Contact so visitors submit via a form that POSTs to an n8n webhook (URL from Docker/env), see LinkedIn on the page and in the global footer, and never see phone/email — with honeypot + Turnstile spam controls and a static thank-you page.

## Decisions (locked)

| Topic | Choice |
|-------|--------|
| Transport | **T1** — Classic HTML `POST` to webhook URL |
| Webhook config | **W1** + Docker — POST URL **must be settable via Docker env** (not committed) |
| Fields | **F1** — Name, email, message (+ honeypot) |
| Success UX | **U1** — Redirect / land on static `/contact/thanks/` |
| Spam | **S2** — Honeypot + Cloudflare Turnstile (or equivalent) |
| LinkedIn | **L1** on Contact (beside/above form) **and in site footer everywhere** |
| Hero | **H1** — Kraft plate + short invite; mark OK; photo optional |
| n8n downstream actions | **Defer to ops** (email/Slack/store — not blocking C5) |

## Options considered (summary)

| ID | Options | Selected |
|----|---------|----------|
| T | T1 form POST / T2 fetch / T3 NGINX proxy | **T1** |
| F | F1 name+email+message / F2 +service / F3 minimal | **F1** |
| U | U1 thanks page / U2 inline / U3 n8n HTML | **U1** |
| S | S1 honeypot / S2 +Turnstile / S3 +rate limits | **S2** |
| L | L1 on page / L2 below / L3 hero | **L1 + global footer** |
| H | H1 kraft invite / H2 photo / H3 bare | **H1** |
| W | W1 env inject / W2 proxy / W3 commit test URL | **W1 + Docker env** |

### Rationale

- **T1 + U1:** Reliable without JS; clear thank-you; n8n can redirect to `/contact/thanks/` on success.
- **Docker env for webhook:** Matches compose-based deploy; keeps production URL out of git.
- **F1:** Enough to reply; no service dropdown complexity for v1.
- **S2:** Honeypot alone is weak; Turnstile cuts bots without a full CAPTCHA grind.
- **LinkedIn footer + L1:** Discoverable from every page; Contact still emphasises connect options.
- **H1:** Contact is a task page — kraft invite without competing panoramic hero.

## Page composition (spec)

```text
[Nav]

┌─ HERO (H1) ─────────────────────────────────────┐
│ Kraft plate: “Contact” + one short invite line  │
│ (optional mark; no phone/email)                 │
└─────────────────────────────────────────────────┘

Or connect on LinkedIn → [profile]
(name from CV social: dominic-capparelli — confirm URL at build)

Form (POST → n8n webhook URL from env):
  - Name (required)
  - Email (required)
  - Message (required)
  - Honeypot (hidden; must stay empty)
  - Turnstile widget
  - Submit

[Footer — all pages: LinkedIn link; no phone/email]
```

### Thanks page (`/contact/thanks/`)

- Short confirmation; measured tone
- Links: Home, services, Gallery, LinkedIn
- No form re-display required

### Error path

- If n8n fails: prefer redirect to `/contact/?error=1` or static `/contact/error/` with retry — choose at build; do not leak internal errors

## Docker / env contract (W1 + T1)

| Variable (suggested names) | Purpose |
|----------------------------|---------|
| `N8N_CONTACT_WEBHOOK_URL` | Full HTTPS webhook URL used as form `action` |
| `TURNSTILE_SITE_KEY` | Public Turnstile site key (safe in HTML) |
| `TURNSTILE_SECRET_KEY` | **Only in n8n** (verify token) — never in Hugo static output |

### Build / runtime pattern

1. **Do not** commit production webhook URL or Turnstile secret.
2. Hugo needs the webhook URL and Turnstile **site** key in generated HTML:
   - **Preferred:** build-arg / env at `hugo` build time → `config` / template (`os.Getenv` or generated `data/env.yaml` in CI)
   - **Or:** container entrypoint sed/replace placeholders in built HTML when container starts (works with prebuilt `site/` volume)
3. `compose.yml` should document/pass `N8N_CONTACT_WEBHOOK_URL` and `TURNSTILE_SITE_KEY` (and n8n stack holds secret + workflow).
4. Local `.env` gitignored; example in `.env.example` with empty placeholders.

### n8n workflow (minimum)

1. Webhook trigger (POST)
2. Reject if honeypot filled
3. Verify Turnstile token with secret
4. Validate name/email/message present and sane length
5. Side effects (email/etc.) — **ops deferred**
6. Respond with **redirect** to `https://cothrom.ie/contact/thanks/` (or relative URL n8n supports)

## Security notes

- Never display or form-default phone/email from CV
- No logging of full message bodies in Hugo (static); n8n: minimise PII retention
- Rate limiting: nice-to-have later (S3); not required for C5 lock
- Treat webhook URL as semi-sensitive even if “public” in HTML source

## LinkedIn (sitewide)

- Profile: LinkedIn network username `dominic-capparelli` from `superCV.yaml` (confirm final URL at build)
- Footer partial: LinkedIn text/icon link on **all** pages
- Contact page: L1 placement above/beside form

## Implementation guidelines (Phase 4)

1. Contact layout + thanks page; kraft H1
2. Form markup T1/F1/S2; wire env injection in Makefile/compose
3. Footer LinkedIn partial
4. Document n8n workflow steps for operator
5. Gate 4: submit happy path, honeypot reject, Turnstile fail, no PII on site, env override works in Docker

## Validation

- [x] T1 + Docker-env URL
- [x] F1 fields + S2 spam
- [x] U1 thanks page
- [x] L1 + global footer LinkedIn
- [x] H1 hero
- [x] W1 no committed secrets
- [x] PII policy held

## 🎨 EXITING CREATIVE PHASE C5

**All planned creative phases C1–C5 are complete.** Next: Phase 0 tech validation / `/build`.
