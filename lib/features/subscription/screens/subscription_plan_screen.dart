import 'package:flutter/material.dart';
import 'package:ngoni_pay/common/utils/kcolors.dart';
import 'package:ngoni_pay/features/subscription/screens/subscription_payment_screen.dart';

class SubscriptionPlanScreen extends StatefulWidget {
  final int businessId;

  const SubscriptionPlanScreen({super.key, required this.businessId});

  @override
  State<SubscriptionPlanScreen> createState() => _SubscriptionPlanScreenState();
}

class _SubscriptionPlanScreenState extends State<SubscriptionPlanScreen> {
  String selectedPlan = 'free';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choisir un Abonnement"),
        backgroundColor: Kolors.kPrimary,
        foregroundColor: Kolors.kWhite,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            _planCard(
              key: "free",
              title: "Free",
              price: "0 FCFA",
              description: "Idéal pour démarrer",
              icon: Icons.card_giftcard,
              color: Kolors.kGray,
            ),
            const SizedBox(height: 16),
            _planCard(
              key: "basic",
              title: "Basic",
              price: "5 000 FCFA / mois",
              description: "Pour les petites entreprises",
              icon: Icons.business_center,
              color: Kolors.kBlue,
            ),
            const SizedBox(height: 16),
            _planCard(
              key: "pro",
              title: "Pro",
              price: "15 000 FCFA / an",
              description: "Pour les professionnels",
              icon: Icons.workspace_premium,
              color: Kolors.kGold,
            ),
            const SizedBox(height: 24),
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SubscriptionPaymentScreen(
                        businessId: widget.businessId,
                        plan: selectedPlan,
                      ),
                    ),
                  );
                },
                child: const Text(
                  "Continuer",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _planCard({
    required String key,
    required String title,
    required String price,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    final selected = selectedPlan == key;

    return GestureDetector(
      onTap: () => setState(() => selectedPlan = key),
      child: Container(
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.1) : Kolors.kWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? color : Kolors.kGrayLight,
            width: selected ? 3 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 32, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: selected ? color : Kolors.kDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    price,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: selected ? color : Kolors.kGray,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 13, color: Kolors.kGray),
                  ),
                ],
              ),
            ),
            if (selected)
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                child: const Icon(Icons.check, color: Kolors.kWhite, size: 20),
              ),
          ],
        ),
      ),
    );
  }
}
