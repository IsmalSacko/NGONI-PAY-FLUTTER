// import 'package:flutter/material.dart';
// import 'package:ngoni_pay/common/utils/kstrings.dart';
// import 'package:ngoni_pay/features/auth/login_screen.dart';
// import 'package:ngoni_pay/features/dashboard/dashboard_screen.dart';

// import 'features/auth/register_screen.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(const NgoniPayApp());
// }

// class NgoniPayApp extends StatelessWidget {
//   const NgoniPayApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: AppText.kAppName,

//       theme: ThemeData(
//         useMaterial3: true,
//         colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C63FF)),
//         scaffoldBackgroundColor: const Color(0xFFF6F4FF),
//         appBarTheme: const AppBarTheme(
//           centerTitle: true,
//           elevation: 0,
//           backgroundColor: Colors.transparent,
//           foregroundColor: Colors.black,
//         ),
//       ),

//       // 🔐 Écran de départ
//       initialRoute: '/register',

//       routes: {
//         '/login': (context) => const LoginScreen(),
//         '/dashboard': (context) => const DashboardScreen(),
//         '/register': (context) => const RegisterScreen(),
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:ngoni_pay/app/app_router.dart';
import 'package:ngoni_pay/common/utils/kstrings.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NgoniPayApp());
}

class NgoniPayApp extends StatelessWidget {
  const NgoniPayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: AppText.kAppName,

      routerConfig: appRouter,

      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C63FF)),
        scaffoldBackgroundColor: const Color(0xFFF6F4FF),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
        ),
      ),
    );
  }
}
