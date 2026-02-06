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
    return Container(
      foregroundDecoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Kolors.kWhite.withValues(alpha: 0.4),
            Kolors.kWhite.withValues(alpha: 0.1),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Décaler l'image vers le haut
          Positioned(
            top: 100.h,
            left: 10.w,
            right: 10.w,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.asset(
                "assets/images/ngoni_screen1.png",
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Texte et bouton en bas
          Positioned(
            bottom:
                70, // Ajustez cette valeur pour la position verticale du texte et du bouton
            left: 30,
            right: 30,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppText.kWelcomeHeader,
                  textAlign: TextAlign.center,
                  style: appStyle(22, Kolors.kPrimary, FontWeight.bold),
                ),
                Text(
                  AppText.kWelcomeMessage,
                  textAlign: TextAlign.center,
                  style: appStyle(13, Kolors.kGray, FontWeight.normal),
                ),
                SizedBox(height: 10.h),
                GradientBtn(
                  text: AppText.kGetStarted,
                  btnColor: Kolors.kPrimary,
                  btnHieght: 40.h,
                  radius: 20,
                  btnWidth: ScreenUtil().screenWidth - 100,
                  onTap: () {
                    //Storage().setBool('Open', true);
                    context.go('/auth/register');
                  },
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ReusableText(
                      text: AppText.kAlreadyAccount,
                      style: appStyle(13, Kolors.kGray, FontWeight.normal),
                    ),
                    TextButton(
                      onPressed: () {
                        context.go('/auth/login');
                      },
                      child: const Text(
                        AppText.kLogin,
                        style: TextStyle(
                          fontSize: 13,
                          color: Kolors.kBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
