#!/bin/bash
# LOG hook (PostToolUse, Bash): records every terraform apply and S3 deploy to .claude/deploy.log

INPUT=$(cat)
CMD=$(echo "$INPUT" | jq -r '.tool_input.command // empty')
LOG="${CLAUDE_PROJECT_DIR:-.}/.claude/deploy.log"

if echo "$CMD" | grep -qE "terraform([[:space:]]+-chdir=[^[:space:]]+)?[[:space:]]+apply([[:space:]]|$)|aws[[:space:]]+s3[[:space:]]+sync|create-invalidation"; then
  echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] $(echo "$CMD" | tr '\n' ' ' | cut -c1-200)" >> "$LOG"
fi
exit 0
