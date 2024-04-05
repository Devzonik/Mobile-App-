import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grow_x/core/common/functions.dart';
import 'package:grow_x/core/constants/firebase_collection_references.dart';
import 'package:grow_x/core/constants/instances_constants.dart';
import 'package:grow_x/core/utils/dialogs.dart';
import 'package:grow_x/core/utils/file_pickers/image_picker.dart';
import 'package:grow_x/core/utils/snackbars.dart';
import 'package:grow_x/models/user_models/user_model.dart';
import 'package:grow_x/models/user_models/user_stats_model.dart';
import 'package:grow_x/services/firebase/firebase_authentication.dart';
import 'package:grow_x/services/firebase/firebase_crud.dart';
import 'package:grow_x/services/firebase/firebase_storage.dart';
import 'package:grow_x/services/local_storage/local_storage.dart';
import 'package:grow_x/services/notification/notification.dart';
import 'package:grow_x/view/screens/auth/login.dart';
import 'package:grow_x/view/screens/bottom_nav_bar/persistent_nav_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class User2 {
  String? name;
  String? email;
  String? referralLink;
  String? referrerCode;
  int? level;
  String? phone;
  String uid;
  String? referrerId;

  User2({
    this.name,
    this.email,
    this.referralLink,
    this.referrerCode,
    this.level,
    this.phone,
    required this.uid,
    this.referrerId,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'referralLink': referralLink,
      'referrerCode': referrerCode,
      'level': level,
      'phone': phone,
      'uid': uid,
      'referrerId': referrerId,
    };
  }

  factory User2.fromMap(Map<String, dynamic> map) {
    return User2(
      name: map['name'],
      email: map['email'],
      referralLink: map['referralLink'],
      referrerCode: map['referrerCode'],
      level: map['level'],
      phone: map['phone'],
      uid: map['uid'],
      referrerId: map['referrerId'],
    );
  }
}

class SignUpController extends GetxController {
  // text editing controllers
  int level = 0;
  TextEditingController fullNameCtrlr = TextEditingController();
  TextEditingController emailCtrlr = TextEditingController();
  TextEditingController pwdCtrlr = TextEditingController();
  TextEditingController phoneNoCtrlr = TextEditingController();
  TextEditingController referralctrl = TextEditingController();

