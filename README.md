NGINX LUA PUSH STREAM Dockerfile
================================

This Dockerfile installs NGINX configured with `nginx-push-stream-module`,
`lua-resty-redis` and `lua-nginx-module`.

How to use
-----------

1. Build container
    `docker build -t lucasmundim/nginx-lua-push-stream .`

2. Run it
    `docker run -p 8443:443 -p 8080:80 --rm -it lucasmundim/nginx-lua-push-stream`


Links
-----

* http://nginx.org/
* https://github.com/wandenberg/nginx-push-stream-module
* https://github.com/openresty/lua-nginx-module
* https://github.com/openresty/lua-resty-redis
