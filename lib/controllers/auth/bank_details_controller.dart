import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grow_x/core/constants/firebase_collection_references.dart';

class BankDetailsController extends GetxController {
  RxString selectedBankName = "".obs;
  TextEditingController accNumberController = TextEditingController();
  TextEditingController accHolderNameController = TextEditingController();

  void saveBankDetails() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    final String? currentUserId = user?.uid;

    try {
      await bankCollection.doc().set({
        'userId': currentUserId,
        'bankName': selectedBankName.value,
        'accountHolderName': accHolderNameController.text,
        'accountNumber': accNumberController.text,
        // Add other fields as needed
      });
      // Data saved successfully
      // You can show a success message or navigate to another screen
    } catch (e) {
      // An error occurred
      print('Error saving bank details: $e');
      // You can show an error message using Snackbar or any other method
      Get.snackbar('Error', 'Error saving bank details');
    }
  }
}
