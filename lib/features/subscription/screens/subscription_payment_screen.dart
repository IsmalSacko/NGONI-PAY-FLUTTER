import 'package:flutter/material.dart';
import 'package:ngoni_pay/common/utils/kcolors.dart';
import 'package:ngoni_pay/features/subscription/controllers/subscription_controller.dart';
import 'package:ngoni_pay/features/subscription/screens/subscription_success_screen.dart';
import 'package:provider/provider.dart';

class SubscriptionPaymentScreen extends StatelessWidget {
  final int businessId;
  final String plan;

  const SubscriptionPaymentScreen({
    super.key,
    required this.businessId,
    required this.plan,
  });

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SubscriptionController>();

    final Map<String, Map<String, String>> planDetails = {
      'free': {
        'title': 'Free',
        'price': '0 FCFA',
        'description':
            "L'abonnement Free est entièrement gratuit et vous permet d'accéder aux fonctionnalités de base de notre plateforme. Vous pouvez créer et gérer vos factures, suivre vos paiements et bénéficier d'un support client standard.",
      },
      'basic': {
        'title': 'Basic',
        'price': '5 000 FCFA / mois',
        'description':
            "L'abonnement Basic offre des fonctionnalités supplémentaires pour les petites entreprises. Il inclut tout ce que l'abonnement Free propose, ainsi que des options de personnalisation, un support client amélioré et des outils de gestion plus avancés.",
      },
      'pro': {
        'title': 'Pro',
        'price': '15 000 FCFA / an',
        'description':
            "L'abonnement Pro offre des fonctionnalités avancées pour les professionnels. Il inclut tout ce que l'abonnement Basic propose, ainsi que des outils de reporting avancés, une assistance prioritaire et des intégrations avec d'autres services professionnels.",
      },
    };

    final currentPlan = planDetails[plan] ?? planDetails['free']!;
    final imagePath = 'assets/images/subscription_$plan.png';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Paiement"),
        backgroundColor: Kolors.kPrimary,
        foregroundColor: Kolors.kWhite,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  imagePath,
                  // height: 250,
                  width: 10,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 250,
                      decoration: BoxDecoration(
                        color: Kolors.kPrimary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 64,
                          color: Kolors.kGray,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Plan choisi : ${currentPlan['title']}",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Kolors.kDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              currentPlan['price']!,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Kolors.kPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              currentPlan['description']!,
              style: const TextStyle(
                fontSize: 15,
                color: Kolors.kGray,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Kolors.kPrimary,
                  foregroundColor: Kolors.kWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: controller.isLoading
                    ? null
                    : () async {
                        final ok = await controller.createSubscription(
                          businessId: businessId,
                          plan: plan,
                        );

                        if (ok && context.mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SubscriptionSuccessScreen(),
                            ),
                          );
                        }
                      },
                child: controller.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Kolors.kWhite,
                        ),
                      )
                    : const Text(
                        "Confirmer",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
