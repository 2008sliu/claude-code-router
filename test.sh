#!/bin/bash
cd ~/test
echo "" >~/github/qwen3/vllm/server.log
/home/helion/miniconda3/envs/ubuntu/bin/node ~/repos/zsh/external/github/claude-code-router/dist/cli.js stop
/home/helion/miniconda3/envs/ubuntu/bin/node ~/repos/zsh/external/github/claude-code-router/dist/cli.js code -p "read the image @~/repos/zsh/external/github/jupyter-mcp-server/.jupyter/images/1d26459fe3a5704248b845ac11ff8b6c.png and tell me what does it contain"
