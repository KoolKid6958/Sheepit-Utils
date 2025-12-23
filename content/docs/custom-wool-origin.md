+++
title = ""
layout = "hextra-docs"
+++

## What is `--wool-origin` and how you can use it.

The point of this arg is to specify a proxy cache for sheepit downloads, so if you have more than one client on the same network you don't need to download the same file multiple times from Cloudflare.

An example nginx config would be:

> [!NOTE]
> This Config file is not perfect and will benefit from optimization later down the line.

```
http {
    proxy_cache_path /var/cache/nginx/sheepit keys_zone=sheepit_cache:10m levels=1:2 inactive=24h max_size=40G;

    server {
        listen 80;
        server_name sheepit-mirror.example.com;

        location / {
            proxy_cache_lock on;
            proxy_cache_lock_timeout 30s;
            proxy_cache_lock_age 5m;
	        proxy_ssl_server_name on;
	        proxy_ssl_name sheepit-main-weur-projects.sheepit-r2-binaries.win;

            proxy_cache sheepit_cache;

            proxy_cache_valid 200 302 720h;
            proxy_cache_valid 404 1m;

	        add_header X-Proxy-Cache $upstream_cache_status always;
            proxy_pass https://sheepit-main-weur-projects.sheepit-r2-binaries.win;

            proxy_cache_bypass $http_cache_control;
            proxy_ignore_headers Cache-Control Expires Set-Cookie;
        }
    }
}
```

With the provided config file you can append `--wool-origin http://sheepit-mirror.example.com` to the sheepit client start flags.
