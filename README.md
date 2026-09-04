# infra-gateway

Este repositório concentra a configuração de infraestrutura do **Kong Gateway**, o API Gateway usado pela organização para expor e proteger os serviços internos rodando no cluster Kubernetes (GKE). Diferente da maioria dos repositórios da organização, aqui não existe código de aplicação: o conteúdo é inteiramente declarativo, feito de arquivos `values.yaml` consumidos pelo chart oficial `kong/kong` via Helm. O Kong roda no modo `traditional` com `database: off`, ou seja, sem banco de dados próprio — toda a configuração do gateway fica em memória e é reconstruída a partir dos arquivos deste repositório a cada deploy, o que simplifica o operacional em um cluster efêmero. O objetivo é manter a definição do gateway versionada, revisável em Pull Request e sincronizada automaticamente no cluster via ArgoCD, seguindo o mesmo padrão de IaC adotado pelos demais repositórios de infraestrutura da organização.

<p>

[![License](https://img.shields.io/github/license/Solierrr/infra-gateway)](https://github.com/Solierrr/infra-gateway/blob/main/LICENSE)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/Solierrr/infra-gateway)](https://github.com/Solierrr/infra-gateway/commits)
[![GitHub Issues](https://img.shields.io/github/issues/Solierrr/infra-gateway)](https://github.com/Solierrr/infra-gateway/issues)
[![GitHub Pull Requests](https://img.shields.io/github/issues-pr/Solierrr/infra-gateway)](https://github.com/Solierrr/infra-gateway/pulls)
[![GitHub Contributors](https://img.shields.io/github/contributors/Solierrr/infra-gateway)](https://github.com/Solierrr/infra-gateway/graphs/contributors)
[![Release](https://img.shields.io/github/v/release/Solierrr/infra-gateway)](https://github.com/Solierrr/infra-gateway/releases)

</p>

<div align="center">

<p>
  <a href="https://github.com/syvixor/skills-icons">
    <img src="https://skills.syvixor.com/api/icons?i=gcp,kubernetes,kong,argocd,helm" height="48" alt="Cloud & Infrastructure">
  </a>
</p>

<p>

[![Google Cloud](https://img.shields.io/badge/Google_Cloud-4285F4?logo=googlecloud&logoColor=white)](https://cloud.google.com/)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?logo=kubernetes&logoColor=white)](https://kubernetes.io/)
[![Kong](https://img.shields.io/badge/Kong_Gateway-003459?logo=kong&logoColor=white)](https://konghq.com/)
[![Argo CD](https://img.shields.io/badge/Argo_CD-EF7B4D?logo=argo&logoColor=white)](https://argo-cd.readthedocs.io/)
[![Helm](https://img.shields.io/badge/Helm-0F1689?logo=helm&logoColor=white)](https://helm.sh/)

</p>

</div>

## Aprofunde-se no Projeto!

- [ARCHITECTURE.md](./ARCHITECTURE.md), estrutura do repositório e decisões de configuração do Kong.
- [RUNNING.md](./RUNNING.md), como renderizar e validar o chart localmente.
- [{a confirmar} DEPLOYMENT.md](./DEPLOYMENT.md), pipeline de deploy — ainda não existe neste repositório; consulte o [DEPLOYMENT.md do docs-warehouse](https://github.com/Solierrr/docs-warehouse/blob/main/.github/DEPLOYMENT.md) enquanto isso.

## Contribuindo

- [CONTRIBUTING.md](./CONTRIBUTING.md), convenções de commit, branch e Pull Request.
- [CODE_OF_CONDUCT.md](./CODE_OF_CONDUCT.md), código de conduta do projeto.
- [SECURITY.md](./SECURITY.md), como reportar vulnerabilidades de segurança.
