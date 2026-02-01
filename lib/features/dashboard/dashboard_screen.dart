import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ngoni_pay/common/utils/app_style.dart';
import 'package:ngoni_pay/common/utils/kcolors.dart';
import 'package:ngoni_pay/common/utils/kstrings.dart';
import 'package:ngoni_pay/features/businesses/controllers/stats_controller.dart';
import 'package:ngoni_pay/features/businesses/services/business_service.dart';
import 'package:ngoni_pay/features/dashboard/stats/daily/daily_screen.dart';
import 'package:ngoni_pay/features/payment/controller/payment_list_controller.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ngoni_pay/features/dashboard/widgets_personal_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedDays = 1;
  int? _businessId;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final prefs = await SharedPreferences.getInstance();
      int? businessId = prefs.getInt('last_business_id');

      // 🟢 FALLBACK après réinstallation
      if (businessId == null) {
        businessId = await BusinessService.getFirstBusinessId();
        if (businessId != null) {
          await prefs.setInt('last_business_id', businessId);
        }
      }

      _businessId = businessId;

      if (businessId != null) {
        await context.read<PaymentListController>().loadPayments(
          businessId: businessId,
        );

        final statsController = context.read<StatsController>();
        statsController.loadStats(businessId);
        statsController.loadDailyStats(businessId: businessId);
      }
    });
  }

  // PÉRIODE SÉLECTIONNÉE (Method)
  void _onPeriodSelected(int days) {
    if (_businessId == null) return;

    setState(() => selectedDays = days);

    context.read<StatsController>().loadDailyStats(
      businessId: _businessId!,
      days: days,
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PaymentListController>();
    final statsController = context.watch<StatsController>();
    //final data = statsController.dailyStats;

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
        titleTextStyle: const TextStyle(
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
                children: [
                  // Text(
                  //   AppText.kBalance,
                  //   style: Theme.of(
                  //     context,
                  //   ).textTheme.bodyMedium?.copyWith(color: Kolors.kDark),
                  // ),
                  // const SizedBox(height: 8),
                  // Text(
                  //   '${controller.totalAmountSuccess.toStringAsFixed(0)} FCFA',
                  //   style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  //     color: Kolors.kSuccess,
                  //     fontWeight: FontWeight.w600,
                  //   ),
                  // ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                '7 derniers jours',
                style: appStyle(16, Kolors.kGray, FontWeight.w500),
              ),
            ),
            Center(
              child: Text(
                'Total : ${statsController.stats?.last7Days.toStringAsFixed(0)} FCFA',
                style: appStyle(16, Kolors.kPrimary, FontWeight.w500),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PeriodChip(
                  label: 'Aujourd’hui',
                  selected: selectedDays == 1,
                  onTap: () => _onPeriodSelected(1),
                ),
                const SizedBox(width: 8),
                PeriodChip(
                  label: '7 jours',
                  selected: selectedDays == 7,
                  onTap: () => _onPeriodSelected(7),
                ),
                const SizedBox(width: 8),
                PeriodChip(
                  label: '30 jours',
                  selected: selectedDays == 30,
                  onTap: () => _onPeriodSelected(30),
                ),
              ],
            ),

            // ✅ CORRECTION ICI
            if (statsController.isLoadingDaily)
              const Center(child: CircularProgressIndicator())
            // 👉 CAS AUJOURD’HUI
            else if (selectedDays == 1)
              TodaySummary(
                dailyStats: statsController.dailyStats,
                businessId: _businessId!,
              )
            // 👉 CAS 7 / 30 JOURS
            else if (statsController.dailyStats.isEmpty)
              const Center(child: Text('Aucune donnée'))
            else
              RevenueLineChart(data: statsController.dailyStats),

            const SizedBox(height: 24),

            // ⚡ QUICK ACTIONS
            Row(
              children: [
                ActionButton(
                  icon: Icons.payments_outlined,
                  label: 'Encaisser',
                  onTap: () => context.go('/business/picker'),
                ),
                const SizedBox(width: 16),
                ActionButton(
                  icon: Icons.payment,
                  label: AppText.kPayments,
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    final businessId = prefs.getInt('last_business_id');
                    if (!context.mounted) return;

                    context.go(
                      businessId != null
                          ? '/payments/list/$businessId'
                          : '/business/picker',
                    );
                  },
                ),
                const SizedBox(width: 16),
                ActionButton(
                  icon: Icons.receipt_long,
                  label: AppText.kTransactions,
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    final businessId = prefs.getInt('last_business_id');
                    if (!context.mounted) return;

                    context.go(
                      businessId != null
                          ? '/payments/list/$businessId'
                          : '/business/picker',
                    );
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

                    context.go(
                      businessId != null
                          ? '/payments/list/$businessId'
                          : '/business/picker',
                    );
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
                final currency = item.payment.currency == 'XOF'
                    ? 'FCFA'
                    : item.payment.currency;

                return TransactionTile(
                  title: 'Paiement ${item.payment.method}',
                  amount:
                      '$sign${item.payment.amount.toStringAsFixed(0)} $currency',
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
