import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grow_x/constants/app_colors.dart';
import 'package:grow_x/constants/app_sizes.dart';
import 'package:grow_x/constants/app_strings.dart';
import 'package:grow_x/generated/assets.dart';
import 'package:grow_x/view/screens/auth/pass_changed.dart';
import 'package:grow_x/view/widgets/common_image_view_widget.dart';
import 'package:grow_x/view/widgets/my_button.dart';
import 'package:grow_x/view/widgets/my_text_field.dart';
import 'package:grow_x/view/widgets/my_text_widget.dart';

class CreateNewPass extends StatelessWidget {
  const CreateNewPass({super.key});

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
                padding: AppSizes.DEFAULT_PADDING,
                physics: const BouncingScrollPhysics(),
                children: [
                  Center(
                    child: CommonImageView(
                      imagePath: Assets.imagesLogo,
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  MyText(
                    text: hchangepass,
                    size: 20,
                    weight: FontWeight.bold,
                    paddingBottom: 8,
                  ),
                  MyText(
                    text: shchangepass,
                    size: 12,
                    paddingBottom: 10,
                  ),
                  MyText(
                    text: tfchangepass,
                    paddingBottom: 8,
                  ),
                  MyTextField(
                    isObSecure: true,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  MyText(
                    text: tfconfirmnewpass,
                    paddingBottom: 8,
                  ),
                  MyTextField(
                    // suffixIcon: Icon(
                    //   Icons.remove_red_eye_outlined,
                    //   color: kTertiaryColor,
                    //   weight: 2,
                    // ),
                    isObSecure: true,
                  ),
                  const SizedBox(
                    height: 9,
                  ),
                  MyButton(
                      buttonText: bchagepass,
                      onTap: () {
                        Get.to(() => const PassChanged());
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
