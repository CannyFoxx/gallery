# Gallery on Rails: Setup ->

## Ruby version
* 2.4.1

## System dependencies
* RVM
* ImageMagick
* Postgresql
* Redis
* Nginx

## Configuration
1. Create `.bashrc` file in **nginx**'s home folder where save next variables (You can generate random value with command `rake secret`):
```
[[ -s /usr/local/rvm/scripts/rvm ]] && source /usr/local/rvm/scripts/rvm

```

2. Create `.profile` file in **nginx**'s user home folder and put this code:
```
if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
    fi
fi
```

3. Copy `config/secrets.yml.example` to `config/secrets.yml` and put new secret phrase:
```
production:
  secret_key_base: HARD_PASSWORD
```


## Database creation
Before next step make copy file `database.yml.example` to `database.yml` and write your settings.
Execute `sudo -u postgres psql` and enter next commands:
```
CREATE ROLE gallery WITH PASSWORD 'your_strong_password';
CREATE DATABASE gallery TEMPLATE template0 ENCODING 'UNICODE';
ALTER DATABASE gallery OWNER TO gallery;
GRANT ALL PRIVILEGES ON DATABASE gallery TO gallery;
ALTER ROLE gallery WITH LOGIN;
\connect gallery
CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;
```

## Config for nginx
```
server {
    server_name server.com;
    listen 80;
    listen [::]:80;

    return 301 https://$host$request_uri;
}

server {
    server_name server.com;
    listen 443 ssl http2;
    listen [::]:443 ssl http2;

    ssl_certificate /etc/letsencrypt/live/server.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/server.com/privkey.pem;
    ssl_session_timeout 1d;
    ssl_session_cache shared:SSL:50m;
    ssl_session_tickets off;

    ssl_protocols TLSv1.2;
    ssl_ciphers 'ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256';
    ssl_prefer_server_ciphers on;

    add_header Strict-Transport-Security max-age=15768000;
    add_header X-Content-Type-Options nosniff;
    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-XSS-Protection "1; mode=block";
    add_header X-Robots-Tag none;
    add_header X-Download-Options noopen;
    add_header X-Permitted-Cross-Domain-Policies none;

    ssl_stapling on;
    ssl_stapling_verify on;
    ssl_trusted_certificate /etc/letsencrypt/live/server.com/chain.pem;
    resolver 8.8.8.8;

    root /var/www/gallery/public;

    location = /robots.txt {
        allow all;
        log_not_found off;
        access_log off;
    }

    location ~* \.(?:png|ico|jpg|jpeg|ttf|svg|eot|woff|woff2)$ {
        try_files $uri /index.php$uri$is_args$args;
        access_log off;
    }

    client_max_body_size 512M;

    passenger_enabled on;
}
```

## Deployment instructions
Edit deployment config (config/deploy.rb) and execute command:
```
cap production deploy
```

## Creating admin
On production server enter in directory with current version of application (e.g. /www/server.com/current) under user `nginx` and execute next commands:
```
RAILS_ENV=production rails console
#then console initialized:
Admin.new(email: 'someemail@server.com', password: 'MakeH@rdpasswd').save
exit
```