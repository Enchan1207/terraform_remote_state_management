# development memo

## 適当なWorkerスクリプトを作る

```sh
pnpm add -D wrangler
```

`src/index.js` に関数 `fetch` を実装・exportしておく

```js
export default {
    async fetch() {
        return Response.json({
            message: "Hello, Cloudflare Workers!"
        })
    }
}
```

動作確認

```sh
pnpm dev
curl localhost:8787
```

```json
{"message":"Hello, Cloudflare Workers!"}
```

## R2バケットを作成する

Cloudflareのアカウントを作成し、R2バケットを作成 ここでは _terraform-remote-state_ とした

![create_bucket](./resources/create_bucket.png)

## Workersプロジェクトを作成する

Workersプロジェクトの生成処理をHCLで記述する

```hcl
terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.12.0"
    }
  }
}

variable "cloudflare_api_token" {
  type = string
}

variable "cloudflare_account_id" {
  type = string
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
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
```

変数 `cloudflare_api_token`, `cloudflare_account_id` は別途ファイル `terraform.tfvars` を作成し、そちらに書いておく
(最低限Workersの編集ができる程度の権限をつけたAPIトークンを作成しておく。詳細は割愛する)

```sh
terraform init
```

問題なく初期化されたら適用してみる

```sh
terraform apply
```

空のWorkersプロジェクトが作成された

![created_empty_worker](./resources/created_empty_worker.png)
