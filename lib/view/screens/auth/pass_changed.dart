import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grow_x/constants/app_strings.dart';
import 'package:grow_x/generated/assets.dart';
import 'package:grow_x/view/screens/auth/login.dart';
import 'package:grow_x/view/widgets/common_image_view_widget.dart';
import 'package:grow_x/view/widgets/my_button.dart';
import 'package:grow_x/view/widgets/my_text_widget.dart';

class PassChanged extends StatelessWidget {
  const PassChanged({super.key});

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
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                physics: const BouncingScrollPhysics(),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.arrow_back_ios),
                      CommonImageView(
                        imagePath: Assets.imagesLogo,
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                      Container(
                        width: 41,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  // Center(
                  //   child: CommonImageView(
                  //     imagePath: Assets.imagesChanged,
                  //     height: 56,
                  //   ),
                  // ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: MyText(
                      text: hpasschanged,
                      size: 20,
                      weight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Center(
                    child: SizedBox(
                      width: Get.width * 0.8,
                      child: MyText(
                        text: shchanged,
                        size: 12,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  MyButton(
                      buttonText: bbacktologin,
                      onTap: () {
                        Get.to(() => Login());
                      })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
