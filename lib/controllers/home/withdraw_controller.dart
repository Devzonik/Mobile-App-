import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grow_x/core/constants/firebase_collection_references.dart';

class WithdrawController extends GetxController {
  TextEditingController accNumberController = TextEditingController();
  TextEditingController accHolderNameController = TextEditingController();
  TextEditingController amountctrl = TextEditingController();
  RxString selectedBankName = "".obs;
  Future<void> addWithdrawalRequest(
      String amount, String deductedamount) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Get the current user's UID
        String userId = user.uid;

        // Fetch bank details from the bank collection
        final bankSnapshot =
            await bankCollection.where('userId', isEqualTo: userId).get();

        if (bankSnapshot.docs.isNotEmpty) {
          final bankData = bankSnapshot.docs.first.data()
              as Map<String, dynamic>; // Explicit cast
          // Extract account number and account holder name from bank details
          String accountNumber = bankData['accountNumber'];
          String accountHolderName = bankData['accountHolderName'];

          // Generate a unique document ID for the withdrawal request
          String documentId = withdrawalRequestCollection.doc().id;
          (amount);
          // Prepare the data to be added
          Map<String, dynamic> data = {
            'wid': documentId,
            'uid': userId,
            'bankName':
                bankData['bankName'], // Include bank name from bank details
            'accountNumber': accountNumber,
            'accountHolderName': accountHolderName,
            'createdat': DateTime.now(),
            'status': 'pending',
            'deductedamount': deductedamount,
            'amount': amount
          };

          // Add the data to the withdrawal request collection
          await withdrawalRequestCollection.doc(documentId).set(data);
        }
      }
    } catch (e) {
      print('Error adding withdrawal request: $e');
    }
  }

  Future<Map<String, dynamic>?> getrequestsdetails(String pid) async {
    final DocumentSnapshot planSnapshot = await plansCollection.doc(pid).get();

    return planSnapshot.data() as Map<String, dynamic>?;
  }

  Stream<List<Map<String, dynamic>>> getpendingwithdrawals(String status) {
    return getpendingwithdrawalstream(status)
        .asyncMap((List<DocumentSnapshot<Object?>> request) async {
      final pendingrequests = <Map<String, dynamic>>[];

      return pendingrequests;
    });
  }

  Stream<List<DocumentSnapshot>> getpendingwithdrawalstream(String status) {
    final User? user = FirebaseAuth.instance.currentUser;
    final uid = user!.uid;

    if (uid != null) {
      return withdrawalRequestCollection
          .where('uid', isEqualTo: uid)
          .where('status', isEqualTo: status)
          .snapshots()
          .map((snapshot) => snapshot.docs);
    }

    return Stream.value([]);
  }
}
