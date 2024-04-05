import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  //singletonInstance
  static NotificationService get instance => NotificationService();

  //method to get user device token for Firebase push notifications
  Future<String> getDeviceToken() async {
    String? token;
    try {
      token = await FirebaseMessaging.instance.getToken();
    } catch (e) {
      log("This was the exception while getting device token: $e");
    }
    if (token != null) {
      return token;
    }
    return "";
  }
}
