# Remote state backend (disabled for now).
#
# 1. Start with local state: run `terraform init` with this block commented out.
# 2. Later, create a dedicated S3 bucket for state (versioned, encrypted, private)
#    and a DynamoDB table for locking (partition key `LockID`, type String).
# 3. Uncomment the block below, fill in the names, and run
#    `terraform init -migrate-state` to move the local state into S3.
#
# terraform {
#   backend "s3" {
#     bucket         = "agulaldi-react-app-tfstate-373550664081"
#     key            = "my-react-app/terraform.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "agulaldi-react-app-tf-lock"
#     encrypt        = true
#   }
# }
