import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ngoni_pay/common/utils/kcolors.dart';
import 'package:ngoni_pay/common/utils/kstrings.dart';
import 'package:ngoni_pay/common/utils/widgets/custom_button.dart';

import '../../../const/constants.dart';

Future<dynamic> submitBottomSheet({
  required BuildContext context,
  required VoidCallback onSubmit,
  String? submitText,
}) {
  return showModalBottomSheet<void>(
    context: context,
    shape: RoundedRectangleBorder(borderRadius: kRadiusTop),
    builder: (_) {
      return Container(
        height: 150.h,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
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
                  text: submitText ?? AppText.kSubmit,
                  onTap: () {
                    Navigator.pop(context);
                    onSubmit();
                  },
                  btnHieght: 35.h,
                  radius: 16,
                  btnWidth: ScreenUtil().screenWidth / 2.2,
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
