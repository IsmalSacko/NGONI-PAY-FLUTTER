import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ngoni_pay/common/utils/app_style.dart';
import 'package:ngoni_pay/common/utils/kstrings.dart';
import 'package:ngoni_pay/common/utils/widgets/back_button.dart';
import 'package:ngoni_pay/common/utils/widgets/error_banner.dart';
import 'package:ngoni_pay/features/auth/auth_service.dart';
import 'package:ngoni_pay/features/businesses/services/business_service.dart';
import 'package:ngoni_pay/features/subscription/controllers/subscription_controller.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile_controller.dart';
import '../../common/utils/kcolors.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  int? _businessId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ProfileController>().loadProfile();
      _bootstrapSubscription();
    });
  }

  Future<void> _bootstrapSubscription() async {
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

    _businessId = businessId;
    if (businessId == null) return;

    if (!mounted) return;
    await context.read<SubscriptionController>().loadSubscription(businessId);
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ProfileController>();
    final subscription = context.watch<SubscriptionController>().subscription;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Profil'),
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: AppBackButton(color: Kolors.kWhite),
        ),
        backgroundColor: Kolors.kPrimary,
        titleTextStyle: appStyle(24, Kolors.kWhite, FontWeight.bold),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton(
              icon: const Icon(Icons.logout),
              color: Kolors.kWhite,
              style: IconButton.styleFrom(
                backgroundColor: Kolors.kPrimary.withValues(alpha: 100),
                iconSize: 30,
              ),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('last_business_id');
                await AuthService().logout();
                if (!mounted) return;
                context.go('/auth/login');
              },
            ),
          ),
        ],
      ),
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : controller.error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ErrorBanner(message: controller.error!),
              ),
            )
          : controller.user == null
          ? const SizedBox.shrink()
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Header avec avatar
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Kolors.kPrimary, Kolors.kPrimaryLight],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Kolors.kWhite.withValues(
                            alpha: 0.15,
                          ),
                          child: CircleAvatar(
                            radius: 46,
                            backgroundColor: Colors.white,
                            backgroundImage:
                                controller.user!.avatarUrl != null &&
                                        controller.user!.avatarUrl!.isNotEmpty
                                    ? NetworkImage(
                                        controller.user!.avatarUrl!,
                                      )
                                    : null,
                            child: (controller.user!.avatarUrl == null ||
                                    controller.user!.avatarUrl!.isEmpty)
                                ? Text(
                                    controller.user!.name.isNotEmpty
                                        ? controller.user!.name[0]
                                            .toUpperCase()
                                        : '?',
                                    style: const TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: Kolors.kPrimary,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          controller.user!.email ?? 'Pas d\'email',
                          style: appStyle(20, Kolors.kWhite, FontWeight.w600),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Kolors.kWhite.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            controller.user!.role == 'owner'
                                ? AppText.kRoleOwner
                                : AppText.kRoleStaff,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Kolors.kWhite,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Informations
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        if (subscription != null)
                          _subscriptionCard(context, subscription),
                        _itemCard(
                          Icons.person,
                          AppText.kPkAppName,
                          controller.user!.name,
                        ),
                        _itemCard(
                          Icons.phone,
                          AppText.kTelephone,
                          controller.user!.phone,
                        ),
                        if (controller.user!.email != null)
                          _itemCard(
                            Icons.email,
                            AppText.kEmail,
                            controller.user!.email!,
                          ),
                        _itemCard(
                          Icons.calendar_today,
                          'Compte créé le',
                          controller.user!.createdAt.toLocal().toString().split(
                            ' ',
                          )[0],
                        ),
                        const SizedBox(height: 30),
                        // Bouton Se déconnecter
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              //auth/update-profile
                              context.push('/me/edit');
                              //logoutBottomSheet(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Kolors.kPrimary,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              AppText.kEditProfile,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget item(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _itemCard(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Kolors.kPrimary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Kolors.kPrimary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _subscriptionCard(BuildContext context, subscription) {
    final plan = subscription.plan.toString().toUpperCase();
    final isActive = subscription.isActive == true;
    final endsAt = subscription.endsAt != null
        ? subscription.endsAt.toLocal().toString().split(' ')[0]
        : '-';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Kolors.kPrimary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Kolors.kPrimary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Abonnement',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Chip(
                label: Text(plan),
                backgroundColor: Kolors.kPrimary.withValues(alpha: 0.12),
              ),
              const SizedBox(width: 8),
              Chip(
                label: Text(isActive ? 'Actif' : 'Inactif'),
                backgroundColor:
                    (isActive ? Kolors.kSuccess : Kolors.kGold)
                        .withValues(alpha: 0.12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('Fin : $endsAt', style: appStyle(12, Kolors.kGray, FontWeight.w500)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width < 360
                    ? double.infinity
                    : (MediaQuery.of(context).size.width - 64) / 2,
                child: OutlinedButton(
                  onPressed: _businessId == null
                      ? null
                      : () => context.go('/subscription/$_businessId'),
                  child: const Text('Gérer l’abonnement'),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width < 360
                    ? double.infinity
                    : (MediaQuery.of(context).size.width - 64) / 2,
                child: ElevatedButton(
                  onPressed: _businessId == null
                      ? null
                      : () async {
                          final ok = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Passer au Free'),
                              content: const Text(
                                'Votre abonnement Basic/Pro sera arrêté et vous passerez au plan Free.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text('Annuler'),
                                ),
                                ElevatedButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text('Confirmer'),
                                ),
                              ],
                            ),
                          );

                          if (ok != true || !mounted) return;

                          await context
                              .read<SubscriptionController>()
                              .createSubscription(
                                businessId: _businessId!,
                                plan: 'free',
                              );

                          await context
                              .read<SubscriptionController>()
                              .loadSubscription(_businessId!);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Kolors.kPrimary,
                  ),
                  child: const Text(
                    'Plan Free',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
