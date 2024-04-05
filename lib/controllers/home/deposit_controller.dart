import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grow_x/controllers/home/home_controller.dart';
import 'package:grow_x/core/constants/firebase_collection_references.dart';
import 'package:grow_x/models/request_model/request_model.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/utils/dialogs.dart';

class DepositController extends GetxController {
  StreamSubscription<QuerySnapshot>? streamSubscription;
  RxList<RequestModel> userPlans = RxList<RequestModel>();
  RxString selectedBankName = "".obs;
  // Text editing controllers
  TextEditingController bankNameController = TextEditingController();
  TextEditingController accNumberController = TextEditingController();
  TextEditingController accHolderNameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
//list of selected bike pics
  RxList<XFile> pickedImages = RxList<XFile>([]);
  // Collection reference for deposits
  final CollectionReference depositsCollection =
      FirebaseFirestore.instance.collection('Deposits');

  // Get the current user's UID
  String get currentUserUid => FirebaseAuth.instance.currentUser?.uid ?? '';

  // Image picker instance
  final ImagePicker _imagePicker = ImagePicker();
  // Method to select image from gallery
  Future<void> selectImageFromGallery() async {
    // Selecting images from the gallery
    pickedImages.addAll(await _imagePicker.pickMultiImage());
  }

  // Method to select image from camera
  Future<void> selectImageFromCamera() async {
    // Selecting an image from the camera
    XFile? selectedImage =
        await _imagePicker.pickImage(source: ImageSource.camera);

    if (selectedImage != null) {
      pickedImages.add(selectedImage);
    }
  }

  Future<List<String>> uploadImagesToStorage() async {
    List<String> imageUrls = [];

    List<Future<void>> uploadTasks = pickedImages.map((pickedImage) async {
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('deposit_images/${DateTime.now().millisecondsSinceEpoch}');

      UploadTask uploadTask = storageReference.putFile(File(pickedImage.path));

      await uploadTask.whenComplete(() async {
        String imageUrl = await storageReference.getDownloadURL();
        imageUrls.add(imageUrl);
      });
    }).toList();

    // Wait for all upload tasks to complete
    await Future.wait(uploadTasks);

    return imageUrls;
  }

  final HomeController controller = Get.find<HomeController>();
  @override
  void onInit() {
    super.onInit();
    setUserLevelFromHomeController();
    controller.loadUsername();
    fetchTotalDeposit();
    fetchTotalCurrentBalance();
  }

  int currentUserLevel = 1;
  String currentcode = "";
  void setUserLevelFromHomeController() {
    // Get the RxInt representing the user's level

    RxInt userLevel = controller.getUserLevel();

    // Convert RxInt to regular int
    currentUserLevel = userLevel.value;
    RxString code = controller.getUserCode();
    currentcode = code.value;
  }

  Future<void> submitDeposit(
      BuildContext context, String amount, List<XFile> pickedImages2) async {
    if (selectedBankName.isEmpty ||
        accNumberController.text.isEmpty ||
        accHolderNameController.text.isEmpty ||
        amountController.text.isEmpty) {
      Get.snackbar('Error', 'All fields are required');
      return;
    }

    try {
      Map<String, dynamic> depositData = {
        'bankName': selectedBankName.value,
        'accNumber': accNumberController.text.trim(),
        'accHolderName': accHolderNameController.text.trim(),
        'amount': amount,
        'uid': currentUserUid,
        // 'imageUrls': imageUrls,
        'isFirsttime': false,
        'approved': 'pending',
        'createdat': DateTime.now()
      };

      // Update depositData with image URLs
      //    log(pickedImages2);
      log("purana: $pickedImages");

      List<String> imageUrls = await uploadImagesToStorage();
      depositData['imageUrl'] = imageUrls;
      // log(pickedImages2);

      QuerySnapshot depositsSnapshot = await depositsCollection
          .where('uid', isEqualTo: currentUserUid)
          .limit(1)
          .get();

      bool isFirstTimeDeposit = depositsSnapshot.docs.isEmpty;
      depositData['isFirsttime'] = isFirstTimeDeposit;

      if (isFirstTimeDeposit) {
        String amountText = amount;
        log('Amount Text: $amountText'); // Add this line for debugging
        double totalAmount;

        if (amountText.isNotEmpty) {
          try {
            totalAmount = double.parse(amountText);
          } catch (e) {
            Get.snackbar('Error', 'Invalid amount entered');
            return;
          }
        } else {
          Get.snackbar('Error', 'Amount field is empty');
          return;
        }

        double additionalAmount = totalAmount * 0.05;
        double finalAmount = totalAmount + additionalAmount;
        depositData['amount'] = finalAmount.toStringAsFixed(
            2); // Saving total amount as string with two decimal places
      }

      log('imageee test18 ');
      await depositsCollection.add(depositData);

      bankNameController.clear();
      accNumberController.clear();
      accHolderNameController.clear();
      amountController.clear();
      pickedImages.clear();
    } catch (e) {
      log('Error submitting deposit: $e');
      Get.snackbar('Error', 'An error occurred while submitting the deposit');
    }
  }

