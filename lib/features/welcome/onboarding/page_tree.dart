import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ngoni_pay/common/utils/app_style.dart';
import 'package:ngoni_pay/common/utils/kcolors.dart';
import 'package:ngoni_pay/common/utils/kstrings.dart';

class PageThree extends StatelessWidget {
  const PageThree({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLandscape = constraints.maxWidth > constraints.maxHeight;
        final image = ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Image.asset(
            "assets/images/screen_image_2.png",
            fit: BoxFit.contain,
          ),
        );
        final message = Text(
          AppText.kOnboardHome,
          textAlign: TextAlign.center,
          style: appStyle(14, Kolors.kGray, FontWeight.normal),
        );

        return Container(
          foregroundDecoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Kolors.kWhite.withValues(alpha: 0.0),
                Kolors.kWhite.withValues(alpha: 0.0),
              ],
            ),
          ),
          color: Kolors.kWhite,
          width: 1.sw,
          height: 1.sh,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: isLandscape ? 8.h : 20.h,
              ),
              child: isLandscape
                  ? Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Center(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: constraints.maxHeight * 0.9,
                              ),
                              child: image,
                            ),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(flex: 2, child: message),
                      ],
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: Center(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: constraints.maxHeight * 0.6,
                              ),
                              child: image,
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        message,
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}
