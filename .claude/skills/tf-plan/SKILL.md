---
name: tf-plan
description: Run terraform plan and analyze the output for risks. Use before applying any infrastructure changes.
allowed-tools: Bash, Read, Grep
disable-model-invocation: true
---

Run `cd terraform && terraform plan -no-color` from the project root and analyze the output.

Summarize:
- [ ] How many resources will be added, changed, or destroyed
- [ ] Any risks: resource replacements, deletions, IAM or trust-policy changes, anything that could take the site offline
- [ ] Estimated blast radius

If the plan fails, diagnose the error and suggest a fix. Never run apply from this skill.
