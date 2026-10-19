# Terraform Template Specification (React SPA on S3 + CloudFront)

Generate these files in the `terraform/` directory.

**terraform/providers.tf**
- `terraform` block: `required_version >= 1.5`, provider `hashicorp/aws` pinned with `~> 5.0`
- AWS provider using `var.region`, with `default_tags` for `Project` and `Environment`

**terraform/variables.tf** (every variable has `description` and `type`)
- `region` (default from $0 or `us-east-1`)
- `project_name` (default from $1 or `agulaldi-react-app`)
- `environment` (default `production`)
- `github_repository` (default `agulaldi/my-react-app`)
- `github_owner_id` (number, default `129971097`)
- `github_repository_id` (number, default `1425706587`)

**terraform/main.tf**
- `data "aws_caller_identity"`; bucket name = `"${var.project_name}-${account_id}"` (globally unique)
- S3 bucket, private: `aws_s3_bucket_ownership_controls` (BucketOwnerEnforced), `aws_s3_bucket_public_access_block` (all four `true`), `aws_s3_bucket_server_side_encryption_configuration` (AES256), `aws_s3_bucket_versioning` (Enabled) and an `aws_s3_bucket_lifecycle_configuration` that expires noncurrent versions after 30 days
- Bucket policy: only `cloudfront.amazonaws.com` may `s3:GetObject`, with condition `AWS:SourceArn` = this distribution's ARN; add a statement that denies all `s3:*` when `aws:SecureTransport` is `false`
- `aws_cloudfront_origin_access_control` (OAC, sigv4, always sign) — NOT legacy OAI
- CloudFront distribution:
  - S3 origin via OAC, `default_root_object = "index.html"`, IPv6 enabled
  - `viewer_protocol_policy = "redirect-to-https"`, GET/HEAD only, compression on
  - managed cache policy `Managed-CachingOptimized` and managed response headers policy `Managed-SecurityHeadersPolicy` (both via `data` sources)
  - `custom_error_response` for 403 AND 404 → `/index.html` with response code 200 (SPA routing; a private bucket returns 403 for missing keys)
  - `price_class = "PriceClass_100"`
  - default CloudFront certificate
- All resources tagged through provider `default_tags`

**terraform/github-oidc.tf**
- The GitHub OIDC provider ALREADY EXISTS in this account. Read it with `data "aws_iam_openid_connect_provider"` (url `https://token.actions.githubusercontent.com`). Do NOT create a new provider.
- `locals`: subject prefix in GitHub's immutable format: `repo:<owner>@<github_owner_id>/<repo>@<github_repository_id>` (split `var.github_repository` on `/`)
- IAM role `"${var.project_name}-github-actions-deploy"`; trust policy: `sts:AssumeRoleWithWebIdentity` from the OIDC provider, `StringEquals` on `token.actions.githubusercontent.com:aud = sts.amazonaws.com` and `token.actions.githubusercontent.com:sub = "<prefix>:ref:refs/heads/main"`
- Inline policy (least privilege, no wildcards in actions): `s3:ListBucket` on the bucket; `s3:PutObject`, `s3:GetObject`, `s3:DeleteObject` on `bucket/*`; `cloudfront:CreateInvalidation` on this distribution only

**terraform/outputs.tf**
- `s3_bucket_name`, `s3_bucket_arn`, `cloudfront_distribution_id`, `cloudfront_domain_name`, `cloudfront_url` (`https://<domain>`), `github_actions_role_arn`

**terraform/backend.tf**
- S3 backend block commented out, with comments explaining: run `terraform init` with local state first, create a state bucket + lock table later, then uncomment and run `terraform init -migrate-state`

**terraform/.gitignore**
- `.terraform/`, `*.tfstate`, `*.tfstate.*`, `*.tfplan`, `crash.log`, `*.tfvars`, `override.tf*`; keep `.terraform.lock.hcl` tracked
