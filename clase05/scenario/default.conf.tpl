server {
    listen       80;
    server_name  localhost;
    location / {
        proxy_pass   http://${IP_BACKEND}:80;
    }

}
