# Changelog

## [2026-02-06]
### Added
- Documentation complète + release notes
- Support `API_BASE_URL` via `--dart-define`
- CI GitHub/GitLab (analyse, tests, build)
- Template QA

### Changed
- Timeouts API (20s / 30s)
- UI responsive (onboarding, welcome, login)
- Erreurs réseau plus claires + ErrorBanner global
- Auth redirection gérée par GoRouter refresh
- Free trial 24h côté backend + règles front

### Fixed
- Blocage après login si token manquant
- 403 liés à un businessId d’ancien compte
- Overflow UI en rotation

