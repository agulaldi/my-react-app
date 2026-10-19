#!/bin/bash
# DO hook (PreToolUse, Bash): blocks dangerous commands right before they execute

INPUT=$(cat)
CMD=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# Case-insensitive and whitespace-tolerant ("terraform  destroy", "terraform -chdir=x destroy")
if echo "$CMD" | grep -qiE "terraform[[:space:]].*\bdestroy\b|terraform[[:space:]].*apply.*-auto-approve|aws[[:space:]]+s3[[:space:]]+(rm|rb)\b|aws[[:space:]]+s3api[[:space:]]+delete-bucket|aws[[:space:]]+cloudfront[[:space:]]+delete-distribution"; then
  echo '{"decision": "block", "reason": "Destructive command blocked by pre-tool-guard. Use /tf-plan and /tf-apply (saved plan) for infrastructure changes."}'
fi
exit 0
