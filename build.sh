#!/bin/bash

eval "$(conda shell.bash hook)"
conda activate ubuntu

cd /home/helion/repos/zsh/external/github/claude-code-router && /home/helion/miniconda3/envs/ubuntu/bin/npm run build
