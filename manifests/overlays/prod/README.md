# manifests/overlays/dev/

Ambiente de produção

## Arquivos

- **`kustomization.yaml`** -> lista todos os arquivos que devem ser aplicados
- **`namespace.yaml`** -> cria o namespace solier-dev onde tudo desse ambiente vive no cluster
- **`patch-rate-limiting-auth-redis.yaml`** e **`patch-rate-limiting-persistence-redis.yaml`** -> complementam os plugins de rate-limit

## Como funciona a credencial da Upstash

**Este repositório não contém nenhum `Secret`** o redis de rate-limiting só referencia o nome `upstash-redis-credentials` 
-> **o `Secret` em si precisa já existir no cluster antes de aplicar**
 
**Crie com:**
``kubectl create secret generic upstash-redis-credentials --from-literal=password=<valor-real> -n solier-prod``

