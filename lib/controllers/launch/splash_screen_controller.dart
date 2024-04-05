import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:grow_x/controllers/auth/login_controller.dart';
import 'package:grow_x/core/common/functions.dart';
import 'package:grow_x/core/constants/firebase_collection_references.dart';
import 'package:grow_x/services/firebase/firebase_crud.dart';
import 'package:grow_x/services/local_storage/local_storage.dart';
import 'package:grow_x/view/screens/auth/login.dart';
import 'package:grow_x/view/screens/auth/signup.dart';
import 'package:grow_x/view/screens/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:grow_x/view/screens/bottom_nav_bar/persistent_nav_bar.dart';

class SplashScreenController extends GetxController {
  //method to save in local storage that the uses is onboarded
  Future<void> userOnboarded() async {
    await LocalStorageService.instance.write(key: "isOnboarded", value: true);
  }

  //method to check if the user has tunred on remember me
  Future<bool> isUserRemembered() async {
    return await LocalStorageService.instance.read(key: "isRememberMe") ??
        false;
  }

  //method to check if the user is onboarded or not
  Future<bool> isUserOnboarded() async {
    return await LocalStorageService.instance.read(key: "isOnboarded") ?? false;
  }

  //method to update user geohash
  Future<void> updateUserGeohash() async {
    //getting user id
    String uid = FirebaseAuth.instance.currentUser!.uid;

    //getting user geohash
    // Map _userGeohash = await Get.find<LoginController>().getUserGeohash();

    // if (_userGeohash.isNotEmpty) {
    //   await FirebaseCRUDService.instance.updateDocumentSingleKey(
    //     collection: usersCollection,
    //     docId: uid,
    //     key: "geoHash",
    //     value: _userGeohash,
    //   );
  }

  void splashScreenHandler() async {
    if (FirebaseAuth.instance.currentUser != null) {
      // User is logged in
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Update user geohash
      await updateUserGeohash();

      // Navigate to the BottomNavBar
      Get.offAll(() => PersistentBottomNavBar());
    } else {
      // User is not logged in or not remembered
      Timer(
        Duration(milliseconds: 2400),
        () => Get.offAll(() => Login()),
      );
    }
  }
}
