import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ngoni_pay/common/utils/app_style.dart';
import 'package:ngoni_pay/common/utils/kcolors.dart';
import 'package:ngoni_pay/common/utils/kstrings.dart';
import 'package:ngoni_pay/common/utils/payment_method_label.dart';
import 'package:ngoni_pay/common/utils/widgets/error_banner.dart';
import 'package:ngoni_pay/features/businesses/services/business_service.dart';
import 'package:ngoni_pay/features/payment/controller/payment_list_controller.dart';
import 'package:ngoni_pay/features/subscription/controllers/subscription_controller.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FreeDashboardScreen extends StatefulWidget {
  const FreeDashboardScreen({super.key});

  @override
  State<FreeDashboardScreen> createState() => _FreeDashboardScreenState();
}

class _FreeDashboardScreenState extends State<FreeDashboardScreen>
    with WidgetsBindingObserver {
  int? _businessId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future.microtask(_bootstrap);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _bootstrap();
    }
  }

  Future<void> _bootstrap() async {
    final prefs = await SharedPreferences.getInstance();
    int? businessId = prefs.getInt('last_business_id');

    if (businessId != null) {
      try {
        await BusinessService.getBusiness(businessId);
      } catch (_) {
        businessId = null;
        await prefs.remove('last_business_id');
      }
    }

    if (businessId == null) {
      businessId = await BusinessService.getFirstBusinessId();
      if (businessId != null) {
        await prefs.setInt('last_business_id', businessId);
      }
    }

    if (!mounted) return;
    setState(() => _businessId = businessId);

    if (businessId != null) {
      await context.read<SubscriptionController>().loadSubscription(businessId);
      if (!mounted) return;
      final subscription =
          context.read<SubscriptionController>().subscription;
      if (subscription != null &&
          subscription.plan == 'free' &&
          subscription.isTrialActive) {
        context.go('/dashboard');
        return;
      }
      if (!mounted) return;
      await context.read<PaymentListController>().loadPayments(
        businessId: businessId,
      );
    }
  }

  Future<void> _goToPayments() async {
    if (_businessId == null) {
      context.go('/business/picker');
      return;
    }
    context.go('/payments/list/$_businessId');
  }

  Future<void> _goToCreatePayment() async {
    if (_businessId == null) {
      context.go('/business/picker');
      return;
    }
    context.go('/payments/create/$_businessId');
  }

  @override
  Widget build(BuildContext context) {
    if (_businessId == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Tableau de bord',
            style: appStyle(18, Kolors.kWhite, FontWeight.w600),
          ),
          elevation: 0,
          backgroundColor: Kolors.kPrimary,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.storefront_outlined,
                  size: 64,
                  color: Kolors.kPrimary,
                ),
                const SizedBox(height: 12),
                const Text(
                  "Aucune entreprise trouvée",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  "Pour démarrer un abonnement, vous devez d'abord créer une entreprise. L’abonnement dépend du businessId.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Kolors.kGray),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.go('/business/create'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Kolors.kPrimary,
                      foregroundColor: Kolors.kWhite,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Créer une entreprise"),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final paymentsController = context.watch<PaymentListController>();
    final subscription = context.watch<SubscriptionController>().subscription;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tableau de bord',
          style: appStyle(18, Kolors.kWhite, FontWeight.w600),
        ),
        elevation: 0,
        backgroundColor: Kolors.kPrimary,
      ),
      body: RefreshIndicator(
        onRefresh: _bootstrap,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Kolors.kPrimary, Kolors.kPrimaryLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: const Image(
                        image: AssetImage('assets/images/logo.png'),
                        height: 72,
                        width: 72,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Plan Free actif',
                            style: appStyle(16, Kolors.kWhite, FontWeight.w700),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Paiements en ligne désactivés. Enregistrez vos paiements et factures.',
                            style: appStyle(
                              12,
                              Kolors.kSecondaryLight,
                              FontWeight.w500,
                            ),
                          ),
                          if (subscription != null) ...[
                            const SizedBox(height: 6),
                            Text(
                              'Temps restant : ${_formatRemaining(subscription.trialEndsAt)}',
                              style: appStyle(
                                12,
                                Kolors.kSecondaryLight,
                                FontWeight.w600,
                              ),
                            ),
                          ],
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Kolors.kWhite.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'OFFLINE',
                              style: TextStyle(
                                color: Kolors.kWhite,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _ActionCard(
                      icon: Icons.payments_outlined,
                      label: AppText.kPayments,
                      onTap: _goToPayments,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionCard(
                      icon: Icons.receipt_long,
                      label: 'Factures',
                      onTap: _goToPayments,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _goToCreatePayment,
                  icon: const Icon(Icons.add),
                  label: const Text('Créer un paiement'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Kolors.kPrimary,
                    foregroundColor: Kolors.kWhite,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildRecentPayments(paymentsController),
            ],
          ),
        ),
      ),
    );
  }

  String _formatRemaining(DateTime? trialEnd) {
    if (trialEnd == null) return 'indisponible';
    final now = DateTime.now();
    if (!trialEnd.isAfter(now)) return 'expiré';
    final diff = trialEnd.difference(now);
    final totalMinutes = diff.inMinutes;
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    if (hours >= 24) {
      final days = hours ~/ 24;
      final remHours = hours % 24;
      return '${days}j ${remHours}h';
    }
    return '${hours}h ${minutes}m';
  }

  Widget _buildRecentPayments(PaymentListController controller) {
    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.error != null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Kolors.kWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Kolors.kGrayLight),
        ),
        child: ErrorBanner(message: controller.error!),
      );
    }

    if (controller.payments.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Kolors.kWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Kolors.kGrayLight),
        ),
        child: const Text('Aucun paiement récent.'),
      );
    }

    final recent = controller.payments.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '3 derniers paiements',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...recent.map((item) {
          final payment = item.payment;
          final isSuccess = payment.status == 'success';
          final amount =
              '${payment.amount.toStringAsFixed(0)} ${payment.currency == 'XOF' ? 'FCFA' : payment.currency}';

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Kolors.kWhite,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Kolors.kGrayLight),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        paymentMethodLabel(payment.method),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isSuccess ? 'Payé' : 'En attente',
                        style: TextStyle(
                          fontSize: 12,
                          color: isSuccess ? Kolors.kSuccess : Kolors.kGold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    amount,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: Kolors.kWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Kolors.kGrayLight),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Kolors.kSecondaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Kolors.kPrimary, size: 22),
            ),
            const SizedBox(height: 6),
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
