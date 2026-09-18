# PluribusDigital.com

Source for PluribusDigital's public marketing site — a Jekyll site published via GitHub Pages.
`main` is protected and only updates via PR; once merged, production goes live in about a minute.
Full detail lives in [README.md](README.md), [GUIDELINES.md](GUIDELINES.md), and
[TROUBLESHOOTING.md](TROUBLESHOOTING.md) — this file summarizes what's most load-bearing for
editing the site correctly.

## Workflow

- Branch (or fork) → commit → PR → merge. Never push directly to `main`.
- Run locally before trusting a change, especially anything touching HTML/CSS/JS.
- Every PR gets an automatic live preview (see README's "PR Previews" section) — built and
  published to a separate `pluribusdigital-com-preview` repo, linked via a PR comment.
  Production's own build/deploy is untouched by this.

## Content model

- `_content/*.md` (underscore) — complex top-level pages, built from multiple section files in a
  subfolder so each section can use its own layout.
- `content/*.md` (no underscore) — simple interior pages. Directory structure mirrors the URL path.
- `/index.md` + `_layouts/home.html` — home page.
- Blog content is hosted on Medium, not in this repo (see README's Blog Content section) — don't
  try to add blog posts as files here.
- Every content page needs YAML front-matter (`layout`, `title`, `nav_highlight`, optional
  `permalink`, etc.) — copy an existing page as a starting template rather than writing it from
  scratch.

## Voice & style (GUIDELINES.md + linked brand voice guide)

- Plain language, no jargon, straightforward and authentic tone.
- Hyperlink text must be meaningful out of context — never "click here."
- Content should be scannable: real headings, real lists, not walls of text.
- No stock photos, no AI-generated images — real photos or custom illustration only.
- Minimize animation/JS; don't subvert normal browser behavior (scrolling, back button, etc.).
- Semantic, non-bloated HTML — lists are `<ul>`, paragraphs are `<p>`, no unnecessary nested divs.
- Site must work without CSS or JS, and render well on mobile / narrow / high-zoom viewports.
- Brand voice (from `PluribusDigital/playbook/branding/guide.md`): Pluribus positions itself as a
  hands-on transformation partner for government missions. Five attributes to write toward:
  committed/purpose-driven, inclusive and jargon-free, authentic rather than buzzword-chasing,
  genuinely curious (comfortable citing real experience over posturing as an all-knowing expert),
  and professionally authentic (no militaristic language, gendered terms, or "rockstar" hiring
  speak). Tone shifts by channel — web content should read conversational and high-level, distinct
  from the more formal register used in proposals.

## Running locally

- Preferred: Docker — `docker compose up --build`, then http://localhost:4000/. This matches the
  Ruby version GitHub Pages actually builds with, and sidesteps native toolchain issues entirely.
- Native path pins Ruby to `3.1.x` (see `.ruby-version`) for a real reason: `github-pages`'s Jekyll
  3.9.0 / Liquid 4.0.3 call `String#tainted?`, which was removed in Ruby 3.2. **Don't suggest
  bumping the local Ruby version past 3.1.x** — that breaks every page render. If native setup hits
  errors, point to TROUBLESHOOTING.md rather than improvising fixes.
- Restart the server after any `_config.yml` change.

## CSS

- Bootstrap 4.x is the baseline. Custom overrides live in `css/site.css`; `css/greenhouse.css`
  holds overrides shipped separately to Greenhouse for job-listing iframes.
- To trim unused CSS, run `bash prepcss.sh` (purgecss), then point
  `_includes/template_meta.html` at `css/build/...` instead of `css/vendor/...`. Use the `vendor/`
  path while actively iterating on styles, switch back to `build/` when done.

## Job board (Greenhouse)

- `_content/join/02_openings.md` renders the openings list on the main Join Us page;
  `content/join/openings.md` is the detail page Greenhouse links to. Some styling is configured
  Greenhouse-side (Configure > Job boards & posts > Pluribus Digital), outside this repo.
- Known future improvement (not yet built): a process/skill to audit this Greenhouse integration
  for breaking changes.

## Redirects

Client-side redirects go in `/redirects/` as a markdown file using the redirect template — see
`/redirects/cio-sp3` for an example.
