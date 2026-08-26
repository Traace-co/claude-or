# claude-or

Run [Claude Code](https://claude.com/claude-code) routed through [OpenRouter](https://openrouter.ai)
instead of a direct Anthropic subscription/API key — handy as a fallback once
your Claude subscription runs out of usage for the session.

`claude` stays completely untouched. `claude-or` is a separate command that
launches the same CLI, same args, but with OpenRouter's Anthropic-compatible
gateway (`https://openrouter.ai/api`) as the backend for that one process.

The OpenRouter API key is either resolved fresh from [1Password](https://1password.com)
via the `op` CLI on every invocation, or passed directly as a raw key — either way
it's never written to disk or exported outside that single process's environment.

## Requirements

- Claude Code (`claude`) installed and on `PATH`
- An OpenRouter API key, either:
  - stored as a 1Password item, resolved via the [1Password CLI](https://developer.1password.com/docs/cli/)
    (`op`) installed and signed in — or
  - passed raw as `CLAUDE_OR_API_KEY`, no `op` CLI required

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/Traace-co/claude-or/main/install.sh | bash
```

Installs to `~/.local/bin/claude-or` (override with `CLAUDE_OR_INSTALL_DIR`). Re-run
the same command any time to update to the latest version.

Alternatively, clone the repo and link the script yourself:

```bash
ln -s "$(pwd)/claude-or" ~/.local/bin/claude-or   # or copy it anywhere on your PATH
chmod +x claude-or
```

## Configure

`CLAUDE_OR_API_KEY` accepts either form:

- A 1Password reference (`op://<vault>/<item>/<field>`) — resolved via `op read` on
  every run, never written to disk. Pair it with `CLAUDE_OR_OP_ACCOUNT` if the item
  isn't in your default 1Password account.
- A raw OpenRouter API key — used as-is, no `op` CLI required. Useful in
  environments without access to 1Password's desktop-unlock bridge (e.g. most
  devcontainers) — inject it there as a plain secret/env var instead.

```bash
export CLAUDE_OR_API_KEY="op://<vault>/<item>/<field>"   # 1Password
export CLAUDE_OR_OP_ACCOUNT="<your-1password-account>"    # optional, only used with op://

# or

export CLAUDE_OR_API_KEY="sk-or-..."                      # raw key
```

Defaults to `op://Employee/OpenRouter API Key - Claude Code/credential` on the
`tennaxia.1password.eu` account if unset.

## Usage

```bash
claude       # normal Anthropic subscription login, unchanged
claude-or    # same CLI, routed through OpenRouter for this run
```

Inside a `claude-or` session, run `/status` to confirm it's routed through
OpenRouter, and `/model` to see the Claude models available via OpenRouter's
gateway (enabled by `CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY=1`).
