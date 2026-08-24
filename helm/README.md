# helm/

arquivos de instalção do kong
lidos pelo Helm com o comando -> `helm upgrade --install kong kong/ingress -n kong --create-namespace \`

## Arquivos

- **`values-base.yaml`** — configs padrões para dev e prod
- **`values-dev.yaml`** — ajustes para rodar local
- **`values-prod.yaml`** — ajustes para rodar em prod

