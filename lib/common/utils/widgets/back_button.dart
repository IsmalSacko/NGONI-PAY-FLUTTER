import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:ngoni_pay/common/utils/kcolors.dart';
import 'package:ngoni_pay/core/storage/secure_storage.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key, this.color, this.size, this.onTap});

  final Color? color;
  final double? size;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          onTap ??
          () async {
            if (GoRouter.of(context).canPop()) {
              GoRouter.of(context).pop();
            } else if (await isAuthenticated()) {
              GoRouter.of(context).go('/dashboard');
            } else {
              // Si on ne peut pas pop, aller à l'accueil
              GoRouter.of(context).go('/welcome');
            }
          },
      child: Icon(
        AntDesign.leftcircle,
        color: color ?? Kolors.kPrimary,
        size: size ?? 28,
      ),
    );
  }
}

Future<bool> isAuthenticated() async {
  final token = await SecureStorage.getToken();
  return token != null && token.isNotEmpty;
}
