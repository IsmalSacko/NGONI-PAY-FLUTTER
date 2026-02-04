import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ngoni_pay/common/utils/app_style.dart';
import 'package:ngoni_pay/common/utils/kcolors.dart';
import 'package:ngoni_pay/common/utils/kstrings.dart';
import 'package:ngoni_pay/common/utils/payment_method_label.dart';
import 'package:ngoni_pay/features/businesses/controllers/stats_controller.dart';
import 'package:ngoni_pay/features/businesses/services/business_service.dart';
import 'package:ngoni_pay/features/dashboard/stats/daily/daily_screen.dart';
import 'package:ngoni_pay/features/payment/controller/payment_list_controller.dart';
import 'package:ngoni_pay/features/subscription/controllers/subscription_controller.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ngoni_pay/features/dashboard/widgets_personal_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with WidgetsBindingObserver {
  int selectedDays = 1;
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

    if (businessId == null) {
      businessId = await BusinessService.getFirstBusinessId();
      if (businessId != null) {
        await prefs.setInt('last_business_id', businessId);
      }
    }

    _businessId = businessId;
    if (businessId == null) return;

    final subscriptionController = context.read<SubscriptionController>();
    await subscriptionController.loadSubscription(businessId);
    if (!mounted) return;

    final subscription = subscriptionController.subscription;
    if (subscription == null || !subscription.isActive) {
      context.go('/subscription/$businessId');
      return;
    }
    if (subscription.plan == 'free') {
      context.go('/dashboard/free');
      return;
    }

    await context
        .read<PaymentListController>()
        .loadPayments(businessId: businessId);

    final statsController = context.read<StatsController>();
    statsController.loadStats(businessId);
    statsController.loadDailyStats(businessId: businessId);
  }

  void _onPeriodSelected(int days) {
    if (_businessId == null) return;
    setState(() => selectedDays = days);
    context.read<StatsController>().loadDailyStats(
      businessId: _businessId!,
      days: days,
    );
  }

  Future<int?> _getBusinessId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('last_business_id');
  }

  Future<void> _goToPaymentsOrPicker() async {
    final businessId = await _getBusinessId();
    if (!context.mounted) return;
    context.go(
      businessId != null ? '/payments/list/$businessId' : '/business/picker',
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PaymentListController>();
    final statsController = context.watch<StatsController>();

    if (_businessId == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

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
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
            color: Kolors.kWhite,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _bootstrap,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildSummary(statsController),
              const SizedBox(height: 12),
              _buildPeriodChips(),
              _buildDailySection(statsController),
              const SizedBox(height: 24),
              _buildQuickActions(),
              const SizedBox(height: 32),
              _buildRecentTransactions(controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Kolors.kPrimary,
            Kolors.kPrimaryLight,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
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
                const Text(
                  AppText.kWelcome,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Kolors.kWhite,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  AppText.kBalanceDescription,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Kolors.kSecondaryLight,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Kolors.kWhite.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'TABLEAU PRO',
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
    );
  }

  Widget _buildSummary(StatsController statsController) {
    final total = statsController.stats?.last7Days.toStringAsFixed(0) ?? '0';
    return Column(
      children: [
        Center(
          child: Text(
            '7 derniers jours',
            style: appStyle(16, Kolors.kGray, FontWeight.w500),
          ),
        ),
        Center(
          child: Text(
            'Total : $total FCFA',
            style: appStyle(18, Kolors.kBlue, FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildPeriodChips() {
    return Row(
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
    );
  }

  Widget _buildDailySection(StatsController statsController) {
    if (statsController.isLoadingDaily) {
      return const Center(child: CircularProgressIndicator());
    }

    if (selectedDays == 1) {
      return TodaySummary(
        dailyStats: statsController.dailyStats,
        businessId: _businessId!,
      );
    }

    if (statsController.dailyStats.isEmpty) {
      return const Center(child: Text('Aucune donnée'));
    }

    return RevenueLineChart(data: statsController.dailyStats);
  }

  Widget _buildQuickActions() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 360;
        if (isNarrow) {
          return Column(
            children: [
              ActionButton(
                expanded: false,
                icon: Icons.payments_outlined,
                label: 'Encaisser',
                onTap: () => context.go('/business/picker'),
              ),
              const SizedBox(height: 12),
              ActionButton(
                expanded: false,
                icon: Icons.payment,
                label: AppText.kPayments,
                onTap: _goToPaymentsOrPicker,
              ),
              const SizedBox(height: 12),
              ActionButton(
                expanded: false,
                icon: Icons.receipt_long,
                label: AppText.kTransactions,
                onTap: _goToPaymentsOrPicker,
              ),
            ],
          );
        }
        return Row(
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
              onTap: _goToPaymentsOrPicker,
            ),
            const SizedBox(width: 16),
            ActionButton(
              icon: Icons.receipt_long,
              label: AppText.kTransactions,
              onTap: _goToPaymentsOrPicker,
            ),
          ],
        );
      },
    );
  }

  Widget _buildRecentTransactions(PaymentListController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppText.kRecentTransactions,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextButton(
              onPressed: _goToPaymentsOrPicker,
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
            final currency =
                item.payment.currency == 'XOF' ? 'FCFA' : item.payment.currency;

            return TransactionTile(
              title: 'Paiement ${paymentMethodLabel(item.payment.method)}',
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
    );
  }
}
