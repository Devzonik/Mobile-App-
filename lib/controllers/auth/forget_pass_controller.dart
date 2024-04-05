import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grow_x/core/utils/snackbars.dart';

class ForgetPasswordController extends GetxController {
  TextEditingController emailCtrlr = TextEditingController();
  TextEditingController pwdCtrlr = TextEditingController();
  TextEditingController phonectrl = TextEditingController();

  Future<void> resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailCtrlr.text.trim(),
      );

      // Handle success (email sent) here if needed
      CustomSnackBars.instance.showSuccessSnackbar(
        title: 'Reset Link Sent',
        message:
            'Check your registered email address to find the password reset link',
      );

      resetParams();
      Get.back();
    } catch (error) {
      // Handle errors here
      if (error is FirebaseAuthException) {
        switch (error.code) {
          case 'user-not-found':
            CustomSnackBars.instance.showFailureSnackbar(
              title: 'Password Reset Error',
              message: 'User not found. Please check the email address.',
            );
            break;
          case 'invalid-email':
            CustomSnackBars.instance.showFailureSnackbar(
              title: 'Password Reset Error',
              message: 'The email address is not valid.',
            );
            break;
          // Add more cases to handle other error codes as needed

          default:
            // Handle generic error
            CustomSnackBars.instance.showFailureSnackbar(
              title: 'Password Reset Error',
              message: 'An error occurred during password reset.',
            );
        }
      } else {
        // Handle other types of errors if needed
      }
    }
  }

  void resetParams() {
    emailCtrlr.clear();
    pwdCtrlr.clear();
    phonectrl.clear();
  }
}
