#!/bin/sh
# OpenCode add-on entrypoint.
set -eu

export HOME=/data/home
mkdir -p "${HOME}" /data/config /data/data /data/cache
export XDG_CONFIG_HOME=/data/config
export XDG_DATA_HOME=/data/data
export XDG_CACHE_HOME=/data/cache

# Stop `opencode web` trying to open a browser on this headless box.
export BROWSER=false

# Map add-on options (in /data/options.json) to environment variables opencode
# and the model providers actually read.
if [ -f /data/options.json ] && command -v node >/dev/null 2>&1; then
  eval "$(node -e '
    var fs = require("fs");
    var o = {};
    try { o = JSON.parse(fs.readFileSync("/data/options.json", "utf8")); } catch (e) {}
    var map = {
      server_password:   "OPENCODE_SERVER_PASSWORD",
      anthropic_api_key: "ANTHROPIC_API_KEY",
      openai_api_key:    "OPENAI_API_KEY",
      google_api_key:    "GOOGLE_GENERATIVE_AI_API_KEY",
      openrouter_api_key: "OPENROUTER_API_KEY",
      model:             "OPENCODE_DEFAULT_MODEL"
    };
    var out = [];
    Object.keys(map).forEach(function (k) {
      var v = o[k];
      if (v) out.push("export " + map[k] + "=" + JSON.stringify(String(v)));
    });
console.log(out.join("\n"));
    ')"
fi

# Alias for opencode's "gemini" provider naming.
if [ -n "${GOOGLE_GENERATIVE_AI_API_KEY:-}" ]; then
  export GEMINI_API_KEY="${GOOGLE_GENERATIVE_AI_API_KEY}"
fi

# Optional default model for the web UI.
if [ -n "${OPENCODE_DEFAULT_MODEL:-}" ]; then
  mkdir -p "${XDG_CONFIG_HOME}/opencode"
  node -e '
    var fs = require("fs");
    var p = "/data/config/opencode/opencode.json";
    var c = {};
    try { c = JSON.parse(fs.readFileSync(p, "utf8")); } catch (e) {}
    c.model = process.env.OPENCODE_DEFAULT_MODEL;
    fs.writeFileSync(p, JSON.stringify(c, null, 2));
  '
fi

cd /config
exec opencode web --hostname 0.0.0.0 --port 8099