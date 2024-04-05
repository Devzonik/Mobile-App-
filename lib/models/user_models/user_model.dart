import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String? userId;
  String? name;
  String? email;
  String? phoneNo;
  String? refferallink;
  DateTime? joinedOn;
  bool? isShowNotification;
  String? referrercode;
  int? level;

  //bike info

  UserModel(
      {required this.userId,
      required this.name,
      required this.email,
      required this.phoneNo,
      required this.refferallink,
      required this.joinedOn,
      required this.isShowNotification,
      required this.referrercode,
      this.level});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'userId': userId,
      'name': name,
      'email': email,
      'phone': phoneNo,
      'refferallink': '//link$userId',
      'joinedOn': joinedOn,
      'isShowNotification': isShowNotification,
      'referrercode': referrercode,
      'level': 0
    };
  }

  factory UserModel.fromJson(DocumentSnapshot map) {
    return UserModel(
        userId: map['userId'],
        name: map['name'],
        email: map['email'],
        phoneNo: map['phone'],
        refferallink: map['refferallink'],
        joinedOn: map['joinedOn'].toDate(),
        isShowNotification: map['isShowNotification'],
        referrercode: map['referrercode'],
        level: map['level']);
  }
  static Future<Map<String, dynamic>> fetchUserDataFromFirestore(
      String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      } else {
        return {}; // Empty data if user document not found
      }
    } catch (e) {
      log('Error fetching user data from Firestore: $e');
      return {}; // Empty data in case of an error
    }
  }

  factory UserModel.fromFirebaseUser(User user) {
    // ignore: unused_local_variable
    Map<String, dynamic> userData =
        fetchUserDataFromFirestore(user.uid) as Map<String, dynamic>;
    return UserModel(
        userId: user.uid,
        name: userData['name'],
        email: user.email,
        phoneNo: user.phoneNumber,
        refferallink: '//link${user.uid}',
        joinedOn: DateTime.now(), // Adjust as per your requirement
        isShowNotification: true,
        referrercode: '',
        level: 0 // Adjust as per your requirement
        );
  }
}
