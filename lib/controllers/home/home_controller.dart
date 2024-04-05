import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grow_x/core/constants/firebase_collection_references.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  late Stream<List<Map<String, dynamic>>> _dataStream;

  Stream<List<Map<String, dynamic>>> get dataStream => _dataStream;

  @override
  void onInit() {
    super.onInit();
    _dataStream = plansCollection.snapshots().map((querySnapshot) {
      List<Map<String, dynamic>> dataList = [];
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        dataList.add(data);
      });

      // Sort dataList based on the 'sr' attribute
      dataList.sort((a, b) => (a['sr'] as int).compareTo(b['sr'] as int));

      return dataList;
    });
  }

  String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

// Reference to the users collection
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

// Fetch the user data from the users collection
  Future<String?> fetchUserName() async {
    try {
      DocumentSnapshot userSnapshot =
          await usersCollection.doc(currentUserId).get();
      if (userSnapshot.exists) {
        // The user document exists, return the 'name' field
        return userSnapshot['name'];
      } else {
        // The user document does not exist
        return null;
      }
    } catch (e) {
      // Handle any errors that might occur during the fetch
      log('Error fetching user name: $e');
      return null;
    }
  }

  Stream<List<Map<String, dynamic>>> fetchInvestedPlansStream() {
    return userPlansCollection.snapshots().map((snapshot) {
      List<Map<String, dynamic>> dataList = [];
      snapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        dataList.add(data);
      });
      return dataList;
    });
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

  Future<List<Map<String, dynamic>>> fetchdeposits() async {
    try {
      QuerySnapshot querySnapshot = await depositCollection.get();

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

  RxString username = ''.obs;
  RxString joindate = ''.obs;
  RxInt level = 0.obs;
  RxString referralLink = ''.obs;
  RxString referrerCode = ''.obs;

  Future<void> loadUsername() async {
    String? currentUid = FirebaseAuth.instance.currentUser?.uid;
    if (currentUid != null) {
      try {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('User2')
            .doc(currentUid)
            .get();

        if (userSnapshot.exists) {
          // Retrieve the username directly from Firestore
          username.value = userSnapshot['username'];
          Timestamp joinedOnTimestamp = userSnapshot['joinedOn'];
          level.value = userSnapshot['level'];
          referralLink.value = userSnapshot['referralLink'];
          referrerCode.value = userSnapshot['referrerCode'];
          DateTime joinedOnDate = joinedOnTimestamp.toDate();
          String formattedDateTime =
              DateFormat("d-M-yyyy , h:mma").format(joinedOnDate);
          joindate.value = formattedDateTime.toString();
        } else {
          log('User not found in Firestore.');
        }
      } catch (e) {
        log('Error loading username: $e');
      }
    }
  }

  RxInt getUserLevel() {
    return level;
  }

  RxString getUserCode() {
    return referrerCode;
  }
}
