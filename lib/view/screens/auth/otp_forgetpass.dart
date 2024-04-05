import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grow_x/constants/app_colors.dart';
import 'package:grow_x/constants/app_fonts.dart';
import 'package:grow_x/constants/app_strings.dart';
import 'package:grow_x/generated/assets.dart';
import 'package:grow_x/view/screens/auth/forget_pass.dart';
import 'package:grow_x/view/widgets/common_image_view_widget.dart';
import 'package:grow_x/view/widgets/my_text_widget.dart';

import '../../widgets/my_text_field.dart';

class OTPForgetPass extends StatelessWidget {
  const OTPForgetPass({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 15),
                physics: const BouncingScrollPhysics(),
                children: [
                  CommonImageView(
                    imagePath: Assets.imagesLogo,
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                  Center(
                    child: MyText(
                      text: hwelcome,
                      size: 18,
                      paddingTop: 16,
                      weight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  Center(
                    child: MyText(
                      text: shotp,
                      size: 12,
                    ),
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyText(
                          text: '+123 000000',
                          size: 12,
                          paddingBottom: 30,
                          weight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                  // Container(
                  //   width: 93,
                  //   decoration: circle(kSecondaryColor.withOpacity(0.5),
                  //       kSecondaryColor.withOpacity(0.3)),
                  //   child: CircularPercentIndicator(
                  //     radius: 47.0,
                  //     lineWidth: 10.0,
                  //     percent: 0.25,
                  //     center: MyText(
                  //       size: 22,
                  //       text: '25',
                  //     ),
                  //     backgroundColor: kSecondaryColor.withOpacity(0.3),
                  //     progressColor: kSecondaryColor,
                  //   ),
                  // ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 38, child: MyTextField()),
                      const SizedBox(
                        width: 16,
                      ),
                      SizedBox(width: 38, child: MyTextField()),
                      const SizedBox(
                        width: 16,
                      ),
                      SizedBox(width: 38, child: MyTextField()),
                      const SizedBox(
                        width: 16,
                      ),
                      SizedBox(width: 38, child: MyTextField()),
                    ],
                  ),
                  const SizedBox(
                    height: 17,
                  ),
                  Center(
                    child: RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: rResentcode,
                          style: TextStyle(
                              color: kTertiaryColor,
                              fontFamily: AppFonts.MONTSERRAT,
                              fontSize: 12)),
                      TextSpan(
                          text: rsendagain,
                          style: TextStyle(
                              color: kTertiaryColor,
                              fontFamily: AppFonts.MONTSERRAT,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                          recognizer: TapGestureRecognizer()
                            ..onTap =
                                () => Get.to(() => const ForgetPassword()))
                    ])),
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
