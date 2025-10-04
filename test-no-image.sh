#!/bin/bash
cd ~/test
: >/tmp/ccr_server.log
echo "" >~/github/qwen3/vllm/server.log
/home/helion/miniconda3/envs/ubuntu/bin/node ~/repos/zsh/external/github/claude-code-router/dist/cli.js stop || true
/home/helion/miniconda3/envs/ubuntu/bin/node ~/repos/zsh/external/github/claude-code-router/dist/cli.js code -p "what is today's date"
