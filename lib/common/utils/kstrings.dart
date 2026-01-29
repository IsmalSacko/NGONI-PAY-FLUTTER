enum UserRole { owner, staff }

class AppText {
  // =========================
  // 🏷️ APP GLOBAL
  // =========================
  static const String kAppName = 'NGONI PAY';
  static const String kAppSlogan = 'La solution simple pour vos paiements';
  static const String kLoading = 'Chargement...';
  static const String kRetry = 'Réessayer';
  static const String kContinue = 'Continuer';
  static const String kConfirm = 'Confirmer';
  static const String kCancel = 'Annuler';
  static const String kClose = 'Fermer';

  // =========================
  // 🔐 AUTHENTIFICATION
  // =========================
  static const String kLoginTitle = 'Connexion';
  static const String kLoginSubtitle = 'Connectez-vous à votre compte';
  static const String kEmail = 'Email';
  static const String kLogin = 'Se connecter';
  static const String kLoginText = 'Connectez-vous pour continuer';
  static const String kRegister = "S\'inscrire";
  static const String kRegisterTitle = 'Inscription';
  static const String kRegisterSubtitle = 'Créez un nouveau compte';
  static const String kEnterEmail = 'Entrez votre email';
  static const String kTelephone = 'Téléphone';
  static const String kEnterTelephone = 'Entrez votre numéro de téléphone';
  static const String kPassword = 'Mot de passe';
  static const String kForgotPassword = 'Mot de passe oublié ?';
  static const String kLoginButton = 'Se connecter';
  static const String kNoAccount = "Vous n'avez pas de compte ?";
  static const String kCreateAccount = 'Créer un compte';
  static const String kLogout = 'Se déconnecter';
  static const String kLogoutConfirm =
      'Êtes-vous sûr de vouloir vous déconnecter ?';
  static const String kSubmit = 'Soumettre';

  // =========================
  // 📝 INSCRIPTION

  static const kFullName = "Nom complet";
  static const kConfirmPassword = "Confirmer le mot de passe";
  static const kRegisterButton = "S'inscrire";
  static const kAlreadyAccount = "Vous avez déjà un compte ? ";
  static const kEnterFullName = "Entrez votre nom complet";
  static const kEnterPassword = "Entrez votre mot de passe";
  static const kEnterConfirmPassword = "Confirmez votre mot de passe";
  static const kRoleOwner = "Propriétaire";
  static const kRoleStaff = "Employé";
  static const kSelectRole = "Rôle";

  // =========================
  // ❌ ERREURS AUTH
  // =========================
  static const String kErrorLogin =
      'Impossible de se connecter avec les identifiants fournis.';
  static const String kErrorEmptyFields = 'Veuillez remplir tous les champs.';
  static const String kErrorInvalidEmail =
      'Veuillez saisir une adresse email valide.';
  static const String kErrorPasswordLength =
      'Le mot de passe doit contenir au moins 6 caractères.';
  static const String kSessionExpired =
      'Votre session a expiré. Veuillez vous reconnecter.';

  // =========================
  // 🏠 DASHBOARD
  // =========================
  static const String kDashboardTitle = 'Tableau de bord';
  static const String kWelcome = 'Bienvenue';
  static const String kBalance = 'Solde disponible';
  static const String kRecentTransactions = 'Transactions récentes';
  static const String kViewAll = 'Voir tout';
  static const String kBalanceDescription =
      'Consultez votre solde actuel en temps réel';
  static const String kSeeAllTransactions = 'Voir toutes les transactions';
  static const String kNoTransactions =
      'Aucune transaction disponible pour le moment';

