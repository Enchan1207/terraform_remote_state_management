terraform {
  backend "s3" {
    bucket = "terraform-remote-state"
    key    = "terraform_remote_state_management/terraform.tfstate"
    region = "auto"

    // R2のための設定
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
    use_path_style              = true
  }

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.12.0"
    }
  }
}

variable "cloudflare_account_id" {
  type = string
}

provider "cloudflare" {
  // APIトークンには環境変数 CLOUDFLARE_API_TOKEN の値を使用
}

resource "cloudflare_worker" "worker" {
  account_id = var.cloudflare_account_id
  name       = "terraform_remote_state_management"
  observability = {
    enabled = true
  }
  subdomain = {
    enabled          = true
    previews_enabled = false
  }
}
