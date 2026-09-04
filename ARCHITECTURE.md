# Arquitetura do Repositório

Este repositório não segue a arquitetura de uma aplicação — ele é um conjunto de arquivos de configuração (`values.yaml`) consumidos pelo chart Helm oficial `kong/kong` para instalar e configurar o Kong Gateway no cluster Kubernetes. A ideia central é a separação entre configuração base e configuração por ambiente: `values-base.yaml` define tudo que é comum a dev e prod (versão da imagem, modo de operação do Kong, portas do proxy e da Admin API, ativação do Ingress Controller), enquanto `values-dev.yaml` e `values-prod.yaml` sobrescrevem apenas o que muda entre os dois ambientes (réplicas, recursos de CPU/memória e o tipo de exposição do proxy). O Helm combina os dois arquivos no momento da instalação (`-f values-base.yaml -f values-dev.yaml`), então nenhum dos dois arquivos de ambiente é usado sozinho. Além dos arquivos do chart, o repositório carrega arquivos de scaffold que não têm relação com essa finalidade — ponto detalhado na seção de observações abaixo.

<p>
  <a href="https://github.com/syvixor/skills-icons">
    <img src="https://skills.syvixor.com/api/icons?i=kubernetes,kong,helm,gcp" height="48" alt="Arquitetura — Kong via Helm">
  </a>
</p>

- **Chart oficial `kong/kong`**, o repositório não define um chart próprio — ele só fornece arquivos `values` que são passados para o chart mantido pela Kong Inc. As chaves em `values-base.yaml` (`image`, `env`, `proxy`, `admin`, `ingressController`) ficam soltas na raiz do arquivo porque o schema desse chart não usa prefixos como `gateway`/`controller`.
- **Kong sem banco de dados (`env.database: off`)**, o Kong roda no modo `role: traditional` (processa requisições e gerencia sua própria configuração) mantendo tudo em memória, carregado a partir dos arquivos deste repositório a cada deploy — decisão adequada para um cluster efêmero, onde não faz sentido manter um banco de dados persistente só para armazenar configuração do gateway.
- **Exposição do proxy varia por ambiente**, em `values-base.yaml` o padrão é `proxy.type: ClusterIP` (só acessível dentro da rede interna do cluster), usado em dev; `values-prod.yaml` sobrescreve para `proxy.type: LoadBalancer`, fazendo a GCP provisionar um endereço acessível pela internet — em dev, o acesso local é feito via `kubectl port-forward` (documentado como comentário em `values-dev.yaml`).
- **Admin API isolada do tráfego externo**, `admin.enabled: true` com `admin.type: ClusterIP` mantém a porta de consulta/administração do Kong acessível apenas de dentro do cluster, independente do tipo de exposição do proxy principal.
- **Ingress Controller (KIC) embutido no mesmo release**, `ingressController.enabled: true` liga o KIC no mesmo pod do Kong; o `gatewayDiscovery` permanece desligado (padrão do chart) porque o KIC fala direto com a Admin API local, sem precisar descobrir múltiplas instâncias de Kong.
- **Recursos dimensionados por ambiente**, dev usa uma réplica e limites baixos de CPU/memória (config de máquina local); prod usa duas réplicas — margem de segurança caso uma caia — com requests/limits maiores, refletindo carga real.

## Observação — inconsistência conhecida no repositório

O repositório contém um `Dockerfile` na raiz (`FROM python:latest`, `COPY requirements.txt .`, `EXPOSE 8000`) além de `.dockerignore` e `.env.example` com conteúdo genérico de projeto Python/aplicação. Nenhum `requirements.txt` existe no repositório e não há qualquer código Python — este repositório não builda nem publica uma imagem de aplicação, é puramente configuração de Helm/Kong. Esses arquivos aparentam ser resquício do scaffold padrão usado em repositórios Python da organização, aplicado aqui por engano durante a criação do repositório. Fica como ponto de atenção para limpeza futura; nenhuma correção foi aplicada neste momento, já que a decisão de remover ou repropositar esses arquivos cabe ao time responsável pelo repositório.

```Tree do Repositório
├── .github/
│   ├── pull_request_template.md
│   └── workflows/
│       ├── qa-sync.yml
│       └── release.yml
├── helm/
│   ├── README.md
│   ├── values-base.yaml
│   ├── values-dev.yaml
│   └── values-prod.yaml
├── .dockerignore          # {a confirmar} resquício de scaffold Python, sem uso real
├── .editorconfig
├── .env.example           # {a confirmar} resquício de scaffold Python, sem uso real
├── .gitattributes
├── .gitignore
├── Dockerfile             # {a confirmar} resquício de scaffold Python, sem uso real
├── LICENSE
├── README.md
├── ARCHITECTURE.md
├── RUNNING.md
└── ...
```
