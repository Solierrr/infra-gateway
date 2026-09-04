# Rodando o Projeto Localmente

Este repositório é um Helm chart de configuração (infraestrutura) — não tem código de aplicação nem "servidor de desenvolvimento". Testar uma mudança aqui significa renderizar os `values` deste repositório contra o chart oficial `kong/kong` com `helm template` e revisar o manifesto resultante antes do merge em `main`. Não é necessário instalar nada no cluster para validar uma alteração — o `helm template` roda inteiramente local.

<p>
  <a href="https://github.com/syvixor/skills-icons">
    <img src="https://skills.syvixor.com/api/icons?i=kubernetes,kong,github" height="48" alt="Rodando o Projeto — Kong via Helm">
  </a>
</p>

## Possíveis Impedimentos

- **Helm CLI instalado**, necessário para renderizar (`helm template`) e, se aplicável, instalar (`helm install`/`helm upgrade`) o chart.
- **Repositório do chart `kong/kong` adicionado ao Helm**, este repositório não define um chart próprio, ele só fornece `values`; é preciso ter o repo oficial da Kong registrado localmente (`helm repo add kong https://charts.konghq.com` seguido de `helm repo update`).
- **Acesso ao cluster GKE para aplicar de fato**, renderizar o chart localmente não exige cluster, mas testar o efeito real (`helm upgrade --install`) exige `kubectl`/`helm` apontando para um cluster ativo.
- **Múltiplos arquivos de values (`values-base.yaml`, `values-dev.yaml`, `values-prod.yaml`)**, sempre combine o `values-base.yaml` com o arquivo do ambiente correspondente — usar só o base sem o overlay de ambiente gera uma configuração incompleta.

## Instalação do Projeto

### Iniciando o repositório com o Github

<p>
  <a href="https://github.com/syvixor/skills-icons">
    <img src="https://skills.syvixor.com/api/icons?i=github,vscode" height="48" alt="Frameworks">
  </a>
</p>

Clone o repositório e abra no VS Code (com a extensão YAML para validação de schema).

```Comandos para clonar o repositório
git clone https://github.com/Solierrr/infra-gateway.git
cd ./infra-gateway
code . -r
```

### Renderizando e validando o chart

<p>
  <a href="https://github.com/syvixor/skills-icons">
    <img src="https://skills.syvixor.com/api/icons?i=kubernetes,kong" height="48" alt="Frameworks">
  </a>
</p>

`helm template` renderiza o manifesto final combinando o chart oficial `kong/kong` com os `values` deste repositório, sem tocar no cluster — revise a saída antes de aplicar de verdade. Para dev, combine o base com o overlay de dev; para prod, combine o base com o overlay de prod.

```Comandos para renderizar e validar — ambiente dev
helm repo add kong https://charts.konghq.com
helm repo update
helm template kong kong/kong -n kong -f helm/values-base.yaml -f helm/values-dev.yaml
```

```Comandos para renderizar e validar — ambiente prod
helm template kong kong/kong -n kong -f helm/values-base.yaml -f helm/values-prod.yaml
```

### Instalando de fato no cluster

<p>
  <a href="https://github.com/syvixor/skills-icons">
    <img src="https://skills.syvixor.com/api/icons?i=kubernetes,gcp" height="48" alt="Frameworks">
  </a>
</p>

Com `kubectl` apontando para o cluster correto, o comando abaixo instala (ou atualiza) o release do Kong no namespace `kong`, criando-o caso não exista.

```Comando de instalação/upgrade
helm upgrade --install kong kong/kong -n kong --create-namespace -f helm/values-base.yaml -f helm/values-dev.yaml
```

### Acessando o gateway localmente (dev)

Como `proxy.type` em dev é `ClusterIP`, o proxy do Kong não é acessível diretamente de fora do cluster. Para testar localmente, abra um túnel temporário com `port-forward`, válido apenas enquanto o comando estiver rodando:

```Comando de port-forward
kubectl -n solier-dev port-forward svc/kong-gateway-proxy 8000:80
```
