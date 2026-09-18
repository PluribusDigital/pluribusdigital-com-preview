#!/usr/bin/env ruby
# frozen_string_literal: true

# Wrapper around `jekyll serve --watch` for the Docker container.
#
# Jekyll 3.9.0's Utils::Platforms#proc_version reads /proc/version (via the
# `pathutil` gem) to detect Bash-on-Windows. On Ruby 3+, pathutil 0.16.2's
# `read` breaks under Ruby 3's stricter positional/keyword argument split and
# raises TypeError instead of the Errno::ENOENT it expects when /proc/version
# is absent. On Linux (i.e. this container), /proc/version exists, so the
# call runs and crashes with TypeError before it's ever rescued -- only when
# `--watch` is used (entering watch mode is what triggers the check).
#
# GitHub Pages' production build runs a one-shot `jekyll build` and never
# enters watch mode, so this bug -- and this patch -- have no bearing on what
# actually gets deployed; this is purely a local-dev-server fix.
#
# `github-pages (214)` pins `jekyll (= 3.9.0)` for parity with GitHub's
# actual build, and enables Jekyll's "safe mode" (which disables `_plugins/`)
# for that same parity, so we can't patch this via a normal Jekyll plugin.
# Instead we require jekyll, monkeypatch it, and only then load the jekyll
# CLI -- since it's already been required, its own (buggy) definition of
# proc_version never gets loaded to overwrite this one.
#
# Fixed upstream in jekyll 3.9.2, which dropped the pathutil dependency
# entirely -- if `github-pages` ever bumps past `jekyll (= 3.9.0)`, this
# whole file can likely be deleted.

require "jekyll"

module Jekyll
  module Utils
    module Platforms
      def proc_version
        @proc_version ||= begin
          Pathutil.new("/proc/version").read
        rescue Errno::ENOENT, TypeError
          nil
        end
      end
    end
  end
end

ARGV.replace(%w[serve --host 0.0.0.0 --watch --force_polling --livereload])
load Gem.bin_path("jekyll", "jekyll")
