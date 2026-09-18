#!/usr/bin/env bash
set -euo pipefail

# Quote every --content pattern so purgecss's own glob engine (globby) expands
# the recursive "**", not the invoking shell. Unquoted "**" is only recursive
# under bash's `globstar` option (off by default, and not even available on
# macOS's stock bash 3.2) - without it, "**/*.md" silently collapses to a
# single-level "*/*.md" and misses anything nested two directories deep, e.g.
# content/join/benefits.md. That under-scanning is what let purgecss strip
# classes that were actually in use on those pages.
#
# The patterns below are also scoped to the actual content-bearing
# directories, not the whole repo root, so gitignored build/vendor output
# (_site/, vendor/) can never leak into the scan just because it happens to
# exist on disk locally.
echo "...prepping CSS..."
npx --yes purgecss \
  --css css/vendor/bootstrap.min.css \
  --content \
    "_includes/**/*.html" \
    "_layouts/**/*.html" \
    "_content/**/*.md" \
    "content/**/*.md" \
    "_posts/**/*.md" \
    "posts/**/*.html" \
    "redirects/**/*.md" \
    "index.md" \
    "404.html" \
  --output css/build
echo "... CSS prepped ..."
