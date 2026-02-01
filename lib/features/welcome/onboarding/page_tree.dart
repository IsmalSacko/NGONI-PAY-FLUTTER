import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ngoni_pay/common/utils/app_style.dart';
import 'package:ngoni_pay/common/utils/kcolors.dart';
import 'package:ngoni_pay/common/utils/kstrings.dart';

class PageThree extends StatelessWidget {
  const PageThree({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1.sw,
      height: 1.sh,
      child: Stack(
        children: [
          Positioned(
            top: 100.h,
            left: 30.w,
            right: 30.w,
            child: Image.asset(
              "assets/images/screen_image.png",
              fit: BoxFit.contain,
              height: 0.5.sh,
            ),
          ),
          Positioned(
            bottom: 100.h,
            left: 30.w,
            right: 30.w,
            child: Text(
              AppText.kOnboardHome,
              textAlign: TextAlign.center,
              style: appStyle(14, Kolors.kGray, FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }
}
