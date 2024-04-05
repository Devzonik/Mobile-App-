import 'package:get/get.dart';
import 'package:grow_x/controllers/auth/bank_details_controller.dart';
import 'package:grow_x/controllers/auth/forget_pass_controller.dart';
import 'package:grow_x/controllers/auth/login_controller.dart';
import 'package:grow_x/controllers/auth/signup_controller.dart';
import 'package:grow_x/controllers/bottom_nav_bar_controller.dart';
import 'package:grow_x/controllers/home/deposit_controller.dart';
import 'package:grow_x/controllers/home/home_controller.dart';
import 'package:grow_x/controllers/home/invest_controller.dart';
import 'package:grow_x/controllers/home/withdraw_controller.dart';
import 'package:grow_x/controllers/launch/splash_screen_controller.dart';
import 'package:grow_x/controllers/portfolio/portfolio_controller.dart';
import 'package:grow_x/controllers/profile/profile_controller.dart';
import 'package:grow_x/controllers/teams/team_controller.dart';
import 'package:grow_x/services/firebase/firebase_authentication.dart';

class InitialBindings implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<SignUpController>(SignUpController());
    Get.put<LoginController>(LoginController());
    Get.put<FirebaseAuthService>(FirebaseAuthService());
    Get.put<SplashScreenController>(SplashScreenController());

    Get.put<ProfileController>(ProfileController());
    //controllers that should must be initialized throughout the app lifecycle
    Get.put<HomeController>(HomeController());
    Get.put<ForgetPasswordController>(ForgetPasswordController());
    Get.put<TeamsController>(TeamsController());
    Get.put(BankDetailsController());
    Get.put<DepositController>(DepositController());
    Get.put<InvestController>(InvestController());
    Get.put<BankDetailsController>(BankDetailsController());
    Get.put<WithdrawController>(WithdrawController());
    Get.put<PortfolioController>(PortfolioController());
    Get.put<BottomNavBarController>(BottomNavBarController());
  }
}

class ProfileBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<ProfileController>(ProfileController());
  }
}

class BluetoothBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    //Get.put<BLuetoothController>(BLuetoothController());
  }
}

class FriendsBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    // Get.put<FriendsController>(FriendsController());
  }
}
