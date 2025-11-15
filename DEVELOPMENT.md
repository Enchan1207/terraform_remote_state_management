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
