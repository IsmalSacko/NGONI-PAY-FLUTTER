import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ngoni_pay/common/utils/app_style.dart';
import 'package:ngoni_pay/common/utils/kstrings.dart';
import 'package:ngoni_pay/common/utils/widgets/back_button.dart';
import 'package:ngoni_pay/core/storage/secure_storage.dart';
import 'package:provider/provider.dart';
import 'profile_controller.dart';
import '../../common/utils/kcolors.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileController>().loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ProfileController>();

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
              onPressed: () {
                SecureStorage.clearToken();
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
              child: Text(
                controller.error!,
                style: const TextStyle(color: Colors.red),
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
                      color: Colors.grey[50],
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
                          backgroundColor: Kolors.kPrimary.withValues(
                            alpha: 100,
                          ),
                          child: CircleAvatar(
                            radius: 48,
                            backgroundColor: Colors.white,
                            child: Text(
                              controller.user!.name.isNotEmpty
                                  ? controller.user!.name[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Kolors.kPrimary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          controller.user!.email ?? 'Pas d\'email',
                          style: appStyle(22, Kolors.kDark, FontWeight.w600),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Kolors.kPrimary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            controller.user!.role == 'owner'
                                ? AppText.kRoleOwner
                                : AppText.kRoleStaff,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Kolors.kPrimary,
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
}
