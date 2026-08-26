#!/usr/bin/env bash
# Installs claude-or: downloads the script to ~/.local/bin and makes it
# executable. Safe to re-run to update to the latest version.
#
#   curl -fsSL https://raw.githubusercontent.com/Traace-co/claude-or/main/install.sh | bash
set -euo pipefail

repo_raw_url="https://raw.githubusercontent.com/Traace-co/claude-or/main/claude-or"
install_dir="${CLAUDE_OR_INSTALL_DIR:-$HOME/.local/bin}"
install_path="$install_dir/claude-or"

echo "==> Checking requirements"
if ! command -v claude >/dev/null 2>&1; then
  echo "    ! 'claude' (Claude Code) not found on PATH — install it first: https://claude.com/claude-code"
  echo "      claude-or won't run without it, but we'll install the wrapper anyway."
else
  echo "    - claude found: $(command -v claude)"
fi

if command -v op >/dev/null 2>&1; then
  echo "    - 1Password CLI (op) found: $(command -v op)"
else
  echo "    - 1Password CLI (op) not found — fine if you plan to use a raw API key"
  echo "      instead of an op:// reference for CLAUDE_OR_API_KEY."
fi

echo "==> Creating $install_dir"
mkdir -p "$install_dir"

echo "==> Downloading claude-or to $install_path"
tmp_path="$(mktemp "$install_dir/claude-or.XXXXXX")"
trap 'rm -f "$tmp_path"' EXIT
curl -fsSL "$repo_raw_url" -o "$tmp_path"
chmod 755 "$tmp_path"
mv "$tmp_path" "$install_path"
trap - EXIT

echo "==> Installed: $install_path"

case ":$PATH:" in
  *":$install_dir:"*)
    ;;
  *)
    echo
    echo "==> $install_dir is not on your PATH."
    echo "    Add this to your shell profile (~/.bashrc, ~/.zshrc, ...):"
    echo
    echo "        export PATH=\"$install_dir:\$PATH\""
    echo
    ;;
esac

echo "==> Next: configure CLAUDE_OR_API_KEY, then run 'claude-or'"
echo "    See https://github.com/Traace-co/claude-or#configure for details."
