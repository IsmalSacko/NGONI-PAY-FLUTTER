import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ngoni_pay/common/utils/kcolors.dart';
import 'package:ngoni_pay/common/utils/kstrings.dart';
import 'package:ngoni_pay/common/utils/widgets/back_button.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F4FF),
      // appBar: AppBar(
      //   title: const Text('Inscription'),
      //   titleSpacing: 16,
      //   backgroundColor: Kolors.kSuccess
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SizedBox(
            height: size.height - MediaQuery.of(context).padding.top,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Bouton retour
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: AppBackButton(),
                  ),
                ),
                // LOGO / TITLE
                Column(
                  children: const [
                    Icon(
                      Icons.person_add_alt_1_rounded,
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
                      AppText.kRegisterSubtitle,
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
                      // FULL NAME
                      TextField(
                        decoration: InputDecoration(
                          labelText: AppText.kFullName,
                          prefixIcon: const Icon(Icons.person_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // PHONE
                      TextField(
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

                      // EMAIL
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: AppText.kEmail,
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // PASSWORD
                      TextField(
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

                      // CONFIRM PASSWORD
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: AppText.kConfirmPassword,
                          prefixIcon: const Icon(Icons.lock_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      DropdownButtonFormField<UserRole>(
                        value:
                            UserRole.owner, // valeur par défaut (comme Laravel)
                        decoration: InputDecoration(
                          labelText: AppText.kSelectRole,
                          prefixIcon: const Icon(Icons.badge_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: UserRole.values.map((role) {
                          return DropdownMenuItem<UserRole>(
                            value: role,
                            child: Text(
                              role == UserRole.owner
                                  ? AppText.kRoleOwner
                                  : AppText.kRoleStaff,
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          // PLUS TARD :
                          // stocker le rôle sélectionné
                        },
                      ),
                      const SizedBox(height: 24),

                      // BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            GoRouter.of(context).go('/business/create');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Kolors.kPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            AppText.kRegisterButton,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Kolors.kWhite,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // FOOTER
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppText.kAlreadyAccount,
                      style: const TextStyle(color: Kolors.kGray),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        AppText.kLoginButton,
                        style: const TextStyle(
                          color: Kolors.kPrimary,
                          fontWeight: FontWeight.w600,
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
