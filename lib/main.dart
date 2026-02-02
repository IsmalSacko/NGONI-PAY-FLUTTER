import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ngoni_pay/features/businesses/controllers/business_controller.dart';
import 'package:ngoni_pay/features/businesses/controllers/stats_controller.dart';
import 'package:ngoni_pay/features/payment/controller/payment_controller.dart';
import 'package:ngoni_pay/features/payment/controller/payment_list_controller.dart';
import 'package:ngoni_pay/features/subscription/controllers/subscription_controller.dart';
import 'package:ngoni_pay/features/user/profile_controller.dart';
import 'package:provider/provider.dart';

import 'package:ngoni_pay/app/app_router.dart';
import 'package:ngoni_pay/common/utils/kstrings.dart';
import 'package:ngoni_pay/features/auth/auth_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NgoniPayApp());
}

class NgoniPayApp extends StatelessWidget {
  const NgoniPayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StatsController()),
        ChangeNotifierProvider(create: (_) => PaymentController()),
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => ProfileController()),
        ChangeNotifierProvider(create: (_) => BusinessController()),
        ChangeNotifierProvider(create: (_) => PaymentListController()),
        ChangeNotifierProvider(create: (_) => SubscriptionController()),
      ],

      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: AppText.kAppName,
            routerConfig: appRouter,
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF6C63FF),
              ),
              scaffoldBackgroundColor: const Color(0xFFF6F4FF),
              appBarTheme: const AppBarTheme(
                centerTitle: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.black,
              ),
            ),
          );
        },
      ),
    );
  }
}
