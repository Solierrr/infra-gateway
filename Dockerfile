FROM kong:3.9.3

ENV KONG_DATABASE=off \
    KONG_DECLARATIVE_CONFIG=/etc/kong/kong.yml \
    KONG_ADMIN_LISTEN=off \
    KONG_PROXY_ACCESS_LOG=/dev/stdout \
    KONG_PROXY_ERROR_LOG=/dev/stderr \
    KONG_NGINX_WORKER_PROCESSES=1 \
    KONG_MEM_CACHE_SIZE=32m

COPY kong/kong.qa.yml /etc/kong/kong.yml
COPY --chmod=755 docker-cmd.sh /usr/local/bin/docker-cmd.sh

EXPOSE 8000 10000

CMD ["/usr/local/bin/docker-cmd.sh"]
