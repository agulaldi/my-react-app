---
name: setup-gh-actions
description: Create or validate the GitHub Actions workflow that tests, builds and deploys the React app to S3 + CloudFront with OIDC
argument-hint: "[create|validate]"
allowed-tools: Bash, Read, Write, Edit, Grep, Glob
disable-model-invocation: true
---

Manage `.github/workflows/deploy.yml`.

Get the values from `cd terraform && terraform output -json`: role ARN, bucket name, distribution ID. Region is `us-east-1`.

If $ARGUMENTS contains "create":
- Delete the old Docker workflow `.github/workflows/ci-cd.yml` (it needs Docker Hub secrets this fork does not have).
- Write `.github/workflows/deploy.yml`:
  - Trigger: push to `main`. `permissions: id-token: write, contents: read`. A `concurrency` group so two deploys never overlap.
  - `env` with the region, role ARN, bucket and distribution ID from the Terraform outputs (no GitHub secrets needed).
  - Steps: checkout → `actions/setup-node` (Node 20, npm cache) → `npm ci` → `CI=true npm test -- --watchAll=false` → `npm run build` → `aws-actions/configure-aws-credentials` (OIDC) → sync `build/static` with a one-year immutable cache → sync `build/` (excluding `static/*`) with `no-cache` → CloudFront invalidation `/*`.
  - Every `aws s3 sync` uses `--delete` and syncs `build/`, never the repository root.

If $ARGUMENTS contains "validate" (or is empty), check without editing:
1. The file exists and is valid YAML
2. OIDC: role ARN and region match the Terraform outputs; `id-token: write` is set
3. The build runs before the sync, and only `build/` is synced
4. Bucket name and distribution ID match the Terraform outputs
5. Trigger is push to `main`

Report the issues found and suggest fixes.
