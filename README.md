# Home Assistant add-on: OpenCode

Run the [OpenCode](https://opencode.ai) AI coding agent — the same assistant you're
talking to now — on your Home Assistant box, accessible from any browser through
the HA panel (ingress).

It starts `opencode web` inside a container and gives it read/write access to your
HA `configuration.yaml` and friends, so you can ask it to work on your automation
and config YAML directly.

## Requirements

- Home Assistant **OS** (HAOS) — the add-on host is read-only, so this runs as a
  containerized add-on.
- An LLM provider API key (Anthropic, OpenAI, …) that OpenCode supports.

## Install

1. In Home Assistant go to **Settings → Add-ons → Add-on store** (bottom right).
2. Click **⋮ → Repositories**, paste this repository URL and click **Add**:
   `https://github.com/plouanis/ha-opencode-addon`
3. The OpenCode add-on appears in the store. Click **Install**.
4. Configure API keys in the **Configuration** tab (or leave empty and run
   `/connect` in the web UI to log in through opencode.ai/auth).
5. Click **Start**. The add-on opens as a panel in HA (example:
   `http://192.168.1.11:8123/hassio/opencode`).

## Configuration

| Option             | Maps to                          | Notes                                |
| ------------------ | -------------------------------- | ------------------------------------ |
| `server_password`  | `OPENCODE_SERVER_PASSWORD`       | Basic-auth password for the web UI (username `opencode`) |
| `anthropic_api_key`| `ANTHROPIC_API_KEY`              | Claude provider                     |
| `openai_api_key`   | `OPENAI_API_KEY`                 | OpenAI provider                     |
| `model`            | opencode config `model`          | Default model, e.g. `anthropic/claude-sonnet-4-20250514` |

Everything is persisted under the add-on's `/data` folder (sessions, auth,
config), so it survives restarts.

## What it can touch

- `/config` — your Home Assistant configuration (read/write, via the add-on
  `map: config:rw`). OpenCode starts there.

## Notes

- The add-on builds locally on the HA box from `ghcr.io/anomalyco/opencode`.
- Only `amd64` (x86-64) is targeted; arm boards aren't covered yet.

## Development

```
repo root/
  opencode/          <- the add-on (config.yaml, Dockerfile, run.sh)
    config.yaml
    Dockerfile
    build.yaml
    run.sh
```