import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:grow_x/core/utils/snackbars.dart';
import 'package:path/path.dart' as path;

class FirebaseStorageService {
  //singleton instance
  static FirebaseStorageService get instance => FirebaseStorageService();

  //method to upload single image on Firebase
  Future<String> uploadSingleImage(
      {required String imgFilePath, String storageRef = "images"}) async {
    try {
      final filePath = path.basename(imgFilePath);
      final ref =
          FirebaseStorage.instance.ref().child(storageRef).child(filePath);

      await ref.putFile(File(imgFilePath)).timeout(Duration(seconds: 30));

      String downloadUrl = await ref.getDownloadURL();

      return downloadUrl;
    } on FirebaseException catch (e) {
      CustomSnackBars.instance
          .showFailureSnackbar(title: "Failed", message: '$e');
      return '';
    } on TimeoutException {
      CustomSnackBars.instance
          .showFailureSnackbar(title: "Failed", message: 'Request Timeout');
      return '';
    } catch (e) {
      CustomSnackBars.instance
          .showFailureSnackbar(title: "Failed", message: '$e');
      return '';
    }
  }

  //get image url paths functions
  Future<List> uploadMultipleImages(
      {required List imagesPaths, String storageRef = "images"}) async {
    try {
      final futureList = imagesPaths.map((element) async {
        final filePath = path.basename(element.path);
        final ref =
            FirebaseStorage.instance.ref().child(storageRef).child(filePath);
        await ref.putFile(File(element.path));
        return ref.getDownloadURL();
      });
      final downloadURLs = await Future.wait(futureList);
      return downloadURLs;
    } on FirebaseException catch (e) {
      CustomSnackBars.instance
          .showFailureSnackbar(title: "Failed", message: '$e');
      return [];
    } on TimeoutException {
      CustomSnackBars.instance
          .showFailureSnackbar(title: "Failed", message: 'Request Timeout');
      return [];
    } catch (e) {
      CustomSnackBars.instance
          .showFailureSnackbar(title: "Failed", message: '$e');
      return [];
    }
  }
}
