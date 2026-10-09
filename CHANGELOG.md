# Changelog

## [0.3.0](https://github.com/Solierrr/infra-gateway/compare/v0.2.0...v0.3.0) (2026-10-09)


### Features

* add the kong gateway for the qa environment ([d1d045c](https://github.com/Solierrr/infra-gateway/commit/d1d045c3a2167dd1fe831362fc9e4212616d76ed))


### Bug Fixes

* listen on every port render may route to ([63edf1c](https://github.com/Solierrr/infra-gateway/commit/63edf1cec2aa3388fa78408fda80ade1b9b26cb1))
* run kong with one worker to fit the free tier memory ([7e94ff7](https://github.com/Solierrr/infra-gateway/commit/7e94ff7f41e54ad65b08ad2533913b0e6632a679))

## [0.2.0](https://github.com/Solierrr/infra-gateway/compare/v0.1.0...v0.2.0) (2026-09-30)


### Features

* add Helm configuration files for Kong deployment ([b583731](https://github.com/Solierrr/infra-gateway/commit/b58373146027b40c7558fbff3f6348427a364d3c))
* wire up qa-sync and repo-cleanup reusable workflows ([8cd237d](https://github.com/Solierrr/infra-gateway/commit/8cd237d5b6efce0a16c571ccd397823a8a5e0ad3))
* wire up qa-sync and repo-cleanup reusable workflows ([f2ca55d](https://github.com/Solierrr/infra-gateway/commit/f2ca55dd9e024af4a9fbb36313540443b89afe33))


### Bug Fixes

* disable ingressController gatewayDiscovery ([3cc5320](https://github.com/Solierrr/infra-gateway/commit/3cc5320c16f1893304d8578cdc4d6b69d4bd06f0))
* kong helm values schema and gateway discovery ([d746224](https://github.com/Solierrr/infra-gateway/commit/d7462245d154c891c34e47c1b88644026d49a3bb))
* move Kong helm values to root-level schema keys ([6807db9](https://github.com/Solierrr/infra-gateway/commit/6807db981b9b8dc58f2be4797a7eed977e09cbce))
* pass vault arguments correctly in PowerShell ([84a5371](https://github.com/Solierrr/infra-gateway/commit/84a537150413c8b64cb6d8acda05b7383565f7d0))
* support powershell secret extraction ([1867487](https://github.com/Solierrr/infra-gateway/commit/18674873804a4cb2ecc543b257ba39d2982361a6))
