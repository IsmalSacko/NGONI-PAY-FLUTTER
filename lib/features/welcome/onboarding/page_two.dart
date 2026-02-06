import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ngoni_pay/common/utils/app_style.dart';
import 'package:ngoni_pay/common/utils/kcolors.dart';
import 'package:ngoni_pay/common/utils/kstrings.dart';

class PageTwo extends StatelessWidget {
  const PageTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      foregroundDecoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Kolors.kWhite.withValues(alpha: 0.0),
            Kolors.kPrimary.withValues(alpha: 0.0),
          ],
        ),
      ),
      color: Kolors.kWhite,
      width: 1.sw,
      height: 1.sh,
      child: Stack(
        children: [
          Positioned(
            top: 100.h,
            left: 10.w,
            right: 10.w,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.asset(
                "assets/images/screen_2des.png",
                fit: BoxFit.contain,
              ),
            ),
          ),
          Positioned(
            bottom: 100.h,
            left: 10.w,
            right: 10.w,
            child: Text(
              AppText.kOnboardPaymentsMessage,
              textAlign: TextAlign.center,
              style: appStyle(14, Kolors.kGray, FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }
}
