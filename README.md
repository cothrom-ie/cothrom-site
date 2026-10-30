# cothrom-site

## Site Map

```sh
home
  |- Contact
  |- Gallery
  |- Production Management
  |- Technical Direction
  |- Creative Technology
  |- System Design
```

## Architecture

[Hugo](https://gohugo.io/) (Theme: No Fate) → static `./site` →
[Cloudflare Pages](https://pages.cloudflare.com/) via GitHub Actions + Wrangler.

Local preview still uses nginx (`compose.yml`) against the same `./site`
output. Production AppSec headers ship in `static/_headers` (copied into
`site/` at build time).

## Build & Development

Hugo Extended ≥ 0.158 is required (the No Fate theme needs the extended
build for Sass/webp processing). `make hugo-install` downloads the pinned
version into `./bin/hugo` for the host architecture (linux-amd64 or
linux-arm64); all other targets use that binary automatically when it runs.

On a fresh clone (or a machine move), initialize the theme submodule first,
then install Hugo:

```sh
git submodule update --init themes/no-fate
make hugo-install   # one-time: download Hugo Extended into ./bin/hugo
make serve          # dev server, LAN-reachable (binds 0.0.0.0; auto-detects
                    # the host's LAN IP for --baseURL, e.g. http://192.168.1.x:1313/).
                    # Override with `make serve LAN_IP=... PORT=... BIND=...`
                    # (e.g. `make serve BIND=127.0.0.1 LAN_IP=127.0.0.1` for
                    # the old localhost-only behaviour)
make build          # production build → ./site (matches compose.yml's mount)
make clean          # remove ./site, caches, and Hugo's lock file
make optimize-images  # resize/re-encode every raster under content/ to JPG
                      # (max width 1920, aspect ratio kept; replaces originals)
make help           # list all targets
```

### Optimizing `content/` images

`make optimize-images` scans `content/` recursively, resizes any raster wider
than **1920px** (aspect ratio preserved, never upscales), re-encodes as
progressive JPEG (q85) with JFIF density (**300 DPI** by default), **strips all
other metadata**, and writes only EXIF **Artist** (`Dominic Capparelli`) and
**Copyright** (`Cothrom Productions`). It **replaces the original file in
place**. Non-JPG sources become `<stem>.jpg` and the old file is removed —
update front matter if you drop a PNG/WebP. Preview with
`make optimize-images DRY_RUN=1`. Override with `MAX_WIDTH=…`, `DPI=…`,
`AUTHOR=…`, or `COMPANY=…`. Uses a local gitignored venv
(`.venv-optimize-images`, Pillow only — not a site runtime dependency). After
running it, `make build` (or `make clean && make build`) so Hugo regenerates
derivatives.

`publishDir` is `site/`. CI deploys that directory to Cloudflare Pages.
For a local production-like preview: `make build` then
`docker compose up -d nginx` → `http://127.0.0.1:8039/`.

## Environment Variables

Copy `.env.example` to `.env` (gitignored, never commit a filled-in copy)
and fill in real values as needed. `make build` / `make serve` load `.env`
automatically and pass the relevant variables through to Hugo as
`HUGO_PARAMS_*` overrides at build time — see `hugo.toml`'s `[params.contact]`
block and `systemPatterns.md` for the underscore-nesting gotcha in that
mechanism.

| Variable | Used by | Purpose |
| --- | --- | --- |
| `N8N_CONTACT_WEBHOOK_URL` | `make build`/`make serve` → Hugo `params.contact.webhookurl`; production: GitHub Actions secret of the same name | Full HTTPS URL of the n8n workflow that receives Contact form POSTs. Left blank, the form still renders but has no action URL and the page notes that submissions aren't wired (see `layouts/section/contact.html`). |
| `TURNSTILE_SITE_KEY` | `make build`/`make serve` → Hugo `params.contact.turnstilesitekey`; production: GitHub Actions secret of the same name | Cloudflare Turnstile **public** site key, safe to ship in built HTML. The matching Turnstile secret key is verified inside the n8n workflow only and must never appear in this repo. |
| `CLOUDFLARE_TUNNEL_TOKEN` | `compose.yml` (`cloudflare-tunnel` service) only | Optional/legacy local tunnel. Not used by Cloudflare Pages production. |

None of these variables are required for a local `make serve`/`make build` —
the site builds and renders correctly with them unset. For a live contact
form on Pages, set the two contact secrets in GitHub Actions.

## Deploy (Cloudflare Pages)

Production is **Cloudflare Pages** (Direct Upload). On every push to `main`
(and on `workflow_dispatch`), `.github/workflows/deploy-pages.yml`:

1. Checks out the repo **with submodules** (No Fate theme).
2. Installs Hugo Extended **0.158.0**.
3. Builds with `hugo --gc --minify` into `./site`, injecting contact params
   from GitHub secrets.
4. Deploys with Wrangler: `pages deploy site --project-name=cothrom-site`.

### GitHub Actions secrets

| Secret | Purpose |
| --- | --- |
| `CLOUDFLARE_API_TOKEN` | Account API token with **Cloudflare Pages: Edit** (least privilege). |
| `CLOUDFLARE_ACCOUNT_ID` | Cloudflare account ID. |
| `N8N_CONTACT_WEBHOOK_URL` | Same as local `.env` — baked into the Contact form `action` at build time. |
| `TURNSTILE_SITE_KEY` | Turnstile **public** site key baked into the form widget. |

Never commit these values. The Turnstile **secret** key stays in n8n only.

### Custom domains (apex + www)

Canonical host is the apex (`baseURL` = `https://cothrom.ie/`).

1. Create the Pages project `cothrom-site` (or let the first successful
   Wrangler deploy create it).
2. Attach **both** custom domains on the project: `cothrom.ie` and
   `www.cothrom.ie` (so both have TLS and resolve to Pages).
3. Add a **Bulk Redirect** (account-level) so www permanently redirects to
   apex — see [Redirecting www to domain apex](https://developers.cloudflare.com/pages/how-to/www-redirect/):

   | Source | Target | Status | Parameters |
   | --- | --- | --- | --- |
   | `www.cothrom.ie` | `https://cothrom.ie` | 301 | Preserve query string, subpath matching, preserve path suffix |

4. In Turnstile, allow hostnames `cothrom.ie` and `www.cothrom.ie`.
5. After Pages DNS is live, disable any Cloudflare Tunnel public hostnames
   that previously pointed at the nginx sidecar.

Verify:

```sh
curl -sI https://cothrom.ie/          # expect 200
curl -sI https://www.cothrom.ie/      # expect 301 → https://cothrom.ie/
curl -sI 'https://www.cothrom.ie/contact/?x=1'  # Location keeps path + query
```

## Local preview (Docker Compose)

`compose.yml` is for **local** production-like preview, not production:

- **`nginx`** — serves `./site` on port `8039` with `nginx.conf` (same
  AppSec headers as `static/_headers`, plus MIME mapping for
  `site.webmanifest`). Run `make build` first.
- **`cloudflare-tunnel`** — optional/legacy `cloudflared` sidecar using
  `CLOUDFLARE_TUNNEL_TOKEN`. Not required for local preview or Pages.

```sh
make build
docker compose up -d nginx              # local preview on :8039
```

## Pages

### Home

Basic Greeting, links

150 - 250 word biography

- White Papers links! (and a way to host white paper with hugo, for the future)

### Contact

- Contact Form
- Linkedin
- NO Phone/Email

### Gallery

Tiled, justified photo grid (rows auto-pack to the full width, no manual cropping needed —
see `memory-bank/creative/creative-gallery-tiled.md`). Click a photo for a larger framed
view with a two-line caption (`Role:` / `Event:` from YAML). To add a photo: drop the file
into `content/gallery/photos/` and add one `image` / `role` / `event` / `alt` entry to
`content/gallery/_index.md`'s `photos` front matter list.

## 1. Production Management

### Intended Audience

Artistic directors, producers, festival organisers, promoters, and larger production companies.

### Purpose

To coordinate the creative, technical, and organisational elements of a production, helping translate creative ambitions into a practical plan and overseeing its delivery.

### Scope

Production Management can involve early-stage planning, pre-production, creative and technical design coordination, scheduling, supplier management, resource planning, and the management of on-site production teams.

The role acts as an intermediary between artistic, technical, and management stakeholders, helping maintain alignment between the creative vision and the practical requirements of delivery.

The engagement can begin well before the event, with planning and coordination spread across several months, followed by a concentrated period on site.

Responsibilities and decision-making authority are established collaboratively with the client and other stakeholders. The scope can range from specific production responsibilities to comprehensive management of the production.

### Professional Approach

Collaboration is central to the role. Creative ambitions, technical requirements, responsibilities, and practical constraints should be understood and addressed collectively.

The aim is to enable creative work through informed planning, effective communication, clear accountability, and practical problem-solving.

### Editorial Direction

Present Production Management as a role that connects artistic vision with technical implementation and production delivery.

Emphasise the value of involving production management early enough to influence planning and design decisions, rather than treating the role solely as on-site coordination.

## 2. Technical Direction

### Intended Audience

AV companies, production companies, and local production facilities.

### Purpose

To lead and coordinate the technical implementation of a production, ensuring that the technical departments work together to deliver the agreed plan.

### Scope

Technical Direction can involve coordinating technical departments, managing relationships between department heads, overseeing implementation, resolving technical conflicts, and communicating between technical teams and technical management.

The role is commonly focused on on-site delivery, although earlier involvement in pre-production and technical planning is also desirable.

Responsibilities and decision-making authority are agreed according to the project, the client, and the contractual scope.

### Professional Approach

The role requires a broad understanding of technical production, effective coordination between departments, and the ability to make informed decisions as circumstances change.

The Technical Director provides a point of coordination for technical implementation while maintaining alignment with the wider production objectives.

### Editorial Direction

Position Technical Direction as the coordination and leadership of technical implementation.

Make the distinction from Production Management clear without suggesting that the two roles are mutually exclusive.

## 3. Creative Technology

### Intended Audience

Artists, creative directors, musicians, bands, producers, and other people developing creative work that requires technical expertise.

### Purpose

To help creatives explore, develop, and realise ideas that require technical solutions.

### Scope

Creative Technology can involve consultation, concept development, technical problem-solving, bespoke system design, and the management of implementation.

The work can range from straightforward technical documentation, such as stage plots for musicians, to elaborate concepts involving custom mechanisms, interactive systems, or specialised performance effects.

The service should be accessible to people who have a creative idea but are uncertain about its technical feasibility, how it could be implemented, or what expertise they need to engage.

The emphasis is on understanding the creative intention and developing an appropriate technical approach.

### Professional Approach

Creative ideas should be approached with curiosity and practical problem-solving.

The role is to help creatives understand what may be possible, explore suitable approaches, and develop solutions that support the intended artistic outcome.

The scope can be tailored to the project, from an initial consultation through detailed design and management of implementation.

### Editorial Direction

Position Creative Technology as an accessible route for creatives to engage technical expertise.

Unlike System Design, which is primarily aimed at technical professionals and organisations, this service should speak directly to people developing artistic or creative work.

Use examples from the biography, CV, and photographs where appropriate to illustrate the variety of creative challenges the service can address.

## 4. System Design

### Intended Audience

AV and production companies, technical departments, broadcast facilities, and organisations requiring specialist technical design.

### Purpose

To develop technical systems that meet defined operational and production requirements.

### Scope

System Design primarily focuses on temporary technical systems for AV, live events, and outside broadcast.

It can also include complex individual systems for specialist applications, such as recording, media management, and archival systems for broadcast facilities.

Depending on the engagement, responsibilities can extend from requirements gathering and system architecture through detailed design, documentation, programming, commissioning, and the management of on-site implementation.

Installation and other implementation activities can be coordinated and managed where included in the agreed scope. The role does not require me to carry out the physical installation work personally.

### Professional Approach

System Design combines technical understanding with structured planning and documentation.

The objective is to develop a coherent, practical solution that meets the client's requirements and can be implemented and operated reliably.

Design decisions should be supported by a clear understanding of the intended application, technical requirements, operational considerations, and the people responsible for implementing and maintaining the system.

### Editorial Direction

Position System Design as a service for technically informed clients who need a design developed, documented, and potentially carried through to commissioning.

Emphasise the ability to work across both event-based technical systems and more specialised, complex system requirements.

## Relationships Between Services

The four services are distinct in their primary purpose and audience, but they can overlap.

- Production Management focuses on coordinating the wider production and connecting its creative, technical, and organisational requirements.
- Technical Direction focuses on leading the technical implementation and coordinating the departments responsible for delivery.
- Creative Technology focuses on helping creative people develop ideas that require technical expertise.
- System Design focuses on developing technical architectures and solutions that meet defined requirements.

Creative Technology and System Design can involve similar design activities, but they begin from different perspectives. Creative Technology starts with a creative intention; System Design generally starts with technical or operational requirements.

Production Management and Technical Direction can also overlap, particularly where the same person is responsible for both the wider production and its technical delivery.

Services may be commissioned individually or combined according to the project. The website should communicate the distinctions without artificially restricting the ways in which the services can be delivered.

## Website-Wide Editorial Principles

- Use clear, accessible language appropriate to each service's intended audience.
- Emphasise the problems addressed and the value provided, rather than simply listing responsibilities.
- Maintain a professional, confident, collaborative tone.
- Avoid exaggerated marketing language and unsupported claims.
- Use the complete biography and CV as the primary sources of professional evidence.
- Use photographs to illustrate relevant work and reinforce the narrative.
- Do not invent experience, project responsibilities, or achievements.
- Distinguish established experience from areas of professional interest or future development.
- Where appropriate, show how technical knowledge supports creative and operational outcomes.
- Avoid unnecessary negative statements about the scope of services.
- Treat the site as a professional portfolio and contact point, with the Gallery providing a central visual record of relevant work.
- Allow the service pages to share relevant examples without simply repeating the same content.

The final page content, examples, images, and calls to action should be developed after the complete biography, CV, and photographic material have been provided.
