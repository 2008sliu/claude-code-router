#!/bin/bash

eval "$(conda shell.bash hook)"
conda activate ubuntu

cd /home/helion/repos/zsh/external/github/claude-code-router
node dist/cli.js stop
npm run build