  RxString selectedPhoneCode = "".obs;
  final CollectionReference user2Collection =
      FirebaseFirestore.instance.collection('User2');
  RxBool isShowPwd = true.obs;
  RxBool isShowConfirmPwd = true.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> registerUser() async {
    try {
      // Create user in Firebase Authentication
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
        email: emailCtrlr.text.trim(),
        password: pwdCtrlr.text.trim(),
      );

      // Assign the UID from Authentication to the user model
      String uid = authResult.user!.uid;
      User2 newUser = User2(
        name: fullNameCtrlr.text.trim(),
        email: emailCtrlr.text.trim(),
        phone: phoneNoCtrlr.text.trim(),
        referralLink: '//link${uid}',
        referrerCode: referralctrl.text.trim(),
        uid: uid,
      );
      // Check if referral code is provided
      String referralCode = referralctrl.text.trim();
      log(referralCode);
      try {
        if (referralCode.isNotEmpty) {
          // Check if the referral code matches any existing user's referral link
          QuerySnapshot referralQuery = await user2Collection
              .where('referralLink', isEqualTo: referralCode)
              .get();
          log(referralCode);
          if (referralQuery.docs.isNotEmpty) {
            // Referral code exists, handle accordingly
            log('Referral code found: $referralCode');
            referralQuery.docs.forEach((DocumentSnapshot document) {
              log('User ID: ${document.id}, Data: ${document.data()}');
            });
            User2 user2 = User2.fromMap(
                referralQuery.docs.first.data() as Map<String, dynamic>);

            log(user2.uid);

            String referralUserId = user2.uid;
            int referralUserLevel = user2.level ?? 0;

            // Update the current user's level and referrer UID

            await user2Collection.doc(newUser.uid).set({
              'level': 0, // Set current user's level to 0
              'referrerUid': referralUserId,
              user2: newUser.toMap() // Set referrer UID to the found user's ID
            });

            // Update the referred user's level
            await user2Collection.doc(referralUserId).set({
              'level':
                  referralUserLevel + 1, // Increment the referred user's level
            });

            log('Referral levels updated successfully');
          } else {
            // Referral code does not exist
            log('Referral code not found: $referralCode');
          }
        } else {
          // Referral code is empty
          log('Referral code is empty');
        }
      } on Exception catch (e) {
        log('Error executing referral code query: $e');
        // TODO
      }

      CustomSnackBars.instance.showSuccessSnackbar(
        title: "Success",
        message: "Account created successfully!",
      );
      await user2Collection.doc(newUser.uid).set(newUser.toMap());
      log('User registered successfully!');
    } catch (e) {
      log('Error registering user: $e');
    }
  }

  // toggle password
  void togglePwdView() {
    isShowPwd.value = !isShowPwd.value;
  }

  // toggle confirm password
  void toggleConfirmPwdView() {
    isShowConfirmPwd.value = !isShowConfirmPwd.value;
  }

  // initializing user model
  Future<Map<String, dynamic>> initUserModel({
    required String userId,
  }) async {
    UserModel userModel = UserModel(
      userId: userId,
      name: fullNameCtrlr.text.trim(),
      email: emailCtrlr.text.trim(),
      phoneNo: '${selectedPhoneCode.value}${phoneNoCtrlr.text.trim()}',
      joinedOn: DateTime.now(),
      isShowNotification: true,
      referrercode: referralctrl.text.trim(),
      level: level,
      refferallink: '//link$userId',
    );

    return userModel.toJson();
  }

  // initializing UserStatsModel
  Map<String, dynamic> initUserStatsModel() {
    // getting userId
    String userId = FirebaseAuth.instance.currentUser!.uid;

    UserStatsModel userStatsModel = UserStatsModel(
      userId: userId,
      timeSpent: 0.0,
      avgSpeed: 0.0,
      totalDistance: 0.0,
      avgPulse: 0.0,
    );

    return userStatsModel.toJson();
  }

  Future<void> registerUser2({required BuildContext context}) async {
    try {
      DialogService.instance.showProgressDialog(context: context);

      FirebaseAuthService firebaseAuthService = Get.find<FirebaseAuthService>();
      String username = fullNameCtrlr.text.trim();
      //level = 1;
      String email = emailCtrlr.text.trim();
      String phone = phoneNoCtrlr.text.trim();
      String password = pwdCtrlr.text.trim();
      String referralink = "";
      String refferrercode = referralctrl.text.trim();
      String userid = "";
      log("STARRRRRRRT");
      // Check if data exists in Firestore
      QuerySnapshot querySnapshot = await users2Collection
          .where("referrallink", isEqualTo: refferrercode)
          .get();
      log("Referral searched");
      if (querySnapshot.docs.isNotEmpty) {
        log("Found");
        String documentId = querySnapshot.docs[0].id;
        // Use the document ID to get the value of "refferrercode"
        DocumentSnapshot documentSnapshot =
            await usersCollection.doc(documentId).get();
        // Get the value of "refferrercode"
        String refferrercodeValue = documentSnapshot["refferrercode"];
        log("$refferrercodeValue code");
        QuerySnapshot querySnapshot2 = await usersCollection
            .where("referrallink", isEqualTo: refferrercodeValue)
            .get();
        log("code search");
        if (querySnapshot.docs.isNotEmpty) {
          log("found");
          try {
            log("2nd level");
            // Sign in the user with email and password
            FirebaseAuthService firebaseAuthService =
                Get.find<FirebaseAuthService>();

            User? firebaseUser =
                await firebaseAuthService.signUpUsingEmailAndPassword(
              email: email,
              password: password,
            );

            userid = FirebaseAuth.instance.currentUser!.uid;
            level = 2;
            Map<String, dynamic> userMap = await initUserModel(
              userId: userid,
            );
            UserModel userModel = UserModel(
              userId: userid,
              name: fullNameCtrlr.text.trim(),
              email: emailCtrlr.text.trim(),
              phoneNo: '${selectedPhoneCode.value}${phoneNoCtrlr.text.trim()}',
              joinedOn: DateTime.now(),
              isShowNotification: true,
              referrercode: referralctrl.text.trim(),
              level: level,
              refferallink: '//link$userid',
            );
            bool isDocCreated =
                await FirebaseCRUDService.instance.createDocument(
              collectionReference: usersCollection,
              docId: userMap['userId'],
              data: userMap,
            );
            // await FirebaseFirestore.instance
            //     .collection("User2")
            //     .doc(userid)
            //     .set({
            //   "username": username,
            //   "level": 2,
            //   "email": email,
            //   "phone": phone,
            //   "referralLink": "//link$userid",
            //   "refferrerCode": refferrercode,
            //   "userid": userid,
            // });
            if (isDocCreated) {
              await LocalStorageService.instance
                  .write(key: "isRememberMe", value: true);

              CustomSnackBars.instance.showSuccessSnackbar(
                title: "Success",
                message: "Account created successfully!",
              );
              Navigator.pop(context);
              Get.to(() => Login());
            } else {
              Navigator.pop(context);
            }
            log("User data stored in Firestore!");
          } catch (e) {
            // Handle sign-in errors
            log("Error signing in: $e");
          }
        } else {
          try {
            // Sign in the user with email and password
            FirebaseAuthService firebaseAuthService =
                Get.find<FirebaseAuthService>();

            User? firebaseUser =
                await firebaseAuthService.signUpUsingEmailAndPassword(
              email: email,
              password: password,
            );
            // Get the user ID (UID)
            userid = FirebaseAuth.instance.currentUser!.uid;
            // Store user data in Firestore collection "Testing"
            level = 3;
            Map<String, dynamic> userMap = await initUserModel(
              userId: userid,
            );

            bool isDocCreated =
                await FirebaseCRUDService.instance.createDocument(
              collectionReference: usersCollection,
              docId: userMap['userId'],
              data: userMap,
            );
            if (isDocCreated) {
              await LocalStorageService.instance
                  .write(key: "isRememberMe", value: true);

              CustomSnackBars.instance.showSuccessSnackbar(
                title: "Success",
                message: "Account created successfully!",
              );
              Navigator.pop(context);
              Get.to(() => Login());
            } else {
              Navigator.pop(context);
            }
            log("User data stored in Firestore!");
          } catch (e) {
            // Handle sign-in errors
            log("Error signing in: $e");
          }
        }
      } else {
        // Data does not exist
        try {
          log("norma; else");
          // Sign in the user with email and password
          FirebaseAuthService firebaseAuthService =
              Get.find<FirebaseAuthService>();

          User? firebaseUser =
              await firebaseAuthService.signUpUsingEmailAndPassword(
            email: email,
            password: password,
          );
          // Get the user ID (UID)

          userid = FirebaseAuth.instance.currentUser!.uid;
          level = 1;
          Map<String, dynamic> userMap = await initUserModel(
            userId: userid,
            //  level: level
          );

          bool isDocCreated = await FirebaseCRUDService.instance.createDocument(
            collectionReference: usersCollection,
            docId: userMap['userId'],
            data: userMap,
          );
          if (isDocCreated) {
            await LocalStorageService.instance
                .write(key: "isRememberMe", value: true);

            CustomSnackBars.instance.showSuccessSnackbar(
              title: "Success",
              message: "Account created successfully!",
            );
            Navigator.pop(context);
            Get.to(() => Login());
          } else {
            Navigator.pop(context);
          }
          // Store user data in Firestore collection "Testing"
          // await FirebaseFirestore.instance.collection("User2").doc(userid).set({
          //   "username": username,
          //   "level": level,
          //   "email": email,
          //   "phone": phone,
          //   "referralLink": "//link$userid",
          //   "refferrerCode": "",
          //   "userid": userid,
          // });

          log("User data stored in Firestore!");
        } catch (e) {
          // Handle sign-in errors
          log("Error signing in: $e");
        }
      }
    } on Exception catch (e) {
      log("App Check error during user registration: $e");
      CustomSnackBars.instance.showFailureSnackbar(
        title: "Error",
        message: "Failed to create user account. Please try again.",
      );
    } finally {
      Navigator.pop(context);
    }
  }

  Future<bool> handleReferralLogic(String userId, String referralCode) async {
    // Logic to check if referralCode exists in user collection
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseCRUDService.instance.getDocumentsByField(
            collectionReference: FirebaseFirestore.instance.collection('User2'),
            fieldName: 'referrelLink',
            fieldValue: referralCode);
    log("App Check error during user registration: found");
    try {
      if (querySnapshot.docs.isNotEmpty) {
        // Referral code exists, update user data with referrer information
        Map<String, dynamic> referrerData = querySnapshot.docs.first.data();
        String referrerUid = referrerData['uid'];
        int referrerlevel = referrerData['level'] ?? 0;
        log("App Check error during user registration: found");
        // Update the user document with the referrer's information
        await FirebaseCRUDService.instance.updateDocument(
          collection: user2Collection,
          docId: userId,
          data: {'referrerCode': referralCode, 'referrerUid': referrerUid},
        );
        await FirebaseCRUDService.instance.updateDocument(
          collection: usersCollection,
          docId: referrerUid,
          data: {
            'level': referrerlevel + 1,
          },
        );

        // return true;
      } else {
        log("Referral code not found in users collection");
      }
    } on Exception catch (e) {
      // TODO
      log("Exception during getDocumentsByField: $e");
    }

    return true;
  }

  // Function to handle referral logic
  Future<void> handleReferralLogicreal(
      String newUserId, String referralCode) async {
    try {
      log("App Check error during user registration: start");

      log("App Check error during user registration: $referralCode");
      // Find the referrer using the unique identifier
      QuerySnapshot referrerQuery = await usersCollection
          .where('referrallink', isEqualTo: referralCode)
          .get();
      log("Referrer Query Result: $referrerQuery");
      log("App Check error during user registration: found");
      try {
        if (referrerQuery.docs.isNotEmpty) {
          log("App Check error during user registration: idset");
          String referrerUid = referrerQuery.docs.first.id;
          log("App Check error during user registration: idset");
          // Get the referrer's level
          int referrerLevel = referrerQuery.docs.first['level'] ?? 0;
          log("App Check error during user registration: level");

          // Limit the referral system to three levels

          // Register the new user and update the level
          await usersCollection.doc(newUserId).set({
            'referrerUid': referrerUid,
            'level': referrerLevel + 1, // Increase the level for the new user
            // Other user information...
          });
        } else {
          // Handle the case where the referral code is not valid
          CustomSnackBars.instance.showFailureSnackbar(
              title: 'Wrong Code', message: 'Make sure the code is right');
          // You can add additional logic or show a message as needed
        }
      } on Exception catch (e) {
        // TODO
      }
    } catch (e) {
      // Handle exceptions if needed
      log('Error handling referral logic: $e');
    }
  }

  Future<bool> handleReferralLogic2(
      String newUserId, String referralCode) async {
    try {
      // Find the referrer using the unique identifier
      QuerySnapshot referrerQuery = await usersCollection
          .where('referrallink', isEqualTo: referralCode)
          .get();

      if (referrerQuery.docs.isNotEmpty) {
        DocumentSnapshot referrerDoc = referrerQuery.docs.first;
        String referrerUid = referrerDoc.id;
        int referrerLevel = referrerDoc['level'] ?? 0;

        // Check if the referral code has already been used
        bool isCodeUsed = referrerDoc['isCodeUsed'] ?? false;

        if (isCodeUsed) {
          // Handle already used referral code
          CustomSnackBars.instance.showFailureSnackbar(
              title: 'Referral Code Used',
              message: 'The referral code entered has already been used.');
          return false; // Indicate that the account creation should not proceed
        }

        // Set the new user's level to 0
        await usersCollection.doc(newUserId).update({
          'referrerUid': referrerUid,
          'level': 0,
          // other user information...
        });

        // Check and update the referrer's level
        if (referrerLevel < 3) {
          await usersCollection.doc(referrerUid).update({
            'level': referrerLevel + 1,
          });
        } else {
          // If referrer is at level 3, start a new chain
          // Mark the referral code as used
          await usersCollection.doc(referrerUid).update({
            'isCodeUsed': true,
            // Potentially, issue a new referral code for a new chain
          });

          // When a referred user (e.g., User D) refers someone else (User E),
          // User D's level should be updated to 1 as the start of a new chain.
          // This logic should be part of the user referring someone else, not here.
        }

        // Optionally, handle commissions or other referral benefits here

        return true; // Indicate that the account creation can proceed
      } else {
        // Handle invalid referral code
        CustomSnackBars.instance.showFailureSnackbar(
            title: 'Invalid Referral Code',
            message: 'The referral code entered does not exist.');
        return false; // Indicate that the account creation should not proceed
      }
    } catch (e) {
      // Handle other exceptions if needed
      log('Error in referral logic: $e');

      // Handle other exceptions if needed
      return false; // Indicate that the account creation should not proceed
    }
  }
}
