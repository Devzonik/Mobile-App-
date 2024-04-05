import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grow_x/core/common/functions.dart';
import 'package:grow_x/core/constants/firebase_collection_references.dart';
import 'package:grow_x/core/utils/dialogs.dart';
import 'package:grow_x/core/utils/snackbars.dart';
import 'package:grow_x/services/firebase/firebase_crud.dart';
import 'package:grow_x/services/local_storage/local_storage.dart';
import 'package:grow_x/services/notification/notification.dart';
import 'package:grow_x/view/screens/auth/login.dart';
import 'package:grow_x/view/screens/bottom_nav_bar/persistent_nav_bar.dart';

class LoginController extends GetxController {
  //text editing controllers
  TextEditingController emailCtrlr = TextEditingController();
  TextEditingController pwdCtrlr = TextEditingController();

  //booleans
  //password visibility
  RxBool isShowPwd = true.obs;
  RxBool isRememberMe = true.obs;

  //toggle password
  void togglePwdView() {
    isShowPwd.value = !isShowPwd.value;
  }

  //toggle remember me
  void toggleRememberMe() {
    isRememberMe.value = !isRememberMe.value;
  }

  // //method to get user geohash
  // Future<Map> getUserGeohash() async {
  //   Map userGeoHash = {};

  //   //getting user location
  //   Position? userLocation = await GoogleMapsService.instance.getUserLocation();

  //   //creating user geohash
  //   if (userLocation != null) {
  //     //creating user position latLng
  //     LatLng userLatLng = LatLng(userLocation.latitude, userLocation.longitude);

  //     //getting user location geo hash
  //     userGeoHash =
  //         await GoogleMapsService.instance.createGeoHash(latLng: userLatLng);
  //   }

  //   return userGeoHash;
  // }

  //logging in user with email and password
  Future<void> loginUserWithEmailAndPassword(
      {required BuildContext context}) async {
    // Show progress dialog
    DialogService.instance.showProgressDialog(context: context);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailCtrlr.text, password: pwdCtrlr.text);

      if (FirebaseAuth.instance.currentUser == null) {
        // Handle scenario where user is not signed in
      }

      if (FirebaseAuth.instance.currentUser != null) {
        String deviceToken =
            await NotificationService.instance.getDeviceToken();
        String uid = FirebaseAuth.instance.currentUser!.uid;

        // Update user device token and email
        await FirebaseCRUDService.instance
            .updateDocument(collection: users2Collection, docId: uid, data: {
          "deviceToken": deviceToken,
          "email": emailCtrlr.text,
        });

        DocumentSnapshot? userDoc =
            await FirebaseCRUDService.instance.readSingleDocument(
          collectionReference: users2Collection,
          docId: uid,
        );

        if (userDoc != null) {
          String status = userDoc.get("status");

          if (status == "block") {
            // User is blocked, show error message and redirect to login page
            Navigator.pop(context);
            CustomSnackBars.instance.showFailureSnackbar(
                title: 'Authentication Error',
                message: 'Your account is blocked');
            Get.offAll(() => Login());
            return;
          }
        }
      }
      Navigator.pop(context);

      //showing success snackbar
      CustomSnackBars.instance.showSuccessSnackbar(
          title: 'Success', message: 'Authenticated successfully');

      //navigating user accordingly (if he has not filled any additional info)
      Get.offAll(
        () => PersistentBottomNavBar(),
      );
      // if (isAdditionalInfoFilled) {

      //   // //deleting unuseful controllers
      //   // Get.delete<SignUpController>();
      //   // Get.delete<FirebaseAuthService>();
      //   // Get.delete<SplashScreenController>();
      //   // Get.delete<LoginController>();
      // } else {
      //   Get.offAll(
      //     () => Login(),
      //   );
      // }
    } on FirebaseAuthException catch (e) {
      //popping progress indicator
      Navigator.pop(context);

      //showing failure snackbar
      CustomSnackBars.instance.showFailureSnackbar(
          title: 'Authentication Error', message: "${e.message}");
    } on FirebaseException catch (e) {
      //popping progress indicator
      Navigator.pop(context);

      //showing failure snackbar
      CustomSnackBars.instance.showFailureSnackbar(
          title: 'Authentication Error', message: "${e.message}");
    } catch (e) {
      log("This was the exception while logging in user: $e");
    }
  }

  @override
  void onClose() {
    // TODO: implement dispose
    super.onClose();

    emailCtrlr.dispose();
    pwdCtrlr.dispose();

    log("onClose called");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
