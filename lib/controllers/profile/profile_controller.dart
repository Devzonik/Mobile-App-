import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grow_x/core/constants/firebase_collection_references.dart';
import 'package:grow_x/core/constants/instances_constants.dart';
import 'package:grow_x/core/utils/snackbars.dart';
import 'package:grow_x/services/firebase/firebase_authentication.dart';
import 'package:grow_x/services/firebase/firebase_crud.dart';

class ProfileController extends GetxController {
  //text editing controllers
  TextEditingController emailCtrlr = TextEditingController();
  TextEditingController pwdCtrlr = TextEditingController();
  TextEditingController newPwdCtrlr = TextEditingController();
  TextEditingController phoneCtrlr = TextEditingController();

  //booleans
  //flag to check user online status
  //RxBool isShowOnline = RxBool(userModelGlobal.value.isShowOnline!);

  //flag to check if the user notifications are on
  RxBool isShowNotification = RxBool(userModelGlobal.value.isShowNotification!);

  //flag to check if the email field is filled or not
  RxBool isEmailFilled = false.obs;

  //flag to check if the email is being updated
  RxBool isProfileUpdating = false.obs;

  //selection variables
  //RxString selectedPhoneCode = RxString(userModelGlobal.value.phoneCode!);

  //form keys for validation
  final emailFormKey = GlobalKey<FormState>();
  final pwdFormKey = GlobalKey<FormState>();

  //method to handle my online status
  Future<void> handleOnlineStatus() async {
    //  isShowOnline.value = !isShowOnline.value;

    //updating setting on Firebase
    // FirebaseCRUDService.instance.updateDocumentSingleKey(
    //   collection: usersCollection,
    //   docId: userModelGlobal.value.userId!,
    //   key: "isShowOnline",
    //   value: isShowOnline.value,
    // );
  }

  //method to handle show notification
  Future<void> handleShowNotification() async {
    // isShowNotification.value = !isShowNotification.value;

    // //updating setting on Firebase
    // FirebaseCRUDService.instance.updateDocumentSingleKey(
    //   collection: usersCollection,
    //   docId: userModelGlobal.value.userId!,
    //   key: "isShowNotification",
    //   value: isShowNotification.value,
    // );
  }

  //method to handle email field filling action
  void handleEmailFieldAction() {
    if (emailCtrlr.text.isNotEmpty) {
      isEmailFilled.value = true;
    } else if (emailCtrlr.text.isEmpty) {
      isEmailFilled.value = false;
    }
  }

  //method to update user phone
  Future<void> updateUserPhone() async {
    //indicating that email is being updated
    isProfileUpdating.value = true;

    //checking if the user is changing phone no
    if (phoneCtrlr.text.isNotEmpty) {
      //updating user phone no
      await FirebaseCRUDService.instance.updateDocument(
        collection: users2Collection,
        docId: userModelGlobal.value.userId!,
        data: {
          "phoneNo": phoneCtrlr.text,
          //   "phoneCode": selectedPhoneCode.value,
        },
      );

      //indicating that email is updated
      isProfileUpdating.value = false;

      CustomSnackBars.instance.showSuccessSnackbar(
          title: "Phone Updated", message: "Phone updated successfully");
    }
  }

  //method to update user email on firebase
  Future<void> updateUserEmail() async {
    //indicating that email is being updated
    isProfileUpdating.value = true;

    //checking if the user is changing email
    if (emailCtrlr.text.isNotEmpty) {
      //updating user email
      await FirebaseAuthService.instance.changeFirebaseEmail(
        email: userModelGlobal.value.email!,
        password: pwdCtrlr.text,
        newEmail: emailCtrlr.text,
      );
    }

    //indicating that email is updated
    isProfileUpdating.value = false;
  }

  //method to change Firebase password
  Future<void> updateUserPassword() async {
    await FirebaseAuthService.instance.changeFirebasePassword(
      email: userModelGlobal.value.email!,
      oldPassword: pwdCtrlr.text,
      newPassword: newPwdCtrlr.text,
    );
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();

    emailCtrlr.dispose();
    pwdCtrlr.dispose();
    phoneCtrlr.dispose();
    newPwdCtrlr.dispose();
  }
}
