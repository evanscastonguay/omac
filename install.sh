#!/bin/bash
# Install or update Omac — a keyboard-driven tiling window manager for macOS.
#
#   curl -fsSL https://raw.githubusercontent.com/evanscastonguay/omac/main/install.sh | bash
#
# A specific version:  ... | bash -s -- v1.4.4
#
# What this does: downloads the release, checks its SHA-256, and runs the
# installer that ships inside it. That installer checks the app's Developer ID
# signature, removes any old copy in /Applications, installs to ~/Applications,
# puts the `omac` command on your PATH and starts Omac.
#
# Everything is inside main(), called on the last line, so a download cut off
# half way runs nothing.
set -euo pipefail

# Global, not `local`: the EXIT trap fires after main() has returned, when a
# local would be gone and `set -u` would turn a successful install into an error.
tmp=""
trap '[ -n "${tmp:-}" ] && rm -rf "$tmp"' EXIT

main() {
  local repo="evanscastonguay/omac"
  local want="${1:-latest}"
  local base
  if [ -n "${OMAC_BASE_URL:-}" ]; then
    base="$OMAC_BASE_URL"                                     # tests only
  elif [ "$want" = latest ]; then
    base="https://github.com/$repo/releases/latest/download"
  else
    base="https://github.com/$repo/releases/download/$want"
  fi

  fail() { printf '\n\033[31mOmac was not installed:\033[0m %s\n' "$*" >&2; exit 1; }

  [ "$(uname -s)" = Darwin ] || fail "Omac runs on macOS only."
  [ "$(uname -m)" = arm64 ]  || fail "Omac needs a Mac with Apple silicon (this one is $(uname -m))."
  local os major
  os=$(sw_vers -productVersion); major=${os%%.*}
  [ "$major" -ge 14 ] || fail "Omac needs macOS 14 or later (this Mac has $os)."

  tmp=$(mktemp -d)

  printf 'Downloading Omac (%s)…\n' "$want"
  curl -fL --progress-bar -o "$tmp/Omac-arm64.zip" "$base/Omac-arm64.zip" \
    || fail "the download failed. Check your connection and try again."
  curl -fsSL -o "$tmp/Omac-arm64.zip.sha256" "$base/Omac-arm64.zip.sha256" \
    || fail "could not download the checksum."

  # Proves the download is complete and uncorrupted. Authenticity is checked by
  # the next step, against the app's Developer ID signature.
  ( cd "$tmp" && shasum -a 256 -c Omac-arm64.zip.sha256 >/dev/null 2>&1 ) \
    || fail "the download is corrupted (checksum mismatch). Try again."

  ditto -x -k "$tmp/Omac-arm64.zip" "$tmp/x"
  local inst
  inst=$(find "$tmp/x" -maxdepth 2 -name install.sh -type f | head -1)
  [ -n "$inst" ] || fail "the download has no installer in it."

  /bin/bash "$inst"
}

main "$@"
