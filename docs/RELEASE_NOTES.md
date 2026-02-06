# Release Notes — 2026-02-06

## Résumé
Cette version améliore la stabilité de l’auth, la gestion d’abonnement Free (essai 24h), et la qualité UX des erreurs.  
Elle renforce aussi la sécurité (keystore ignoré) et l’adaptation UI en rotation.

## ✅ Améliorations
- Timeouts API plus robustes (20s / 30s) pour les réseaux lents.
- Messages d’erreur réseau plus explicites (timeout, serveur inaccessible, certificat).
- Bannières d’erreur uniformes sur l’ensemble des écrans.
- Mot de passe visible/masqué sur login et register.
- Onboarding et welcome responsive en paysage.

## ✅ Abonnement Free (24h)
Backend :
- Plan Free = accès dashboard normal pendant 24h.
- Après expiration → retour automatique sur dashboard Free.

Frontend :
- Basculer vers `/dashboard` si Free encore actif.
- Basculer vers `/dashboard/free` si Free expiré.

## ✅ Correctifs
- Validation stricte du token login/register (évite “connecté” sans token).
- Nettoyage du cache business (`last_business_id`) à login/register/logout.
- Validation du businessId pour empêcher les 403 liés à un ID d’un ancien compte.
- Navigation auth stabilisée via refresh GoRouter.

## ✅ Sécurité
Ajout au `.gitignore` :
- `/android/app/upload-keystore.jks`
- `/android/key.properties`

## ✅ Backend (NGONI-PAY)
Fichier :
`app/Http/Controllers/Api/SubscriptionController.php`

Changements :
- Free = 24h
- Transition payant → free à expiration
- Cap 24h si free déjà existant

## Notes importantes
Les modifications “Free 24h” nécessitent un **déploiement backend** pour être effectives côté production.

