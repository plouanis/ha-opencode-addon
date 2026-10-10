# OpenCode add-on

This add-on runs the [OpenCode](https://opencode.ai) AI coding agent on your Home
Assistant OS box, exposed through HA's built-in panel (ingress). It starts with
`/config` as the working directory, so you can ask it to help you write or fix
your `configuration.yaml`, automations, and scripts.

## First run

1. **Start** the add-on, then open it from the sidebar (or use the "Open Web UI"
   button on the add-on page).
2. Set up a model provider. Either:
   - add an **API key** in the add-on Configuration tab (Anthropic/OpenAI), or
   - click **Connect** (`/connect`) inside the web UI and log in via
     opencode.ai/auth.

## Settings

- **server_password** — protect the web UI with a password (basic auth, the
  username is `opencode`).
- **anthropic_api_key** / **openai_api_key** / **google_api_key** /
  **openrouter_api_key** — provider keys exported as the matching environment
  variables.
- **model** — optional default model for the UI. Examples:
  - Claude: `anthropic/claude-sonnet-4-20250514`
  - GPT: `openai/gpt-4o`
  - Gemini (free tier at Google AI Studio): `google/gemini-2.5-flash`
  - OpenRouter (free models available): `openrouter/deepseek/deepseek-chat:free`

## Files & folders

- `/config` — your Home Assistant configuration, mounted read/write.
- Add-on `/data` is persistent and holds opencode state (sessions, login auth,
  config) across restarts.

## Troubleshooting

- **"Add-on could not be built"** — the HA box needs internet to pull the base
  image `ghcr.io/anomalyco/opencode`; check network access and retry.
- **Web UI asks for a password** — you set `server_password` (or a leftover from a
  previous config); the username is `opencode`.
- **No responses / provider errors** — check that an API key is set and the
  `model` value matches a provider you have a key for.