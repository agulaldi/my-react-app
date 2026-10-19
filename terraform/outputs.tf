output "s3_bucket_name" {
  description = "Name of the S3 bucket holding the React build"
  value       = aws_s3_bucket.site.id
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket holding the React build"
  value       = aws_s3_bucket.site.arn
}

output "cloudfront_distribution_id" {
  description = "ID of the CloudFront distribution (used for invalidations)"
  value       = aws_cloudfront_distribution.site.id
}

output "cloudfront_domain_name" {
  description = "Domain name of the CloudFront distribution"
  value       = aws_cloudfront_distribution.site.domain_name
}

output "cloudfront_url" {
  description = "Public HTTPS URL of the site"
  value       = "https://${aws_cloudfront_distribution.site.domain_name}"
}

output "github_actions_role_arn" {
  description = "ARN of the IAM role GitHub Actions assumes via OIDC"
  value       = aws_iam_role.github_actions_deploy.arn
}