  @override
  void onClose() {
    // Dispose of text editing controllers when the controller is closed
    bankNameController.dispose();
    accNumberController.dispose();
    accHolderNameController.dispose();
    amountController.dispose();
    super.onClose();
  }

  getRunning() async {
    streamSubscription = await FirebaseFirestore.instance
        .collection('user_plans')
        .where('field', isEqualTo: '')
        .get()
        .asStream()
        .listen((event) {
      for (var item in event.docs) {
        userPlans.add(RequestModel.fromMap(item.data()));
      }
    });
  }

  Future<double> fetchTotalDeposit() async {
    try {
      // Replace 'depositsCollection' with the actual reference to your deposits collection
      QuerySnapshot querySnapshot = await depositsCollection
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .get();

      double totalDeposit = 0;

      for (QueryDocumentSnapshot<Object?> docSnapshot in querySnapshot.docs) {
        // Assuming 'amount' is the field you want to accumulate
        var amountValue = docSnapshot['amount'];

        // Attempt to convert the 'amount' value to a double, or use a default value (0) if it fails
        log('Before conversion: $amountValue');
        double amount = 0;

        if (amountValue is num || amountValue is String) {
          amount = double.tryParse(amountValue.toString()) ?? 0;
        } else {
          log('Invalid numeric value in Firestore: $amountValue');
        }
        log('After conversion: $amount');
        if (docSnapshot['approved'] == true) {
          totalDeposit += amount;
        }
      }

      return totalDeposit;
    } catch (e) {
      log('Error fetching total deposit: $e');
      return 0; // Return 0 in case of an error
    }
  }

  Future<double> fetchTotalCurrentBalance() async {
    try {
      // Replace 'userPlansCollection' with the actual reference to your user plans collection
      QuerySnapshot querySnapshot = await userPlansCollection
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .get();

      double totalCurrentBalance = 0;

      for (QueryDocumentSnapshot<Object?> docSnapshot in querySnapshot.docs) {
        // Assuming 'amount' is the field you want to accumulate
        var amountValue = docSnapshot['amount'];

        // Attempt to convert the 'amount' value to a double, or use a default value (0) if it fails
        double amount = (amountValue is num || amountValue is String)
            ? double.tryParse(amountValue.toString()) ?? 0
            : 0;

        totalCurrentBalance += amount;
      }

      return totalCurrentBalance;
    } catch (e) {
      log('Error fetching total current balance: $e');
      return 0; // Return 0 in case of an error
    }
  }

  Future<List<DocumentSnapshot>> fetchDepositsByUid() async {
    try {
      // Query the documents where 'uid' field matches the current user's ID
      QuerySnapshot querySnapshot = await depositsCollection
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      // Return the list of documents
      return querySnapshot.docs;
    } catch (e) {
      // Handle errors here
      log('Error fetching deposits: $e');
      return [];
    }
  }
}
