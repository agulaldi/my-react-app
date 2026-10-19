---
name: deploy
description: Build the React app and publish build/ to S3, then invalidate CloudFront. Use for a manual deploy from this machine.
allowed-tools: Bash, Read
disable-model-invocation: true
---

Build and deploy the React app. Run all commands from the project root. Upload only `build/`, never the repository root.

Steps:
- [ ] Build: `npm ci && CI=true npm test -- --watchAll=false && npm run build`
- [ ] Get outputs: `cd terraform && terraform output -json` (bucket name and distribution ID)
- [ ] Hashed assets, cached for a year: `aws s3 sync build/static s3://<bucket>/static --delete --cache-control "public,max-age=31536000,immutable"`
- [ ] Everything else, never cached by browsers: `aws s3 sync build s3://<bucket> --delete --exclude "static/*" --cache-control "no-cache"`
- [ ] Invalidate: `aws cloudfront create-invalidation --distribution-id <dist-id> --paths "/*"`
- [ ] Report the CloudFront URL and the invalidation status

If any step fails, stop and report the error. Do not continue to the next step.
