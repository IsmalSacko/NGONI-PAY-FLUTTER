// =========================
// 🔘 ACTION BUTTON
// =========================
import 'package:flutter/material.dart';
import 'package:ngoni_pay/common/utils/kcolors.dart';
import 'package:ngoni_pay/common/utils/kstrings.dart';
import 'package:ngoni_pay/features/transactions/transactions_screen.dart';

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool expanded;

  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    final content = InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: expanded ? null : double.infinity,
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
    );

    return expanded ? Expanded(child: content) : content;
  }
}

// =========================
// 🧾 TRANSACTION TILE
// =========================
class TransactionTile extends StatelessWidget {
  final String title;
  final String amount;
  final String status;

  const TransactionTile({
    super.key,
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  status,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class StatsCards extends StatelessWidget {
  final dynamic stats;

  const StatsCards({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 360;
        if (isNarrow) {
          return Column(
            children: [
              _StatCard(
                expanded: false,
                title: 'Payés',
                amount: stats.totalSuccess,
                count: stats.countSuccess,
                color: Colors.green,
                icon: Icons.check_circle,
              ),
              const SizedBox(height: 12),
              _StatCard(
                expanded: false,
                title: 'En attente',
                amount: stats.totalPending,
                count: stats.countPending,
                color: Colors.orange,
                icon: Icons.hourglass_bottom,
              ),
              const SizedBox(height: 12),
              _StatCard(
                expanded: false,
                title: 'Échecs',
                amount: stats.totalFailed,
                count: stats.countFailed,
                color: Colors.red,
                icon: Icons.cancel,
              ),
            ],
          );
        }

        return Row(
          children: [
            _StatCard(
              title: 'Payés',
              amount: stats.totalSuccess,
              count: stats.countSuccess,
              color: Colors.green,
              icon: Icons.check_circle,
            ),
            const SizedBox(width: 12),
            _StatCard(
              title: 'En attente',
              amount: stats.totalPending,
              count: stats.countPending,
              color: Colors.orange,
              icon: Icons.hourglass_bottom,
            ),
            const SizedBox(width: 12),
            _StatCard(
              title: 'Échecs',
              amount: stats.totalFailed,
              count: stats.countFailed,
              color: Colors.red,
              icon: Icons.cancel,
            ),
          ],
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final double amount;
  final int count;
  final Color color;
  final IconData icon;
  final bool expanded;

  const _StatCard({
    required this.title,
    required this.amount,
    required this.count,
    required this.color,
    required this.icon,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    final content = Container(
      width: expanded ? null : double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 13)),
          const SizedBox(height: 6),
          Text(
            '${amount.toStringAsFixed(0)} FCFA',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$count transactions',
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );

    return expanded ? Expanded(child: content) : content;
  }
}

class PeriodChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const PeriodChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Kolors.kPrimary : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Kolors.kDark,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class TodaySummary extends StatelessWidget {
  final List dailyStats;
  final int businessId;

  const TodaySummary({
    super.key,
    required this.dailyStats,
    required this.businessId,
  });

  @override
  Widget build(BuildContext context) {
    final amount = dailyStats.isNotEmpty ? dailyStats.first.amount : 0.0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TransactionsScreen(
              businessId: businessId,
              date: DateTime.now(), // 👈 aujourd’hui
            ),
          ),
        );
      },
      child: Column(
        children: [
          const SizedBox(height: 16),
          const Icon(Icons.trending_up, size: 36, color: Colors.green),
          const SizedBox(height: 8),
          Text(
            '+ ${amount.toStringAsFixed(0)} FCFA',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Kolors.kSuccess,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text('Aujourd’hui'),
        ],
      ),
    );
  }
}
