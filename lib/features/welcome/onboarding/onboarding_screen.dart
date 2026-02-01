import 'package:flutter/material.dart';
import 'package:ngoni_pay/features/welcome/onboarding/page_one.dart';
import 'package:ngoni_pay/features/welcome/onboarding/page_tree.dart';
import 'package:ngoni_pay/features/welcome/onboarding/page_two.dart';
import 'package:ngoni_pay/features/welcome/onboarding/welcome_screen.dart';
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const BouncingScrollPhysics(),
        children: const [
          PageOne(),
          PageTwo(),
          PageThree(),
          WelcomeScreen(),
        ],
      ),
    );
  }
}
