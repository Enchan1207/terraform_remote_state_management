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

variable "worker_name" {
  type    = string
  default = "terraform_remote_state_management"
}

variable "worker_domain" {
  type    = string
  default = "terraform_remote_state_management.enchan.me"
}

variable "cloudflare_zone_id" {
  type = string
}

provider "cloudflare" {
  // APIトークンには環境変数 CLOUDFLARE_API_TOKEN の値を使用
}

resource "cloudflare_worker" "worker" {
  account_id = var.cloudflare_account_id
  name       = var.worker_name
  observability = {
    enabled = true
  }
  subdomain = {
    enabled          = false
    previews_enabled = false
  }
}

resource "cloudflare_workers_custom_domain" "custom_domain" {
  account_id  = var.cloudflare_account_id
  environment = "production"
  hostname    = var.worker_domain
  service     = var.worker_name
  zone_id     = var.cloudflare_zone_id
  depends_on  = [cloudflare_worker.worker]
}
