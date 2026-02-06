import 'package:flutter/material.dart';
import 'package:ngoni_pay/common/utils/kcolors.dart';
import 'package:ngoni_pay/features/subscription/controllers/subscription_controller.dart';
import 'package:ngoni_pay/features/subscription/screens/subscription_success_screen.dart';
import 'package:ngoni_pay/common/utils/payment_method_label.dart';
import 'package:ngoni_pay/common/utils/widgets/error_banner.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class SubscriptionPaymentScreen extends StatefulWidget {
  final int businessId;
  final String plan;

  const SubscriptionPaymentScreen({
    super.key,
    required this.businessId,
    required this.plan,
  });

  @override
  State<SubscriptionPaymentScreen> createState() =>
      _SubscriptionPaymentScreenState();
}

class _SubscriptionPaymentScreenState extends State<SubscriptionPaymentScreen> {
  String _method = 'orange_money';
  String? _uiError;

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

    final currentPlan = planDetails[widget.plan] ?? planDetails['free']!;
    final imagePath = 'assets/images/subscription_${widget.plan}.png';

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
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
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
            if (widget.plan != 'free') ...[
              Text(
                'Méthode de paiement',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _method,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'cash',
                    child: Text('Espèces'),
                  ),
                  DropdownMenuItem(
                    value: 'orange_money',
                    child: Text('Orange Money'),
                  ),
                  DropdownMenuItem(
                    value: 'moov_money',
                    child: Text('Moov Money'),
                  ),
                  DropdownMenuItem(
                    value: 'wave',
                    child: Text('Wave'),
                  ),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _method = value);
                },
              ),
              const SizedBox(height: 12),
              Text(
                'Méthode sélectionnée : ${paymentMethodLabel(_method)}',
                style: const TextStyle(fontSize: 12, color: Kolors.kGray),
              ),
              const SizedBox(height: 20),
            ],
            if (_uiError != null || controller.error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ErrorBanner(message: _uiError ?? controller.error!),
              ),
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
                        setState(() => _uiError = null);
                        final result = await controller.createSubscription(
                          businessId: widget.businessId,
                          plan: widget.plan,
                          method: widget.plan == 'free' ? null : _method,
                        );

                        if (!context.mounted) return;

                        if (result == null) {
                          setState(() {
                            _uiError =
                                controller.error ?? 'Une erreur est survenue';
                          });
                          return;
                        }

                        if (widget.plan != 'free' &&
                            result.checkoutUrl != null &&
                            result.checkoutUrl!.isNotEmpty) {
                          context.push(
                            '/payments/checkout',
                            extra: {
                              'checkoutUrl': result.checkoutUrl,
                              'businessId': widget.businessId,
                              'paymentId': result.paymentId,
                              'successRoute': '/dashboard',
                            },
                          );
                          return;
                        }

                        if (result.subscription != null) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SubscriptionSuccessScreen(),
                            ),
                          );
                          return;
                        }
                        setState(() {
                          _uiError =
                              'Impossible de lancer le paiement abonnement.';
                        });
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
