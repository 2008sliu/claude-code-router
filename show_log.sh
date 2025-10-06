#!/bin/bash

# Parse ccr_server.log and produce simplified JSONL output
# Usage: ./show_log.sh [log_file]
# Default log file: ~/tmp/ccr_server.log

LOG_FILE="${1:-~/tmp/ccr_server.log}"

if [ ! -f "$LOG_FILE" ]; then
    echo "Error: Log file not found: $LOG_FILE" >&2
    exit 1
fi

# Use jq to extract only the relevant fields and print nicely formatted
jq '{
    topic: .topic,
    time: .timestamp,
    model: .model // .selectedModel // .body.model // null,
    system: .system // .body.system // null,
    messages: .messages // .body.messages // null
}' "$LOG_FILE" | sed 's/iVBORw0KGgoAAAANSUhEUgAAA9[^"]*U0FgAAAABJRU5ErkJggg/====[IMAGE]====/' | sed 's#You are an interactive CLI tool.*/example>#You are an interactive=======/example>#'
