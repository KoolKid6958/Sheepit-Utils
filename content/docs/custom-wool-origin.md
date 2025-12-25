+++
title = "Custom Wool Origin"
layout = "hextra-docs"
+++

What is `--wool-origin` and how you can use it.

The point of this flag is to specify a proxy cache for sheepit downloads, so if you have more than one client on the same network you don't need to download the same file multiple times from the internet.

## Setup

> [!NOTE]
> These config files are not perfect and will benefit from optimization later down the line.

### Nginx

An example nginx config would be:

```nginx.conf
worker_processes auto;

events {
    worker_connections  1024;
}

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

            proxy_ignore_headers Cache-Control Expires Set-Cookie;
        }
    }
}
```

### Docker compose

If you want to have this in a docker container, you can use this compose file:

```docker-compose.yml
services:
  web:
    image: nginx
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
      - ./docker/cache:/var/cache/nginx/sheepit
    ports:
    - "8080:80"
```

Now, to use it on sheepit you can append `--wool-origin http://sheepit-mirror.example.com` to the sheepit client start flags.
