import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ngoni_pay/core/auth/auth_notifier.dart';
import 'package:ngoni_pay/core/storage/secure_storage.dart';
import 'package:ngoni_pay/core/router/router_keys.dart';

// Public
import 'package:ngoni_pay/features/auth/login_screen.dart';
import 'package:ngoni_pay/features/auth/register_screen.dart';
import 'package:ngoni_pay/features/welcome/onboarding/onboarding_screen.dart';
import 'package:ngoni_pay/features/welcome/onboarding/welcome_screen.dart';

// Shell
import 'package:ngoni_pay/features/shell/app_shell.dart';

// Connected screens
import 'package:ngoni_pay/features/dashboard/dashboard_screen.dart';
import 'package:ngoni_pay/features/dashboard/free_dashboard_screen.dart';
import 'package:ngoni_pay/features/businessUser/business_user_create_screen.dart';
import 'package:ngoni_pay/features/businesses/screens/business_list_screen.dart';
import 'package:ngoni_pay/features/businesses/screens/business_picker_screen.dart';
import 'package:ngoni_pay/features/businesses/screens/business_create_screen.dart';
import 'package:ngoni_pay/features/client/client_create_screen.dart';
import 'package:ngoni_pay/features/payment/payment_create_screen.dart';
import 'package:ngoni_pay/features/payment/payment_list_screen.dart';
import 'package:ngoni_pay/features/payment/payment_webview_screen.dart';
import 'package:ngoni_pay/features/invoice/controller/invoice_controller.dart';
import 'package:ngoni_pay/features/invoice/invoice_create_screen.dart';
import 'package:ngoni_pay/features/subscription/screens/subscription_plan_screen.dart';
import 'package:ngoni_pay/features/user/profile_edit_screen.dart';
import 'package:ngoni_pay/features/user/user_profile_screen.dart';
import 'package:provider/provider.dart';

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  refreshListenable: authRefreshNotifier,
  initialLocation: '/onboarding',

  redirect: (context, state) async {
    final token = await SecureStorage.getToken();
    final isAuth = token != null;
    final path = state.uri.path;

    final isAuthRoute = path.startsWith('/auth');
    final isOnboarding = path == '/onboarding';
    final isWelcome = path == '/welcome';

    // Pas connecté → autoriser onboarding / welcome / auth
    if (!isAuth && !(isAuthRoute || isOnboarding || isWelcome)) {
      return '/auth/login';
    }

    // Déjà connecté → bloquer onboarding / welcome / auth
    if (isAuth && (isAuthRoute || isOnboarding || isWelcome)) {
      return '/dashboard';
    }

    return null;
  },

  routes: [
    // ===== PUBLIC FLOW =====
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/auth/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/auth/register',
      builder: (context, state) => const RegisterScreen(),
    ),

    // ===== CONNECTED AREA =====
    ShellRoute(
      builder: (context, state, child) {
        return AppShell(child: child);
      },
      routes: [
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/dashboard/free',
          builder: (context, state) => const FreeDashboardScreen(),
        ),
        GoRoute(
          path: '/business/create',
          builder: (context, state) => const BusinessCreateScreen(),
        ),
        GoRoute(
          path: '/businessuser',
          builder: (context, state) => const BusinessUserCreateScreen(),
        ),
        GoRoute(
          path: '/client/create',
          builder: (context, state) => const ClientCreateScreen(),
        ),
        GoRoute(
          path: '/businesses_list',
          builder: (context, state) => const BusinessListScreen(),
        ),
        GoRoute(
          path: '/business/picker',
          builder: (context, state) => const BusinessPickerScreen(),
        ),
        GoRoute(
          path: '/payments/create/:businessId',
          builder: (context, state) {
            final businessId = int.parse(state.pathParameters['businessId']!);
            return PaymentCreateScreen(businessId: businessId);
          },
        ),
        GoRoute(
          path: '/payments/list/:businessId',
          builder: (context, state) {
            final businessId = int.parse(state.pathParameters['businessId']!);
            return PaymentListScreen(businessId: businessId);
          },
        ),
        GoRoute(
          path: '/payments/checkout',
          builder: (context, state) {
            String? checkoutUrl;
            int? businessId;
            int? paymentId;
            final extra = state.extra;

            if (extra is String) {
              checkoutUrl = extra;
            } else if (extra is Map) {
              final rawUrl = extra['checkoutUrl'];
              if (rawUrl is String) {
                checkoutUrl = rawUrl;
              }

              final rawBusinessId = extra['businessId'];
              if (rawBusinessId is int) {
                businessId = rawBusinessId;
              } else if (rawBusinessId is String) {
                businessId = int.tryParse(rawBusinessId);
              }

              final rawPaymentId = extra['paymentId'];
              if (rawPaymentId is int) {
                paymentId = rawPaymentId;
              } else if (rawPaymentId is String) {
                paymentId = int.tryParse(rawPaymentId);
              }
            }

            if (checkoutUrl == null || checkoutUrl.isEmpty) {
              return const Scaffold(
                body: Center(
                  child: Text('URL de paiement introuvable.'),
                ),
              );
            }
            final successRoute = extra is Map ? extra['successRoute'] as String? : null;
            return PaymentWebViewScreen(
              checkoutUrl: checkoutUrl,
              businessId: businessId,
              paymentId: paymentId,
              successRoute: successRoute,
            );
          },
        ),
        GoRoute(
          path: '/payments/:paymentId/invoice',
          builder: (context, state) {
            final paymentId = int.parse(state.pathParameters['paymentId']!);
            return ChangeNotifierProvider(
              create: (_) => InvoiceController(),
              child: InvoiceScreen(paymentId: paymentId),
            );
          },
        ),
        GoRoute(
          path: '/subscription/:businessId',
          builder: (context, state) {
            final businessId = int.parse(state.pathParameters['businessId']!);
            return SubscriptionPlanScreen(businessId: businessId);
          },
        ),
        // GoRoute(
        //   path: '/subscription/create',
        //   builder: (context, state) =>
        //       const SubscriptionCreateScreen(),
        // ),
        GoRoute(
          path: '/me/edit',
          builder: (context, state) => const ProfileEditScreen(),
        ),
        GoRoute(
          path: '/me',
          builder: (context, state) => const UserProfileScreen(),
        ),
      ],
    ),
  ],
);
