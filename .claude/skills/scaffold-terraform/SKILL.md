---
name: scaffold-terraform
description: Generate the Terraform for hosting this React app on S3 + CloudFront, plus the GitHub OIDC deploy role. Use when setting up the project or regenerating infrastructure files.
allowed-tools: Bash, Read, Write, Grep, Glob
disable-model-invocation: true
argument-hint: "[aws-region] [project-name]"
---

Generate the Terraform configuration for this React single-page app.

Use $ARGUMENTS for overrides:
- $0 = AWS region (default: us-east-1)
- $1 = Project name (default: agulaldi-react-app)

## What to Generate

Read `template-spec.md` in this skill folder for the full specification and generate every file it lists in the `terraform/` directory. Do not create anything outside `terraform/`.

## After Generation

- [ ] Run `cd terraform && terraform fmt && terraform init -input=false && terraform validate -no-color`
- [ ] List all files created and the resources that will be provisioned
- [ ] Remind the engineer to review the files and run `/tf-plan` when ready
