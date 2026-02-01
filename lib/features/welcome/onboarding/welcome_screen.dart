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
    return Scaffold(
      body: SizedBox(
        width: ScreenUtil().screenWidth,
        height: ScreenUtil().screenHeight,
        child: Stack(
          children: [
            // Décaler l'image vers le haut
            Positioned(
              top:
                  70, // Ajustez cette valeur pour la position verticale de l'image
              left: 30,
              right: 30,
              child: Center(
                child: Image.asset(
                  "assets/images/screen_des.png",
                  width:
                      ScreenUtil().screenWidth *
                      0.6, // Ajustez la taille de l'image
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
                    style: appStyle(12, Kolors.kGray, FontWeight.normal),
                  ),
                  SizedBox(height: 10.h),
                  GradientBtn(
                    text: AppText.kGetStarted,
                    btnHieght: 40.h,
                    radius: 20,
                    btnWidth: ScreenUtil().screenWidth - 100,
                    onTap: () {
                      //Storage().setBool('Open', true);
                      context.go('/welcome');
                    },
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ReusableText(
                        text: "Already have an account ?",
                        style: appStyle(12, Kolors.kGray, FontWeight.normal),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Sign In",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF1A73E8),
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
      ),
    );
  }
}
