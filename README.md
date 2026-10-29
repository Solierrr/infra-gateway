# infra-gateway

Configuração do gateway Kong da Solaria, em dois ambientes.

| Ambiente | Onde roda | Arquivos |
|---|---|---|
| Produção | Kong como ingress do cluster GKE, instalado pelo `infra-platform` com o Helm chart `kong/ingress` | `helm/` |
| QA | Kong em modo DB-less, como Web Service Docker no Render | `Dockerfile`, `kong/kong.qa.yml` |

## QA

O QA não tem cluster: cada serviço roda no Render com a própria URL pública. O Kong de QA dá um ponto de entrada único, no mesmo formato de produção, com roteamento por caminho:

```text
https://<url do gateway no Render>/api-core/...        ->  https://api-core-cqfn.onrender.com/...
https://<url do gateway no Render>/api-auth/...        ->  https://api-auth-xw6o.onrender.com/...
```

- `kong/kong.qa.yml` é a configuração declarativa: um serviço e uma rota por API de QA (`/<nome do serviço>`, com o prefixo removido antes de chegar ao serviço), a rota `/health` do próprio gateway e o plugin `correlation-id` (cabeçalho `X-Request-Id`).
- O modo DB-less não usa banco: o Kong lê o arquivo na subida e não tem Admin API (`KONG_ADMIN_LISTEN=off`). Para mudar uma rota, edite o arquivo; o Render refaz o deploy.
- O `Dockerfile` usa `kong:3.9.3`, copia o arquivo e o `docker-cmd.sh` faz o Kong escutar na porta 8000 e em `$PORT` (10000 por padrão, a porta que o Render usa).
- O serviço dorme no free tier após alguns minutos sem tráfego. O primeiro acesso pode levar cerca de 30 segundos.

Para testar localmente:

```bash
docker build -t kong-qa .
docker run --rm -p 8000:8000 kong-qa
curl localhost:8000/health
curl localhost:8000/api-recommendation/health/live
```

Para validar a configuração sem subir o Kong:

```bash
docker run --rm -v "$PWD/kong:/kong" -e KONG_DATABASE=off kong:3.9.3 kong config parse /kong/kong.qa.yml
```

Ao criar um serviço novo no Render, acrescente o par `services` e `routes` correspondente em `kong/kong.qa.yml`.

Além das rotas, o arquivo traz o básico para o navegador e o WebSocket:

- `api-notify` tem rota própria (`/api-notify`). O `api-email` não tem: é um serviço interno, chamado só pelos backends, e não deve sair pelo gateway público.
- O plugin global `cors` libera as origens do web-app de QA (`web-app-ldi0.onrender.com`, `qa.solarianetwork.site`, `web-sandbox-qa.onrender.com`) e as locais, com os métodos e cabeçalhos comuns, sem credenciais. Origem nova do front precisa entrar na lista `origins`.
- O `api-messenger` tem `read_timeout` e `write_timeout` de 5 minutos e `connect_timeout` de 10 segundos. O Kong repassa o `Upgrade` do WebSocket em rotas HTTP; o cliente STOMP manda heartbeat a cada 10 segundos, bem abaixo do limite de 60 segundos do padrão.


## Produção

Os valores do Helm estão em `helm/` (`values-base.yaml`, `values-dev.yaml` e `values-prod.yaml`), lidos pelo Terraform do `infra-platform`. O Kong de produção também é DB-less e roteia por host (`<serviço>.solarianetwork.site`), a partir dos `Ingress` do `infra-gitops`.

O WebSocket do `api-messenger` em produção passa pelo mesmo `Ingress` (`/ws`, e `/messaging/ws` por causa do Kong) e os timeouts ficam em anotações `konghq.com/*-timeout` no `Service` do `infra-gitops`. O CORS em produção continua em cada serviço (`CORS_ALLOWED_ORIGINS`), sem plugin no gateway.

## Pendências para revisão do responsável

Fora do básico que faz o gateway funcionar sem intervenção, estes ajustes ficam para revisão:

- Rate limit (`rate-limiting`) por rota e por consumidor, em QA e em produção, principalmente em `/auth` e nos endpoints de IA.
- WAF ou regras de bloqueio (por exemplo `ip-restriction` e `request-size-limiting`) e limite de tamanho dos uploads.
- Decidir se o CORS passa a ser feito só no gateway (um `KongClusterPlugin` global em produção) e sai dos serviços; hoje o gateway de QA e os serviços respondem os dois.
- Autenticação no próprio gateway (por exemplo `jwt` ou `openid-connect`) em vez de cada serviço validar o token.
- TLS dos `Ingress` da API: só o `web-app` pede certificado ao cert-manager; os hosts `api-*.solarianetwork.site` respondem com o certificado padrão do Kong.
- Política de logs de acesso, métricas (`prometheus`) e tracing (`opentelemetry`) no Kong.