  // =========================
  // 💳 PAIEMENTS
  // =========================
  static const String kPayments = 'Paiements';
  static const String kPaymentAppBarTitle = 'Paiements';
  static const String kNewPayment = 'Nouveau paiement';
  static const String kReference = 'Référence';
  static const String kAmount = 'Montant';
  static const String kCurrency = 'Devise';
  static const String kPaymentMethod = 'Méthode de paiement';
  static const String kPayNow = 'Payer maintenant';
  static const String kPaymentSuccess = 'Paiement effectué avec succès';
  static const String kPaymentFailed =
      'Le paiement a échoué. Veuillez réessayer.';
  static const String kPaymentPending = 'Paiement en attente';
  static const String kMakePayment = 'Effectuer un paiement en toute sécurité';

  static const String kPaymentSuccessTitle = 'Paiement réussi';
  static const String kPaymentSuccessMessage =
      'Votre paiement a été effectué avec succès';
  static const String kPaymentPendingMessage =
      'Votre paiement est en cours de traitement';
  static const String kPaymentFailedMessage =
      'Le paiement a échoué. Veuillez réessayer.';

  // =========================
  // 🧾 TRANSACTIONS
  // =========================
  static const String kTransactions = 'Transactions';
  static const String kTransactionDetails = 'Détails de la transaction';
  static const String kTransactionId = 'Référence';
  static const String kTransactionStatus = 'Statut';
  static const String kDate = 'Date';

  static const String kStatusSuccess = 'Succès';
  static const String kStatusPending = 'En attente';
  static const String kStatusFailed = 'Échec';

  // ========================
  // 🧾 FACTURES

  static const String kInvoices = 'Factures';
  static const String kCreateInvoice = 'Créer une facture';
  static const String kInvoiceNumber = 'Numéro de facture';
  static const String kTotalAmount = 'Montant total';

  // =========================
  // 👤 PROFIL
  // =========================
  static const String kProfile = 'Mon profil';
  static const String kPkAppName = 'Nom et prénom';
  static const String kEditProfile = 'Modifier le profil';
  static const String kPhone = 'Téléphone';
  static const String kSave = 'Enregistrer';
  static const String kChangePassword = 'Changer le mot de passe';

  // =========================
  // ⚙️ PARAMÈTRES & LÉGAL
  // =========================
  static const String kSettings = 'Paramètres';
  static const String kNotifications = 'Notifications';
  static const String kSecurity = 'Sécurité';
  static const String kHelp = 'Aide';
  static const String kPrivacyPolicy = 'Politique de confidentialité';
  static const String kTerms = 'Conditions générales';

  // =========================
  // ℹ️ MESSAGES GÉNÉRIQUES
  // =========================
  static const String kNoData = 'Aucune donnée disponible';
  static const String kComingSoon = 'Fonctionnalité bientôt disponible';
  static const String kUnknownError =
      'Une erreur est survenue. Veuillez réessayer plus tard.';

  // =========================
  // 📱 CLIENTS
  static const String kClients = 'Clients';
  static const String kClientName = 'Nom du client';
  static const String kClientPhone = 'Téléphone du client';
  static const String kAddClient = 'Ajouter un client';

  // =========================
  // Subscriptions
  static const String kCreateSubscription = 'Créer un abonnement';
  static const String kPlanType = 'Type de plan';
  static const String kDuration = 'Durée';
  static const String kManageSubscriptions = 'Gérer les abonnements';

  // =========================
  // BusinessUser
  static const String kAddBusinessUser = 'Ajouter un utilisateur professionnel';
  static const String kUserEmail = 'Email de l\'utilisateur';
  static const String kRole = 'Rôle';
  static const String kBusinessUsers = 'Utilisateurs professionnels';

  // =========================
  // Businesses
  static const String kCreateBusiness = 'Créer une entreprise';
  static const String kOwnerId = 'Propriétaire (ID)';
  static const String kOwner = 'Propriétaire';
  static const String kBusinesses = 'Entreprises';
  static const String kBusinessName = 'Nom de l\'entreprise';
  static const String kBusinessType = 'Type d\'entreprise';
  static const String kBusinessAddress = 'Adresse de l\'entreprise';
  static const String kIsActive = 'Activer l\'entreprise ou non';
}
