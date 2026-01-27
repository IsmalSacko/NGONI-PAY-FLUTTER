import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ngoni_pay/features/businessUser/business_user_create_screen.dart';

// Public
import 'package:ngoni_pay/features/welcome/welcome_screen.dart';
import 'package:ngoni_pay/features/auth/login_screen.dart';
import 'package:ngoni_pay/features/auth/register_screen.dart';

// Shell
import 'package:ngoni_pay/features/shell/app_shell.dart';

// Screens
import 'package:ngoni_pay/features/businesses/business_create_screen.dart';
import 'package:ngoni_pay/features/client/client_create_screen.dart';
import 'package:ngoni_pay/features/payment/payment_create_screen.dart';
import 'package:ngoni_pay/features/invoice/invoice_create_screen.dart';
import 'package:ngoni_pay/features/subscription/subscription_create_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // 🌍 PUBLIC
    GoRoute(path: '/', builder: (context, state) => const WelcomeScreen()),
    GoRoute(
      path: '/auth/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/auth/register',
      builder: (context, state) => const RegisterScreen(),
    ),

    // 🔐 CONNECTED AREA
    ShellRoute(
      builder: (context, state, child) {
        return AppShell(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const WelcomeScreen(),
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
          path: '/payment/create',
          builder: (context, state) => const PaymentCreateScreen(),
        ),
        GoRoute(
          path: '/invoice/create',
          builder: (context, state) => const InvoiceCreateScreen(),
        ),
        GoRoute(
          path: '/subscription/create',
          builder: (context, state) => const SubscriptionCreateScreen(),
        ),
        GoRoute(
          path: '/me',
          builder: (context, state) => const Center(child: Text('Profil')),
        ),
      ],
    ),
  ],
);
