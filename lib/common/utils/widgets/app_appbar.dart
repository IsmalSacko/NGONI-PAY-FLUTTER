import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ngoni_pay/common/utils/app_style.dart';
import 'package:ngoni_pay/common/utils/kcolors.dart';
import 'package:ngoni_pay/features/businesses/business_model.dart';
import 'package:ngoni_pay/features/businesses/business_service.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBusinessAction;
  final IconButton? actions;

  const AppAppBar({
    super.key,
    required this.title,
    this.showBusinessAction = true,
    this.actions,
  });

  Future<BusinessModel?> _loadActiveBusiness() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('last_business_id');

    if (id == null) return null;

    return BusinessService.getBusiness(id);
  }

  Future<void> _handleBusinessAction(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final lastBusinessId = prefs.getInt('last_business_id');

    if (!context.mounted) return;

    context.go(
      lastBusinessId != null
          ? '/payments/create/$lastBusinessId'
          : '/business/picker',
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Kolors.kPrimary,
      elevation: 0,
      title: Text(title, style: appStyle(24, Kolors.kWhite, FontWeight.bold)),
      actions: showBusinessAction
          ? [
              FutureBuilder<BusinessModel?>(
                future: _loadActiveBusiness(),
                builder: (context, snapshot) {
                  final business = snapshot.data;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: TextButton.icon(
                      onPressed: () => _handleBusinessAction(context),
                      icon: const Icon(
                        Icons.check_circle_outline, // ✅ icône recommandée
                        color: Kolors.kGreen,
                        size: 30,
                      ),
                      label: Text(
                        business?.name ?? 'Choisir un business',
                        overflow: TextOverflow.ellipsis,
                        style: appStyle(14, Kolors.kWhite, FontWeight.w600),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: Kolors.kWhite,
                      ),
                    ),
                  );
                },
              ),
            ]
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
