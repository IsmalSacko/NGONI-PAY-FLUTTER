# Environnements (dev / staging / prod)

## Objectif
Permettre de changer rapidement l’API cible sans modifier le code.

## Configuration
La base URL peut être fournie via `--dart-define`.

Dans `lib/core/config/api_config.dart` :
```dart
static const String baseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'https://ngonipay.ismael-dev.com/api',
);
```

## Exemples d’exécution
### Dev (local ou test)
```bash
flutter run --dart-define=API_BASE_URL=https://dev.example.com/api
```

### Staging
```bash
flutter run --dart-define=API_BASE_URL=https://staging.example.com/api
```

### Production
```bash
flutter run --dart-define=API_BASE_URL=https://ngonipay.ismael-dev.com/api
```

## Build release
```bash
flutter build apk --release --dart-define=API_BASE_URL=https://ngonipay.ismael-dev.com/api
```
