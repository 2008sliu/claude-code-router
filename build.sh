#!/bin/bash

eval "$(conda shell.bash hook)"
conda activate ubuntu

cd ~/repos/zsh/external/github/claude-code-router
node dist/cli.js stop

# Build llms first
echo "Building llms..."
(cd llms && npm run build)

# Then build claude-code-router
echo "Building claude-code-router..."
npm run build
