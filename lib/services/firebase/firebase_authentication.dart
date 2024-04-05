import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grow_x/core/constants/firebase_collection_references.dart';
import 'package:grow_x/core/utils/snackbars.dart';
import 'package:grow_x/services/firebase/firebase_crud.dart';
import 'package:grow_x/view/screens/auth/login.dart';

class FirebaseAuthService extends GetxController {
  static FirebaseAuthService get instance => FirebaseAuthService();

  //signing up user with email and password
  Future<User?> signUpUsingEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      if (FirebaseAuth.instance.currentUser != null) {
        User user = FirebaseAuth.instance.currentUser!;

        return user;
      }
      if (FirebaseAuth.instance.currentUser == null) {
        return null;
      }
    } on FirebaseAuthException catch (e) {
      //showing failure snackbar
      CustomSnackBars.instance.showFailureSnackbar(
          title: 'Authentication Error', message: '${e.message}');

      return null;
    } on FirebaseException catch (e) {
      //showing failure snackbar
      CustomSnackBars.instance.showFailureSnackbar(
          title: 'Authentication Error', message: '${e.message}');

      return null;
    } catch (e) {
      log("This was the exception while signing up: $e");

      return null;
    }

    return null;
  }

  //method to check if the user's account already exists on firebase
  Future<bool> isAlreadyExist({required String uid}) async {
    DocumentSnapshot? userData = await FirebaseCRUDService.instance
        .readSingleDocument(
            collectionReference: FirebaseFirestore.instance.collection('User2'),
            docId: uid);

    //if the user data is not null, it means the document already exists
    if (userData != null) {
      return true;
    }
    //it means the user data doesn't exist
    else {
      return false;
    }
  }

  //method to authenticate with google account
  Future<(User?, GoogleSignInAccount?, bool)> authWithGoogle() async {
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // TODO: Use the `credential` to sign in with Firebase.
      await FirebaseAuth.instance.signInWithCredential(credential);
      if (FirebaseAuth.instance.currentUser == null) {
        return (null, null, false);
      }

      if (FirebaseAuth.instance.currentUser != null) {
        User user = FirebaseAuth.instance.currentUser!;

        //checking if the user's account already exists on firebase
        bool isExist = await isAlreadyExist(uid: user.uid);

        return (user, googleUser, isExist);
      }
    } on FirebaseAuthException catch (e) {
      //showing failure snackbar
      CustomSnackBars.instance.showFailureSnackbar(
          title: 'Authentication Error', message: '${e.message}');

      return (null, null, false);
    } on FirebaseException catch (e) {
      //showing failure snackbar
      CustomSnackBars.instance.showFailureSnackbar(
          title: 'Authentication Error', message: '${e.message}');

      return (null, null, false);
    } catch (e) {
      log("This was the exception while signing up: $e");

      return (null, null, false);
    }

    return (null, null, false);
  }

  //reAuthenticating user to confirm if the same user is requesting
  Future<void> changeFirebaseEmail(
      {required String email,
      required String password,
      required String newEmail}) async {
    try {
      final User user = await FirebaseAuth.instance.currentUser!;

      final cred =
          EmailAuthProvider.credential(email: email, password: password);

      await user.reauthenticateWithCredential(cred).then((value) async {
        await user.verifyBeforeUpdateEmail(newEmail);

        CustomSnackBars.instance.showSuccessSnackbar(
          title: "Vefification Link Sent",
          message:
              "We have sent you a verification email, please update your email by verifying from the link",
          duration: 6,
        );

        //logging out user (so that we can update his email on the Firebase when he logs in again)
        await FirebaseAuth.instance.signOut();

        //navigating back to Login Screen
        Get.offAll(() => Login());
      }).onError((error, stackTrace) {
        CustomSnackBars.instance
            .showFailureSnackbar(title: 'Error', message: '$error');
      });
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          CustomSnackBars.instance
              .showFailureSnackbar(title: 'Error', message: 'User not found');
          break;
        case 'wrong-password':
          CustomSnackBars.instance
              .showFailureSnackbar(title: 'Error', message: 'Wrong password');
          break;
        case 'invalid-email':
          CustomSnackBars.instance
              .showFailureSnackbar(title: 'Error', message: 'Invalid email');
          break;
        case 'email-already-in-use':
          CustomSnackBars.instance.showFailureSnackbar(
              title: 'Error', message: 'Email already in use');
          break;
        default:
          CustomSnackBars.instance.showFailureSnackbar(
              title: 'Retry', message: 'Something went wrong');
          break;
      }
    }
  }

  //method to change Firebase password
  Future<void> changeFirebasePassword({
    required String email,
    required String oldPassword,
    required String newPassword,
  }) async {
    final user = await FirebaseAuth.instance.currentUser;
    final cred =
        EmailAuthProvider.credential(email: email, password: oldPassword);

    try {
      user!.reauthenticateWithCredential(cred).then((value) {
        user.updatePassword(newPassword).then((_) {
          CustomSnackBars.instance.showSuccessSnackbar(
              title: "Success", message: "Password updated successfully");
        }).onError((error, stackTrace) {
          CustomSnackBars.instance
              .showFailureSnackbar(title: "Failure", message: "$error");
        });
      }).onError((error, stackTrace) {
        CustomSnackBars.instance
            .showFailureSnackbar(title: "Failure", message: "$error");
      });
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          CustomSnackBars.instance
              .showFailureSnackbar(title: 'Error', message: 'User not found');
          break;
        case 'wrong-password':
          CustomSnackBars.instance
              .showFailureSnackbar(title: 'Error', message: 'Wrong password');
          break;
        case 'invalid-email':
          CustomSnackBars.instance
              .showFailureSnackbar(title: 'Error', message: 'Invalid email');
          break;
        case 'email-already-in-use':
          CustomSnackBars.instance.showFailureSnackbar(
              title: 'Error', message: 'Email already in use');
          break;
        default:
          CustomSnackBars.instance.showFailureSnackbar(
              title: 'Retry', message: 'Something went wrong');
          break;
      }
    }
  }
}
