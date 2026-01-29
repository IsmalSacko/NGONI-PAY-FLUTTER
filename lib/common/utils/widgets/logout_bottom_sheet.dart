import 'package:go_router/go_router.dart';
import 'package:ngoni_pay/const/constants.dart';
import 'package:ngoni_pay/core/storage/secure_storage.dart';

import '../../../common/utils/kcolors.dart';
import '../../../common/utils/kstrings.dart';
import '../app_style.dart';
import 'package:ngoni_pay/common/utils/widgets/custom_button.dart';
import 'package:ngoni_pay/common/utils/widgets/reusable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<dynamic> logoutBottomSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 200,
        decoration: BoxDecoration(borderRadius: kRadiusTop),
        child: ListView(
          children: [
            SizedBox(height: 10.h),
            Center(
              child: ReusableText(
                text: AppText.kLogout,
                style: appStyle(16, Kolors.kPrimary, FontWeight.w500),
              ),
            ),
            SizedBox(height: 10.h),
            Divider(color: Kolors.kGrayLight, thickness: 0.5.h),
            SizedBox(height: 10.h),
            Center(
              child: ReusableText(
                text: AppText.kLogoutConfirm,
                style: appStyle(14, Kolors.kGray, FontWeight.w500),
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GradientBtn(
                    text: AppText.kCancel,
                    borderColor: Kolors.kDark,
                    btnColor: Kolors.kWhite,
                    onTap: () => Navigator.pop(context),
                    btnHieght: 35.h,
                    radius: 16,
                    btnWidth: ScreenUtil().screenWidth / 2.2,
                  ),
                   GradientBtn(
                    text: AppText.kLogout,
                    onTap: () async {
                      // Fermer la bottom sheet d'abord
                      Navigator.of(context).pop();
                      
                      // Supprimer le token
                      await SecureStorage.clearToken();
                      
                      // Attendre un peu pour que le contexte soit stable
                      await Future.delayed(const Duration(milliseconds: 100));
                      
                      // Rediriger vers login
                      if (context.mounted) {
                        GoRouter.of(context).go('/auth/login');
                      }
                    },
                    btnHieght: 35.h,
                    radius: 16,
                    btnWidth: ScreenUtil().screenWidth / 2.2,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
