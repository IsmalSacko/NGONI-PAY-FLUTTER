import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ngoni_pay/common/utils/kcolors.dart';
import 'package:ngoni_pay/common/utils/kstrings.dart';
import 'package:ngoni_pay/features/payment/controller/payment_list_controller.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PaymentListController>();

    Future.microtask(() async {
      final prefs = await SharedPreferences.getInstance();
      final businessId = prefs.getInt('last_business_id');

      if (businessId != null && controller.payments.isEmpty) {
        controller.loadPayments(businessId);
      }
    });

    if (controller.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (controller.error != null) {
      return Scaffold(
        body: Center(
          child: Text(
            controller.error!,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppText.kDashboardTitle),
        elevation: 0,
        backgroundColor: Kolors.kPrimary,
        titleTextStyle: TextStyle(
          fontSize: 24,
          color: Kolors.kWhite,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
            color: Kolors.kWhite,
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 👋 WELCOME
            Text(
              '${AppText.kWelcome},',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            Text(
              AppText.kAppName,
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            const SizedBox(height: 24),

            // 💰 BALANCE CARD
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Kolors.kWhite,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    AppText.kBalance,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Kolors.kDark),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${controller.totalAmountSuccess.toStringAsFixed(0)} FCFA',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Kolors.kSuccess,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ⚡ QUICK ACTIONS
            Row(
              children: [
                // FOR INITIATING A NEW PAYMENT
                _ActionButton(
                  icon: Icons.payments_outlined,
                  label: 'Encaisser',
                  onTap: () {
                    context.go('/business/picker');
                  },
                ),
                const SizedBox(width: 16),
                // FOR VIEWING PAYMENTS LIST
                _ActionButton(
                  icon: Icons.payment,
                  label: AppText.kPayments,
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    final businessId = prefs.getInt('last_business_id');

                    if (!context.mounted) return;

                    if (businessId != null) {
                      context.go('/payments/list/$businessId');
                    } else {
                      context.go('/business/picker');
                    }
                  },
                ),
                // FOR VIEWING TRANSACTIONS LIST
                const SizedBox(width: 16),
                _ActionButton(
                  icon: Icons.receipt_long,
                  label: AppText.kTransactions,
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    final businessId = prefs.getInt('last_business_id');

                    if (!context.mounted) return;

                    if (businessId != null) {
                      context.go('/payments/list/$businessId');
                    } else {
                      context.go('/business/picker');
                    }
                  },
                ),
              ],
            ),

            const SizedBox(height: 32),

            // 📄 RECENT TRANSACTIONS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppText.kRecentTransactions,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    final businessId = prefs.getInt('last_business_id');

                    if (!context.mounted) return;

                    if (businessId != null) {
                      context.go('/payments/list/$businessId');
                    } else {
                      context.go('/business/picker');
                    }
                  },
                  child: const Text(AppText.kViewAll),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Column(
              children: controller.recentPayments.map((item) {
                final isSuccess = item.payment.status == 'success';
                final isPending = item.payment.status == 'pending';
                final sign = isSuccess ? '+' : '-';

                final currencySymbol = item.payment.currency == 'XOF'
                    ? 'FCFA'
                    : item.payment.currency;

                return _TransactionTile(
                  title:
                      'Paiement ${item.payment.method == 'cash'
                          ? 'Espèces'
                          : item.payment.method == 'orange_money'
                          ? 'Orange Money'
                          : item.payment.method == 'moov_money'
                          ? 'Moov Money'
                          : item.payment.method == 'wave'
                          ? 'Wave'
                          : item.payment.method == 'paypal'
                          ? 'PayPal'
                          : item.payment.method == 'credit_card'
                          ? 'Carte Bancaire'
                          : 'Autre Méthode'}',
                  amount:
                      '$sign${item.payment.amount.toStringAsFixed(0)} $currencySymbol',

                  status: isSuccess
                      ? AppText.kStatusSuccess
                      : isPending
                      ? AppText.kStatusPending
                      : AppText.kStatusFailed,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// =========================
// 🔘 ACTION BUTTON
// =========================
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Kolors.kWhite,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(icon, color: Kolors.kPrimary, size: 28),
              const SizedBox(height: 8),
              Text(label, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}

// =========================
// 🧾 TRANSACTION TILE
// =========================
class _TransactionTile extends StatelessWidget {
  final String title;
  final String amount;
  final String status;

  const _TransactionTile({
    required this.title,
    required this.amount,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final isSuccess = status == AppText.kStatusSuccess;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Kolors.kWhite,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 4),
              Text(
                status,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isSuccess ? Kolors.kSuccess : Kolors.kGold,
                ),
              ),
            ],
          ),
          Text(
            amount,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
