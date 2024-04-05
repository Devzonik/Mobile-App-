import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grow_x/view/screens/auth/create_new_password.dart';
import 'package:grow_x/view/widgets/my_button.dart';
import 'package:grow_x/view/widgets/my_text_widget.dart';

class SendOTPAgain extends StatelessWidget {
  const SendOTPAgain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
              physics: const BouncingScrollPhysics(),
              children: [
                const SizedBox(
                  height: 57,
                ),
                Center(
                  child: MyText(
                    text: 'Wrong OTP',
                    size: 20,
                    fontFamily: 'montb',
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Center(
                  child: MyText(
                    text:
                        "Don't worry! It occurs. Please click the button to send code again..",
                    size: 12,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 109,
                ),
                MyButton(
                  buttonText: 'SEND THE CODE AGAIN',
                  onTap: () {
                    Get.to(() => const CreateNewPass());
                  },
                  isactive: false,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
