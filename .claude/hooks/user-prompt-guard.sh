#!/bin/bash
# SAY hook (UserPromptSubmit): catches destructive intent in user prompts before Claude sees them

INPUT=$(cat)
PROMPT=$(echo "$INPUT" | jq -r '.prompt // empty')

if echo "$PROMPT" | grep -iqE "delete (all|every)|destroy (all|everything)|(remove|clear|wipe) all|tear ?down (all|everything|the (stack|infra))|\bnuke\b|\bwipe\b|drop all"; then
  echo '{"decision": "block", "reason": "Destructive intent detected. Infrastructure teardown is not automated in this project; plan it explicitly with Terraform and review it first."}'
fi
exit 0
