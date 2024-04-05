import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grow_x/core/constants/firebase_collection_references.dart';

class InvestController extends GetxController {
  TextEditingController amountctrl = TextEditingController();
  Future<List<Map<String, dynamic>>> fetchData() async {
    try {
      QuerySnapshot querySnapshot = await plansCollection.get();

      // Process the documents in the querySnapshot
      List<Map<String, dynamic>> dataList = [];
      for (QueryDocumentSnapshot<Object?> docSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data =
            (docSnapshot.data() as Map<String, dynamic>);
        dataList.add(data);
      }

      return dataList;
    } catch (e) {
      log('Error fetching data: $e');
      return []; // Return an empty list in case of an error
    }
  }

  Future<List<Map<String, dynamic>>> fetchInvestedPlansData() async {
    try {
      QuerySnapshot querySnapshot = await userPlansCollection.get();

      // Process the documents in the querySnapshot
      List<Map<String, dynamic>> dataList = [];
      for (QueryDocumentSnapshot<Object?> docSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data =
            (docSnapshot.data() as Map<String, dynamic>);
        dataList.add(data);
      }

      return dataList;
    } catch (e) {
      log('Error fetching data: $e');
      return []; // Return an empty list in case of an error
    }
  }

  RxString error = ''.obs;

  // Add range property

  // Your existing functions and variables

  // Validate the entered amount based on the specified range
  String? validateWithdrawalAmount(String? value, String range) {
    if (value == null || value.isEmpty) {
      return 'Please enter the investment amount';
    }

    double amount = double.tryParse(value) ?? 0;

    return null;
  }

  String? validateWidthdrawalAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the investment amount';
    }

    double amount = double.tryParse(value) ?? 0;

    return null;
  }

  // Function to parse the range string
  List<double> parseRange(String range) {
    List<String> parts = range.split('-');
    if (parts.length == 2) {
      double min = double.tryParse(parts[0]) ?? 0;
      double max = double.tryParse(parts[1]) ?? 0;
      return [min, max];
    } else {
      return [0, 0];
    }
  }

  Future<void> addInvestmentData(String pid) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Get the current user's UID
        String userId = user.uid;

        // Generate a unique document ID for the user_plans collection
        String documentId = userPlansCollection.doc().id;

        // Prepare the data to be added
        Map<String, dynamic> data = {
          'createdat': DateTime.now(),
          'uid': userId,
          'pid': pid, // Replace with your actual PID
          'upid': documentId, // Replace with your actual UPID
          'amount': double.tryParse(amountctrl.text) ?? 0,
          'purchasedStatus': true,
          'profitamount': 0,
          'status': 'running'
        };

        // Add the data to the user_plans collection
        await FirebaseFirestore.instance
            .collection('user_plans')
            .doc(documentId)
            .set(data);
      }
    } catch (e) {
      log('Error adding investment data: $e');
    }
  }

  validateAmount(String? value, String range) {
    if (value == null || value.isEmpty) {
      return 'Please enter the amount';
    }

    double amount = double.tryParse(value) ?? 0;
    List<double> rangeValues = parseRange(range);

    if (amount < rangeValues[0] || amount > rangeValues[1]) {
      return 'amount must be between ${rangeValues[0]} and ${rangeValues[1]}';
    }

    return null;
  }
}
