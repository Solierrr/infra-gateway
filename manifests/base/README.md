# manifests/base/

configs padrões idênticas pra qualquer ambiente(dev/prod)
sempre combinada com as configs em /overlay na hora de usar
nome de ambiente, credenciais, senhas, env de BD ficam em /overlay e nunca devem estar aqui

## Arquivos

- **`kustomization.yaml`** -> lista todos os arquivos que devem ser aplicados
- **`ingress-auth.yaml`** -> rota para api-auth -> `/auth/**`
- **`ingress-persistence.yaml`** -> rota para api-persistence -> `/api/**`
- **`ingress-messenger.yaml`** -> rota para api-messenger. -> `/messaging/**`
- **`plugin-cors.yaml`** -> regra de quais sites podem chamar o gateway pelo navegador
- **`plugin-rate-limiting-auth.yaml`** -> regra de limite de request em `/auth/**`
- **`plugin-rate-limiting-persistence.yaml`** — limite de request em `/api/**` e reaproveitado em `/messaging/**`
