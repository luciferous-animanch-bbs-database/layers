# ================================================================
# Terraform Config
# ================================================================

terraform {
  required_version = "~> 1.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.38.0"
    }
  }

  backend "s3" {
    region         = "ap-northeast-1"
    bucket         = "prepare-bucketterraformstates-p3c1oilnsc6q"
    key            = "layers/tfstate.json"
    dynamodb_table = "prepare-TableTerraformLocks-67NUO49JYVQH"
  }
}

# ================================================================
# Provider Config
# ================================================================

provider "aws" {
  region = local.region

  default_tags {
    tags = {
      SystemName = local.system_name
    }
  }
}

# ================================================================
# Artifacts Bucket
# ================================================================

locals {
  region      = "ap-northeast-1"
  system_name = "luciferous-animanch-bbs-database-layers"
}

# ================================================================
# Artifacts Bucket
# ================================================================

resource "aws_s3_bucket" "artifacts" {
  bucket_prefix = "artifacts-layers-"
}

# ================================================================
# Modules
# ================================================================

module "base" {
  source = "./modules/layer"

  source_directory = "layers/base"
  parameter_name   = "LayerArnBase"

  s3_bucket     = aws_s3_bucket.artifacts.bucket
  s3_key_prefix = "layers"
}

# ================================================================
# Outputs
# ================================================================

output "base_layer_arn" {
  value = module.base.layer_arn
}
