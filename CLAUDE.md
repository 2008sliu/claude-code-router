# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

-   **Build the project**:
    ```bash
    npm run build
    ```
-   **Start the router server**:
    ```bash
    ccr start
    ```
-   **Stop the router server**:
    ```bash
    ccr stop
    ```
-   **Check the server status**:
    ```bash
    ccr status
    ```
-   **Run Claude Code through the router**:
    ```bash
    ccr code "<your prompt>"
    ```
-   **Release a new version**:
    ```bash
    npm run release
    ```

## Architecture

This project is a TypeScript-based router for Claude Code requests. It allows routing requests to different large language models (LLMs) from various providers based on custom rules.

-   **Entry Point**: The main command-line interface logic is in `src/cli.ts`. It handles parsing commands like `start`, `stop`, and `code`.
-   **Server**: The `ccr start` command launches a server that listens for requests from Claude Code. The server logic is initiated from `src/index.ts`.
-   **Configuration**: The router is configured via a JSON file located at `~/.claude-code-router/config.json`. This file defines API providers, routing rules, and custom transformers. An example can be found in `config.example.json`.
-   **Routing**: The core routing logic determines which LLM provider and model to use for a given request. It supports default routes for different scenarios (`default`, `background`, `think`, `longContext`, `webSearch`) and can be extended with a custom JavaScript router file. The router logic is likely in `src/utils/router.ts`.
-   **Providers and Transformers**: The application supports multiple LLM providers. Transformers adapt the request and response formats for different provider APIs.
-   **Claude Code Integration**: When a user runs `ccr code`, the command is forwarded to the running router service. The service then processes the request, applies routing rules, and sends it to the configured LLM. If the service isn't running, `ccr code` will attempt to start it automatically.
-   **Dependencies**: The project is built with `esbuild`. It has a key local dependency `@musistudio/llms`, which probably contains the core logic for interacting with different LLM APIs.
-   `@musistudio/llms` is implemented based on `fastify` and exposes `fastify`'s hook and middleware interfaces, allowing direct use of `server.addHook`.
- 无论如何你都不能自动提交git

## Other information
### The vllm server and qwen3-omni-30b model
- There is a repo for it at ~/github/qwen3. The Qwen3 official repo is cloned as a submodule at ~/github/vendor/Qwen3-Omni.
- There is an vllm instance serving the qwen3-omni-30b model (omni model for short) at port 8010. The vllm repo is cloned to ~/github/qwen3/vllm. but not as a submodule of ~/github/qwen3.
- The service will be started manually by using the script `~/github/qwen3/vllm/start.sh`. You can read its content to see the server configuration. You should NEVER start it. You can ask me to restart the server. The server's log is appended to `~/github/qwen3/vllm/server.log`. You can use `echo "" > ~/github/qwen3/vllm/server.log` to empty it and get some fresh log when doing new test.
- There is `~/github/qwen3/test2.sh` which demonstrates how to communicate with the omni model served by vllm. The client, like claude-code-router, should form requests like this.

### claude-code-router (ccr) testing using source code
- you should not use the `ccr` command, it may using another system-level installed ccr. You should explictily use `/home/helion/miniconda3/envs/ubuntu/bin/node ~/repos/zsh/external/github/claude-code-router/dist/cli.js`, or the `test.sh`, which hardcode to use this version of node
- you use ./build.sh to build the node project, which uses the right version of node in the right directly.
- There is a doc in ~/repos/zsh/docs/mcp/claude-code-router-image.md, which has some analysis on how does claude-code-router handles images. (It also contains some part related to jupyter-mcp server, which is not relevant here)
- You can use ./test-no-image.sh to test without image