import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ngoni_pay/common/utils/kcolors.dart';
import 'package:ngoni_pay/common/utils/kstrings.dart';
import 'package:ngoni_pay/common/utils/widgets/app_appbar.dart';
import 'package:ngoni_pay/core/storage/secure_storage.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: const Color(0xFFF6F4FF),
        appBar: AppAppBar(
        title: 'Bienvenue',     
        
      ),
      //backgroundColor: const Color(0xFFF6F4FF),
      body: SafeArea(
        
        child: FadeTransition(
          opacity: _fade,
          child: SlideTransition(
            position: _slide,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 🔷 LOGO
                  Container(
                    height: 110,
                    width: 110,
                    decoration: BoxDecoration(
                      color: Kolors.kPrimary.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.payments_outlined,
                      size: 64,
                      color: Kolors.kPrimary,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // 🏷️ APP NAME
                  const Text(
                    AppText.kAppName,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Kolors.kDark,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 💬 TAGLINE
                  const Text(
                    "Encaissez, gérez et suivez vos paiements\nsimplement et en toute sécurité.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Kolors.kGray,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 48),

                  FutureBuilder<bool>(
                    future: isAuthenticated(),
                    builder: (context, snapshot) {
                      // En attente → on n’affiche rien (évite le flicker)
                      if (!snapshot.hasData) {
                        return const SizedBox.shrink();
                      }

                      final isAuth = snapshot.data!;

                      //  UTILISATEUR DÉJÀ CONNECTÉ
                      if (isAuth) {
                        return SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () {
                              context.go('/dashboard');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Kolors.kPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 4,
                            ),
                            child: const Text(
                              "Aller au tableau de bord",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      }

                      // ❌ UTILISATEUR NON CONNECTÉ
                      return Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: () {
                                context.go('/auth/register');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Kolors.kPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: 4,
                              ),
                              child: const Text(
                                "Commencer",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          TextButton(
                            onPressed: () {
                              context.go('/auth/login');
                            },
                            child: const Text(
                              "J’ai déjà un compte",
                              style: TextStyle(
                                color: Kolors.kPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


Future<bool> isAuthenticated() async {
  final token = await SecureStorage.getToken();
  return token != null && token.isNotEmpty;
}
