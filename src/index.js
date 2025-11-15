export default {
    async fetch() {
        return Response.json({
            message: "Hello, Cloudflare Workers!"
        })
    }
}
