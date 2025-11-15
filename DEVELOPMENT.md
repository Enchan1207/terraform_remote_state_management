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
