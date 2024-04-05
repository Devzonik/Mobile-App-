import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grow_x/constants/app_colors.dart';
import 'package:grow_x/constants/app_sizes.dart';
import 'package:grow_x/constants/app_strings.dart';
import 'package:grow_x/controllers/auth/forget_pass_controller.dart';
import 'package:grow_x/core/utils/validators.dart';
import 'package:grow_x/generated/assets.dart';
import 'package:grow_x/view/screens/auth/create_new_password.dart';
import 'package:grow_x/view/screens/auth/signup.dart';
import 'package:grow_x/view/widgets/common_image_view_widget.dart';
import 'package:grow_x/view/widgets/my_button.dart';
import 'package:grow_x/view/widgets/my_text_field.dart';
import 'package:grow_x/view/widgets/my_text_widget.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final ForgetPasswordController controller2 =
      Get.find<ForgetPasswordController>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            signupWaveBackground(),
            Padding(
              padding: AppSizes.DEFAULT_PADDING,
              child: Column(children: [
                Row(
                  children: [
                    InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Icon(Icons.arrow_back_ios)),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    MyText(
                      text: hforgot,
                      size: 20,
                      weight: FontWeight.bold,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: MyText(
                        text: shforgot,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: MyText(
                        paddingTop: 16,
                        paddingBottom: 8,
                        text: hemail,
                      ),
                    ),
                  ],
                ),
                MyTextField(
                  validator: ValidationService.instance.emailValidator,
                  controller: controller2.emailCtrlr,
                  onChanged: (value) {
                    // Trim leading and trailing spaces
                    controller2.emailCtrlr.text = value.trim();
                  },
                  hintText: 'youremail@gmail.com',
                ),
                const SizedBox(
                  height: 10,
                ),
                MyButton(
                  buttonText: 'Reset',
                  onTap: () {
                    controller2.resetPassword();
                  },
                  //  fillColor: kPrimaryColor,
                  isactive: false,
                  borderColor: kSecondaryColor,
                )
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
