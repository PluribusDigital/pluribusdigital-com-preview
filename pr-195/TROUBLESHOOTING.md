# Troubleshooting Local Setup

If `bundle install`, `gem install jekyll`, or `bundle exec jekyll serve` fail when running this
site without Docker, the most reliable fix is usually to switch to [Docker](README.md#running-with-docker)
instead — it builds in a clean, pinned Linux container and avoids every issue below. If you'd
rather run natively, here's what commonly goes wrong and why.

## Why Ruby is pinned to 3.1.x

This repo's `.ruby-version` pins Ruby to `3.1.7`. `Gemfile` depends on `github-pages ~> 214`,
which pulls in Jekyll `3.9.0` and, transitively, Liquid `4.0.3`. Liquid `4.0.3` calls Ruby's
`String#tainted?`, which was fully removed in Ruby 3.2. On Ruby 3.2+, any page render fails with:

```text
undefined method 'tainted?' for an instance of String (NoMethodError)
```

Don't bump the local Ruby version past 3.1.x until GitHub updates the `github-pages` gem to a
newer Jekyll/Liquid that no longer depends on removed taint-checking methods.

If you use [rbenv](https://github.com/rbenv/rbenv), it will pick up `.ruby-version`
automatically once the matching Ruby version is installed (`rbenv install 3.1.7`).

## Xcode license not accepted

Symptom: `gem install` or `bundle install` fails building any native extension, often with
`pkg-config` or "no such file" style errors that don't obviously point at licensing.

Fix:

```bash
sudo xcodebuild -license accept
```

## Apple Silicon: mismatched Homebrew/Ruby architecture

Symptom: linker errors like:

```text
ld: warning: ignoring file '...dylib': found architecture 'x86_64', required architecture 'arm64'
Undefined symbols for architecture arm64: ...
```

This means your Homebrew and your Ruby toolchain don't agree on CPU architecture — usually an
x86_64 Homebrew (installed under Rosetta, living at `/usr/local`) paired with a natively-built
arm64 Ruby, or vice versa.

Fix: install a native arm64 Homebrew (it installs to `/opt/homebrew` on Apple Silicon) and build
Ruby against *that* Homebrew's libraries:

```bash
arch -arm64 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
/opt/homebrew/bin/brew install openssl@3 libyaml gmp pkg-config

PATH="/opt/homebrew/bin:$PATH" \
RUBY_CONFIGURE_OPTS="--with-openssl-dir=/opt/homebrew/opt/openssl@3 --with-libyaml-dir=/opt/homebrew/opt/libyaml --with-gmp-dir=/opt/homebrew/opt/gmp" \
rbenv install 3.1.7
```

Avoid running commands under `arch -x86_64` to "force" a matching architecture — in practice
this has proven unreliable (some sub-compiles still target the native arch), and native arm64 is
the more robust long-term fix anyway.

## `mkmf` capability checks failing with "no" for things that should work

Symptom: a native extension build fails deep into compilation (e.g. a missing generated header,
or an "undeclared identifier" for a function that should exist), but the `checking for X... no`
lines earlier in the log don't make sense for your setup.

Cause: a newer Xcode/clang emits a new warning (`-Wdefault-const-init-field-unsafe`) from within
Ruby's own headers. `mkmf`'s internal "is this flag/function available" probes compile with
`-Werror`, so *every* probe fails on this unrelated warning, silently producing wrong answers
(missing include paths, wrong fallback code paths, etc.) further down the build.

Fix: suppress the warning when installing Ruby or gems:

```bash
CFLAGS="-Wno-default-const-init-field-unsafe" rbenv install 3.1.7
CFLAGS="-Wno-default-const-init-field-unsafe" bundle install
```

## Docker: `jekyll serve --watch` crashes with "no implicit conversion of Hash into Integer"

This one only shows up inside the Docker container (or on native Linux), never on macOS, and
it's already handled for you — `docker/jekyll_serve.rb` patches around it before starting the
server. Documented here in case the crash resurfaces (e.g. after a `github-pages` gem bump) or
you're debugging outside the container's wrapper script.

Cause: Jekyll 3.9.0's Bash-on-Windows detection (only triggered by `--watch`, only on Linux where
`/proc/version` exists) calls into the `pathutil` gem, which breaks under Ruby 3's keyword-argument
handling. `github-pages (214)` pins `jekyll (= 3.9.0)` for parity with GitHub's actual build (which
runs a one-shot `jekyll build`, never `--watch`, so it never hits this), so we can't just bump
Jekyll to the 3.9.2 patch that fixed it upstream. `github-pages` also forces Jekyll's "safe mode,"
which disables `_plugins/`, so a normal Jekyll plugin can't patch it either — see
`docker/jekyll_serve.rb` for the boot-time monkeypatch that works around both constraints.
