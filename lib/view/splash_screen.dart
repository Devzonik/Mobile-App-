import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:grow_x/constants/app_colors.dart';
import 'package:grow_x/controllers/launch/splash_screen_controller.dart';
import 'package:grow_x/core/bindings/bindings.dart';
import 'package:grow_x/generated/assets.dart';
import 'package:grow_x/view/screens/auth/login.dart';
import 'package:grow_x/view/screens/auth/signup.dart';
import 'package:grow_x/view/widgets/common_image_view_widget.dart';

class SplashScreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _progressValue = 0.0;
  SplashScreenController controller = Get.find<SplashScreenController>();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Simulate a loading process
    for (int i = 0; i <= 100; i++) {
      await Future.delayed(Duration(milliseconds: 50));
      setState(() {
        _progressValue = i / 100;
      });
    }

    controller.splashScreenHandler();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your splash screen content here
            Center(
              child: CommonImageView(
                imagePath: Assets.imagesLogo,
                height: 200,
              ),
            ),
            SizedBox(height: 20),

            // Linear progress bar
            SizedBox(
              width: 200,
              child: LinearProgressIndicator(
                color: kSecondaryColor,
                backgroundColor: kPrimaryColor,
                value: _progressValue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
