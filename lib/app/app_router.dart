import 'package:go_router/go_router.dart';
import 'package:ngoni_pay/core/storage/secure_storage.dart';
import 'package:ngoni_pay/features/businessUser/business_user_create_screen.dart';
import 'package:ngoni_pay/features/businesses/business_list_screen.dart';
import 'package:ngoni_pay/features/businesses/business_picker_screen.dart';
import 'package:ngoni_pay/features/dashboard/dashboard_screen.dart';
import 'package:ngoni_pay/features/invoice/controller/invoice_controller.dart';
import 'package:ngoni_pay/features/payment/payment_create_screen.dart';
import 'package:ngoni_pay/features/payment/payment_list_screen.dart';
import 'package:ngoni_pay/features/user/user_profile_screen.dart';

// Public
import 'package:ngoni_pay/features/welcome/welcome_screen.dart';
import 'package:ngoni_pay/features/auth/login_screen.dart';
import 'package:ngoni_pay/features/auth/register_screen.dart';

// Shell
import 'package:ngoni_pay/features/shell/app_shell.dart';

// Screens
import 'package:ngoni_pay/features/businesses/business_create_screen.dart';
import 'package:ngoni_pay/features/client/client_create_screen.dart';
import 'package:ngoni_pay/features/invoice/invoice_create_screen.dart';
import 'package:ngoni_pay/features/subscription/subscription_create_screen.dart';
import 'package:provider/provider.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) async {
    final token = await SecureStorage.getToken();
    final isAuthRoute = state.uri.path.startsWith('/auth');

    // pas connecté -> bloquer la zone connectée
    if (token == null && !isAuthRoute && state.uri.path != '/') {
      return '/auth/login';
    }
    // déjà connecté -> pas besoin login/register
    if (token != null && isAuthRoute) {
      return '/home';
    }
    return null;
  },

  routes: [
    //PUBLIC
    GoRoute(path: '/', builder: (context, state) => const WelcomeScreen()),
    GoRoute(
      path: '/auth/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/auth/register',
      builder: (context, state) => const RegisterScreen(),
    ),

    // CONNECTED AREA
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
          path: '/dashboard',
          builder: (context, state) => const DashboardScreen(),
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
        // Business routes
        GoRoute(
          path: '/businesses_list',
          builder: (context, state) => const BusinessListScreen(),
        ),
        // Nouveau paiement
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
          path: '/subscription/create',
          builder: (context, state) => const SubscriptionCreateScreen(),
        ),
        GoRoute(
          path: '/me',
          builder: (context, state) => const UserProfileScreen(),
        ),
      ],
    ),
  ],
);
