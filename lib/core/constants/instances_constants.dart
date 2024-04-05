import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:grow_x/controllers/home/home_controller.dart';
import 'package:grow_x/models/user_models/user_model.dart';

final HomeController controller = Get.find<HomeController>();
String username = 'Hira';
Future<void> fetchCurrentUser() async {
  username = await controller.fetchUserName() ?? 'User';
  print('User Name: $username');
}

User? user = FirebaseAuth.instance.currentUser;
//user model for global access
Rx<UserModel> userModelGlobal = UserModel(
  userId: FirebaseAuth.instance.currentUser?.uid,
  name: username,
  email: "",
  phoneNo: "",
  joinedOn: DateTime.now(),
  isShowNotification: true,
  refferallink: '',
  referrercode: '',
).obs;
