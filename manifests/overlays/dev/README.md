# manifests/overlays/dev/

Ambiente de desenvolvimento local

## Arquivos

- **`kustomization.yaml`** -> lista todos os arquivos que devem ser aplicados
- **`namespace.yaml`** -> cria o namespace solier-dev onde tudo desse ambiente vive no cluster
- **`patch-rate-limiting-auth-redis.yaml`** e **`patch-rate-limiting-persistence-redis.yaml`** -> complementam os plugins de rate-limit
