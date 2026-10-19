variable "region" {
  description = "AWS region for all resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name, used as a prefix for resource names"
  type        = string
  default     = "agulaldi-react-app"
}

variable "environment" {
  description = "Deployment environment name"
  type        = string
  default     = "production"
}

variable "github_repository" {
  description = "GitHub repository allowed to deploy, in owner/repo format"
  type        = string
  default     = "agulaldi/my-react-app"
}

variable "github_owner_id" {
  description = "Numeric GitHub ID of the repository owner (used in the immutable OIDC subject)"
  type        = number
  default     = 129971097
}

variable "github_repository_id" {
  description = "Numeric GitHub ID of the repository (used in the immutable OIDC subject)"
  type        = number
  default     = 1425706587
}
