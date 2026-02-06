import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ngoni_pay/common/utils/app_style.dart';
import 'package:ngoni_pay/common/utils/kcolors.dart';
import 'package:ngoni_pay/common/utils/kstrings.dart';
import 'package:ngoni_pay/common/utils/widgets/custom_button.dart';
import 'package:ngoni_pay/common/utils/widgets/reusable_text.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLandscape = constraints.maxWidth > constraints.maxHeight;
        final image = ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: AspectRatio(
            aspectRatio: isLandscape ? 4 / 5 : 3 / 4,
            child: Image.asset(
              "assets/images/ngoni_screen1.png",
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
        );
        final titleSize = isLandscape ? 18.0 : 22.0;
        final bodySize = isLandscape ? 12.0 : 13.0;
        final content = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppText.kWelcomeHeader,
              textAlign: TextAlign.center,
              style: appStyle(titleSize, Kolors.kPrimary, FontWeight.bold),
            ),
            Text(
              AppText.kWelcomeMessage,
              textAlign: TextAlign.center,
              style: appStyle(bodySize, Kolors.kGray, FontWeight.normal),
            ),
            SizedBox(height: 10.h),
            GradientBtn(
              text: AppText.kGetStarted,
              btnColor: Kolors.kPrimary,
              btnHieght: 40.h,
              radius: 20,
              btnWidth: (ScreenUtil().screenWidth - 100)
                  .clamp(isLandscape ? 150 : 180, isLandscape ? 260 : 320)
                  .toDouble(),
              onTap: () {
                //Storage().setBool('Open', true);
                context.go('/auth/register');
              },
            ),
            SizedBox(height: 10.h),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 6,
              runSpacing: 4,
              children: [
                ReusableText(
                  text: AppText.kAlreadyAccount,
                  style: appStyle(bodySize, Kolors.kGray, FontWeight.normal),
                ),
                TextButton(
                  onPressed: () {
                    context.go('/auth/login');
                  },
                  child: Text(
                    AppText.kLogin,
                    style: TextStyle(
                      fontSize: bodySize,
                      color: Kolors.kPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
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
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: isLandscape ? 8.h : 20.h,
              ),
              child: SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: isLandscape
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Center(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxHeight: constraints.maxHeight * 0.85,
                                ),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: image,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            flex: 2,
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 12.h),
                                child: content,
                              ),
                            ),
                          ),
                        ],
                      )
                    : SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            Center(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxHeight: constraints.maxHeight * 0.6,
                                ),
                                child: image,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: content,
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
