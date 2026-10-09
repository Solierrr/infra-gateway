FROM kong:3.9.3

ENV KONG_DATABASE=off \
    KONG_DECLARATIVE_CONFIG=/etc/kong/kong.yml \
    KONG_ADMIN_LISTEN=off \
    KONG_PROXY_ACCESS_LOG=/dev/stdout \
    KONG_PROXY_ERROR_LOG=/dev/stderr

COPY kong/kong.qa.yml /etc/kong/kong.yml

EXPOSE 8000

CMD ["sh", "-c", "KONG_PROXY_LISTEN=\"0.0.0.0:${PORT:-8000}\" exec /docker-entrypoint.sh kong docker-start"]
