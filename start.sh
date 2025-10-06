#!/bin/bash
# cd ~/test
: >~/tmp/ccr_server.log
echo "" >~/github/qwen3/vllm/server.log

config_file="$HOME/.claude-code-router/config.json"

# Extract model from config, trim leading chars up to and including ','
model=$(cat "$config_file" | jq -r .Router.default 2>/dev/null || echo "wrong")
# Trim everything up to and including the last comma
model_name=${model##*,}
export MY_CCR_NAME=${model_name}

echo "CCR_SERVER=$CCR_SERVER MODEL=${model_name}"

/home/helion/miniconda3/envs/ubuntu/bin/node ~/repos/zsh/external/github/claude-code-router/dist/cli.js stop || true
/home/helion/miniconda3/envs/ubuntu/bin/node ~/repos/zsh/external/github/claude-code-router/dist/cli.js code
