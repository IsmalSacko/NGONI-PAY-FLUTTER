import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:ngoni_pay/common/utils/app_style.dart';
import 'package:ngoni_pay/common/utils/kcolors.dart';
import 'package:ngoni_pay/common/utils/kstrings.dart';
import 'package:ngoni_pay/common/utils/widgets/back_button.dart';
import 'package:ngoni_pay/common/utils/widgets/reusable_text.dart';
import 'package:ngoni_pay/features/auth/auth_controller.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final auth = context.watch<AuthController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Connexion",
          style: appStyle(20, Kolors.kWhite, FontWeight.w700),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: IconButton(
            icon: const Icon(
              AntDesign.leftcircle,
              color: Kolors.kWhite,
              size: 28,
            ),
            onPressed: () {
              context.go('/');
            },
          ),
        ),
        backgroundColor: Kolors.kPrimary,
        elevation: 0,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SizedBox(
            height: size.height - MediaQuery.of(context).padding.top,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // LOGO / TITLE
                Column(
                  children: const [
                    Icon(
                      Icons.account_balance_wallet_rounded,
                      size: 64,
                      color: Kolors.kPrimary,
                    ),
                    SizedBox(height: 12),
                    Text(
                      AppText.kAppName,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: Kolors.kDark,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      AppText.kLoginSubtitle,
                      style: TextStyle(fontSize: 14, color: Kolors.kGray),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // CARD
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Kolors.kWhite,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Kolors.kGrayLight.withValues(alpha: 0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // PHONE
                      TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: AppText.kTelephone,
                          prefixIcon: const Icon(Icons.phone_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // PASSWORD
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: AppText.kPassword,
                          prefixIcon: const Icon(Icons.lock_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                      // ERROR
                      if (auth.error != null)
                        ReusableText(
                          text: auth.error!,
                          style: const TextStyle(
                            color: Kolors.kRed,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      const SizedBox(height: 16),
                      // BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: auth.isLoading
                              ? null
                              : () async {
                                  final success = await auth.login(
                                    _phoneController.text,
                                    _passwordController.text,
                                  );

                                  if (!mounted) return;
                                  if (success) {
                                    context.go('/dashboard');
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Kolors.kPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: ReusableText(
                            text: AppText.kLoginButton,
                            style: appStyle(
                              16,
                              Kolors.kOffWhite,
                              FontWeight.w600,
                            ),
                          ),
                          // Text(
                          //   AppText.kLoginButton,
                          //   style: TextStyle(
                          //     fontSize: 16,
                          //     fontWeight: FontWeight.w600,
                          //     color: Kolors.kWhite,
                          //   ),
                          // ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // FOOTER
                TextButton(
                  onPressed: () {},
                  child: Text(
                    AppText.kForgotPassword,
                    style: TextStyle(
                      color: Kolors.kPrimary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                // REGISTER LINK
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Vous n'avez pas de compte ? "),
                    GestureDetector(
                      onTap: () {
                        context.go('/auth/register');
                      },
                      child: Text(
                        AppText.kRegisterButton,
                        style: TextStyle(
                          color: Kolors.kPrimary,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
