# Documentation NGONI PAY (Flutter)

## 1) Vue d’ensemble
NGONI PAY est une application Flutter de gestion de paiements et d’abonnements, connectée à une API distante.

Fonctions principales :
- Authentification (inscription / connexion)
- Gestion des businesses
- Abonnements (Free, Basic, Pro)
- Paiements (cash + PayDunya)
- Factures et partage
- Tableau de bord (standard et Free)

## 2) Stack technique
- Flutter (UI mobile)
- Provider (state management)
- Dio (HTTP)
- GoRouter (navigation)
- SharedPreferences + SecureStorage (cache local + token)

## 3) Configuration API
Fichier : `lib/core/config/api_config.dart`

```dart
class ApiConfig {
  static const String baseUrl = 'https://ngonipay.ismael-dev.com/api';
}
```

Timeouts réseau :
Fichier : `lib/core/services/api_service.dart`
- connectTimeout = 20s
- receiveTimeout = 30s

## 4) Lancement du projet
### Pré-requis
- Flutter SDK installé
- Android Studio / Xcode (selon plateforme)

### Commandes
```bash
flutter pub get
flutter run
```

## 5) Structure du projet (Flutter)
```
lib/
  app/                # router et configuration app
  common/             # styles, widgets réutilisables, constantes
  core/               # services API, storage, configs
  features/           # modules métier (auth, payment, subscription, etc.)
```

## 6) Authentification
Fichiers clés :
- `lib/features/auth/auth_service.dart`
- `lib/features/auth/auth_controller.dart`
- `lib/features/auth/login_screen.dart`
- `lib/features/auth/register_screen.dart`

Flux :
1. Login/Register → récupération token
2. Token stocké via `SecureStorage`
3. `GoRouter` est rafraîchi via `authRefreshNotifier`
4. Redirection automatique vers `/dashboard`

## 7) Abonnements
Backend :
`/businesses/{business}/subscription`

Frontend :
- `lib/features/subscription/`
- `SubscriptionController`

### Plan Free (24h)
Le plan Free donne accès au dashboard normal pendant 24h.
Après 24h → retour automatique au dashboard Free.

Note : cette logique dépend du backend (voir release notes).

## 8) Business
Le business est obligatoire pour l’abonnement et les paiements.

Cache :
- `last_business_id` stocké dans `SharedPreferences`
- Validation systématique pour éviter un ID d’un ancien compte

## 9) Paiements
Fichiers clés :
- `lib/features/payment/`
- `PaymentController`
- `PaymentService`

Règles :
- Free → paiement offline (pas de PayDunya)
- Basic → limite PayDunya (5 / mois)
- Pro → complet

## 10) UI/UX – Erreurs
Tous les écrans utilisent le composant :
`lib/common/utils/widgets/error_banner.dart`

Erreurs réseau claires :
- timeout
- serveur inaccessible
- certificat invalide

## 11) Release & sécurité
Fichiers ignorés :
- `/android/app/upload-keystore.jks`
- `/android/key.properties`

## 12) Troubleshooting
### A) Timeout API sur émulateur
Si le vrai device fonctionne mais l’émulateur non :
- Vérifier accès URL dans navigateur de l’émulateur
- Désactiver proxy/VPN
- Cold Boot / Wipe Data

### B) Utilisateur bloqué sur login
Vérifier la présence du token.
Si “Token manquant” → vérifier réponse API.

## 13) Endpoints API (principaux)
Base URL :
- `https://ngonipay.ismael-dev.com/api`

Auth :
- `POST /auth/register`
- `POST /auth/login`
- `GET /auth/me`
- `PATCH /auth/update-profile`
- `POST /auth/logout`

Business :
- `GET /businesses`
- `POST /businesses`
- `GET /businesses/{business}`
- `PUT /businesses/{business}`
- `DELETE /businesses/{business}`
- `GET /businesses/{business}/stats`
- `GET /businesses/{business}/stats/daily`

Subscription :
- `GET /businesses/{business}/subscription`
- `POST /businesses/{business}/subscription`
- `PUT /businesses/{business}/subscription/{subscription}`

Payments :
- `GET /businesses/{business}/payments`
- `POST /businesses/{business}/payments`
- `GET /businesses/{business}/payments/{payment}`
- `GET /payments/{payment}/invoice`

Callback :
- `POST /payments/callback`

## 14) Déploiement
### Android (Release)
1. Générer un keystore (si pas encore) :
```bash
keytool -genkey -v -keystore android/app/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

2. Configurer `android/key.properties` :
```
storePassword=***
keyPassword=***
keyAlias=upload
storeFile=upload-keystore.jks
```

3. Build APK :
```bash
flutter build apk --release
```

4. Build AAB (Play Store) :
```bash
flutter build appbundle --release
```

### iOS (Release)
1. Installer pods :
```bash
cd ios && pod install
```
2. Ouvrir `ios/Runner.xcworkspace` dans Xcode
3. Configurer Signing & Capabilities
4. Build Archive → Export

## 15) Checklist QA (avant release)
- Auth : login / register OK
- Token stocké et redirect OK
- Business : création / liste OK
- Abonnement : Free → 24h OK
- Abonnement : Basic / Pro OK
- Paiement : cash OK
- Paiement : PayDunya OK
- Facture PDF OK
- Partage WhatsApp OK
- Offline / timeout → message clair
- Rotation paysage (onboarding, login) OK

## 16) Environnements
Voir `docs/ENVIRONMENTS.md`

---
Si besoin d’une version plus détaillée (architecture backend, endpoints, etc.), indique-moi les sections à ajouter.
