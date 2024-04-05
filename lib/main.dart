import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grow_x/config/routes/routes.dart';
import 'package:grow_x/config/theme/light_theme.dart';
import 'package:grow_x/controllers/auth/bank_details_controller.dart';
import 'package:grow_x/controllers/bottom_nav_bar_controller.dart';
import 'package:grow_x/core/bindings/bindings.dart';
import 'package:grow_x/firebase_options.dart';
import 'package:grow_x/models/user_models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grow_x/view/screens/auth/bank_details.dart';

Future<UserModel> getCurrentUser() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    return UserModel.fromFirebaseUser(user);
  } else {
    // Handle the case where the user is not signed in
    throw Exception("User not signed in");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Get.put(BottomNavBarController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      title: 'Grow_x',
      theme: lightTheme,
      themeMode: ThemeMode.light, initialBinding: InitialBindings(),
      initialRoute: AppLinks.splash_screen,
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 200),
      getPages: AppRoutes.pages,

      // home: const BankDetails(),
    );
  }
}
