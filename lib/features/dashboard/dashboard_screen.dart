import 'package:flutter/material.dart';
import 'package:ngoni_pay/common/utils/kcolors.dart';
import 'package:ngoni_pay/common/utils/kstrings.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppText.kDashboardTitle),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
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
              'NGNONI PAY',
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            const SizedBox(height: 24),

            // 💰 BALANCE CARD
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Kolors.kPrimary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppText.kBalance,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Kolors.kWhite),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '250 000 FCFA',
                    style: Theme.of(
                      context,
                    ).textTheme.headlineLarge?.copyWith(color: Kolors.kWhite),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ⚡ QUICK ACTIONS
            Row(
              children: [
                _ActionButton(
                  icon: Icons.send,
                  label: AppText.kNewPayment,
                  onTap: () {},
                ),
                const SizedBox(width: 16),
                _ActionButton(
                  icon: Icons.receipt_long,
                  label: AppText.kTransactions,
                  onTap: () {},
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
                  onPressed: () {},
                  child: const Text(AppText.kViewAll),
                ),
              ],
            ),

            const SizedBox(height: 12),

            _TransactionTile(
              title: 'Paiement Orange Money',
              amount: '-25 000 FCFA',
              status: AppText.kStatusSuccess,
            ),
            _TransactionTile(
              title: 'Paiement MTN MoMo',
              amount: '-10 000 FCFA',
              status: AppText.kStatusPending,
            ),
            _TransactionTile(
              title: 'Recharge compte',
              amount: '+50 000 FCFA',
              status: AppText.kStatusSuccess,
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
