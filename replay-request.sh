#!/bin/bash

# This script replays the logged request directly to qwen3-omni-30b
# to see what the model actually receives and how it responds

LOG_FILE=~/tmp/ccr_server.log

if [ ! -f "$LOG_FILE" ]; then
    echo "Error: $LOG_FILE not found"
    echo "Run test.sh first to generate the request log"
    exit 1
fi

echo "Extracting latest SENDING_TO_MODEL_API request from $LOG_FILE..."

# Extract the last SENDING_TO_MODEL_API entry and get its body
REQUEST_BODY=$(jq -r 'select(.topic == "SENDING_TO_MODEL_API") | .body' "$LOG_FILE" | tail -n 1)

if [ -z "$REQUEST_BODY" ] || [ "$REQUEST_BODY" == "null" ]; then
    echo "Error: No SENDING_TO_MODEL_API entry found in log file"
    exit 1
fi

# Extract URL from the log entry (fallback to default if not found)
URL=$(jq -r 'select(.topic == "SENDING_TO_MODEL_API") | .url' "$LOG_FILE" | tail -n 1)
if [ -z "$URL" ] || [ "$URL" == "null" ]; then
    URL="http://localhost:8010/v1/chat/completions"
    echo "Using default URL: $URL"
else
    echo "Using URL from log: $URL"
fi

echo ""
echo "Replaying request..."
echo ""

echo "$REQUEST_BODY" | curl -s "$URL" \
  -H "Content-Type: application/json" \
  -d @- | jq .
