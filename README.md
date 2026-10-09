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
- O `Dockerfile` usa `kong:3.9.3`, copia o arquivo e escuta em `$PORT`, que o Render define.
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

## Produção

Os valores do Helm estão em `helm/` (`values-base.yaml`, `values-dev.yaml` e `values-prod.yaml`), lidos pelo Terraform do `infra-platform`. O Kong de produção também é DB-less e roteia por host (`<serviço>.solarianetwork.site`), a partir dos `Ingress` do `infra-gitops`.
