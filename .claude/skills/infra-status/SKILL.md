---
name: infra-status
description: Check the current infrastructure and site health and present a status dashboard
allowed-tools: Bash, Read, Grep
disable-model-invocation: true
---

Check the current infrastructure status and present a pass/fail table:
1. Terraform state: `cd terraform && terraform state list`
2. S3: `aws s3 ls s3://<bucket>` — `index.html` and `static/` exist (bucket from `terraform output`)
3. CloudFront: `aws cloudfront get-distribution --id <dist-id> --query "Distribution.Status"` — must be "Deployed"
4. Site: `curl -sI <cloudfront_url>` returns HTTP 200; a random path such as `/some/route` also returns 200 (SPA fallback)
