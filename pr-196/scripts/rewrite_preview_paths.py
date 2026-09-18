#!/usr/bin/env python3
"""Rewrite root-absolute paths in a built Jekyll site for PR-preview hosting.

This site's templates and content use root-absolute paths everywhere
(`/img/...`, `/css/...`, `href="/story"`, etc.) instead of Jekyll's
baseurl-aware `relative_url` filter - correct for production, which is
always served at the domain root, but broken for a PR preview, which is
served under a subpath like `/pluribusdigital-com-preview/pr-42/`.

Rather than touch the site's source (which would ripple through every
include, layout, and content page for a change that only matters to this
one dev-tooling use case), this script rewrites the *already-built*
`_site/` output in place. It's only ever invoked by the PR preview
workflow - production's build and source are untouched.

Usage: rewrite_preview_paths.py <site-dir> <url-prefix>
e.g.:  rewrite_preview_paths.py _site /pluribusdigital-com-preview/pr-42
"""
import re
import sys
from pathlib import Path

# href="/x", src="/x", action="/x" (single or double quoted), but not a
# protocol-relative "//host/path" reference.
HTML_ATTR_RE = re.compile(
    r'\b(href|src|action)=(["\'])(/(?!/)[^"\']*)\2'
)

# CSS url(/x) or url("/x") or url('/x'), but not url(//host/path).
CSS_URL_RE = re.compile(
    r'\burl\(\s*(["\']?)(/(?!/)[^"\')]*)\1\s*\)'
)


def rewrite_html(text: str, prefix: str) -> str:
    return HTML_ATTR_RE.sub(
        lambda m: f'{m.group(1)}={m.group(2)}{prefix}{m.group(3)}{m.group(2)}',
        text,
    )


def rewrite_css(text: str, prefix: str) -> str:
    return CSS_URL_RE.sub(
        lambda m: f'url({m.group(1)}{prefix}{m.group(2)}{m.group(1)})',
        text,
    )


def main() -> None:
    if len(sys.argv) != 3:
        print(__doc__)
        sys.exit(1)

    site_dir = Path(sys.argv[1])
    prefix = sys.argv[2].rstrip("/")
    if not prefix.startswith("/"):
        prefix = "/" + prefix

    if not site_dir.is_dir():
        print(f"error: {site_dir} is not a directory", file=sys.stderr)
        sys.exit(1)

    changed = 0
    for path in site_dir.rglob("*"):
        if not path.is_file():
            continue
        if path.suffix == ".html":
            rewrite = rewrite_html
        elif path.suffix == ".css":
            rewrite = rewrite_css
        else:
            continue

        original = path.read_text(encoding="utf-8")
        updated = rewrite(original, prefix)
        if updated != original:
            path.write_text(updated, encoding="utf-8")
            changed += 1

    print(f"rewrote root-absolute paths to '{prefix}' in {changed} file(s)")


if __name__ == "__main__":
    main()
