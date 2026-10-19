---
name: tf-apply
description: Apply a reviewed Terraform plan to create or update AWS infrastructure. Use after /tf-plan.
allowed-tools: Bash, Read
disable-model-invocation: true
---

Apply a saved plan instead of `-auto-approve`, so only the reviewed plan is applied (the PreToolUse hook blocks `terraform apply -auto-approve`). Run all commands from the project root.

1. Run `cd terraform && terraform plan -out=apply.tfplan -no-color` and summarize how many resources will be added, changed and destroyed. If anything will be destroyed or replaced, stop and ask before applying.
2. Run `cd terraform && terraform apply -no-color apply.tfplan`.
3. Run `rm terraform/apply.tfplan` (a saved plan can contain sensitive values).

After apply completes:
- [ ] Show the outputs (CloudFront URL, S3 bucket, distribution ID, GitHub Actions role ARN)
- [ ] Check that the CloudFront distribution status is "Deployed"
- [ ] Report any errors and suggest fixes

If apply fails, do NOT retry automatically. Show the error and wait for instructions.
