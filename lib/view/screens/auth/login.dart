import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grow_x/constants/app_colors.dart';
import 'package:grow_x/constants/app_fonts.dart';
import 'package:grow_x/controllers/auth/login_controller.dart';
import 'package:grow_x/core/utils/validators.dart';
import 'package:grow_x/generated/assets.dart';
import 'package:grow_x/view/screens/auth/forget_pass.dart';
import 'package:grow_x/view/screens/auth/signup.dart';
import 'package:grow_x/view/screens/bottom_nav_bar/persistent_nav_bar.dart';
import 'package:grow_x/view/screens/home/contactus.dart';
import 'package:grow_x/view/widgets/common_image_view_widget.dart';
import 'package:grow_x/view/widgets/my_button.dart';
import 'package:grow_x/view/widgets/my_text_field.dart';
import 'package:grow_x/view/widgets/my_text_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //finding LoginController
  LoginController controller = Get.find<LoginController>();

  //creating form key for validation
  final loginFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            WaveBackground(),
            Column(
              children: [
                Expanded(
                  child: Container(
                    child: Form(
                      key: loginFormKey,
                      child: ListView(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          children: [
                            Column(
                              children: [
                                const SizedBox(
                                  height: 40,
                                ),
                                Center(
                                  child: CommonImageView(
                                    imagePath: Assets.imagesWhite,
                                    height: 159,
                                  ),
                                ),
                                MyText(
                                  text: 'Login',
                                  paddingTop: 16,
                                  size: 30,
                                  color: kPrimaryColor,
                                  paddingBottom: 30,
                                  fontFamily: AppFonts.PLAY,
                                ),
                                MyTextField(
                                  hintText: 'youremail@gmail.com',
                                  validator:
                                      ValidationService.instance.emailValidator,
                                  controller: controller.emailCtrlr,
                                  onChanged: (value) {
                                    // Trim leading and trailing spaces
                                    controller.emailCtrlr.text = value.trim();
                                  },
                                ),

                                const SizedBox(
                                  height: 20,
                                ),
                                Obx(() => MyTextField(
                                      hintText: '***************',
                                      marginBottom: 22,
                                      isObSecure: controller.isShowPwd.value,
                                      validator: ValidationService
                                          .instance.emptyValidator,
                                      controller: controller.pwdCtrlr,
                                      onChanged: (value) {
                                        // Trim leading and trailing spaces
                                        controller.pwdCtrlr.text = value.trim();
                                      },
                                      // suffixIcon: controller.isShowPwd.value
                                      //     ? Icon(Icons.remove_red_eye_outlined)
                                      //     : Icon(
                                      //         Icons.do_not_disturb_alt_outlined),
                                      // onSuffixTap: () {
                                      //   controller.togglePwdView();
                                      // },
                                    )),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    MyText(
                                      onTap: () {
                                        Get.to(() => ForgetPassword());
                                      },
                                      text: 'Forget Password?',
                                      textAlign: TextAlign.right,
                                      paddingTop: 10,
                                      paddingRight: 50,
                                      weight: FontWeight.bold,
                                      color: kPrimaryColor,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                        width: 200,
                                        child: MyButton(
                                          height: 35,
                                          buttonText: 'Login',
                                          onTap: () {
                                            if (loginFormKey.currentState!
                                                .validate()) {
                                              controller
                                                  .loginUserWithEmailAndPassword(
                                                      context: context);
                                            }
                                          },
                                        )),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                        width: 200,
                                        child: MyButton(
                                          fillColor: kPrimaryColor,
                                          borderColor: kSecondaryColor,
                                          height: 35,
                                          isactive: false,
                                          btnTextColor: kTertiaryColor,
                                          buttonText: 'Register',
                                          onTap: () {
                                            Get.to(() => Signup());
                                          },
                                        )),
                                  ],
                                ),
                                //  Spacer(),
                              ],
                            ),
                          ]),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            joingroup();
                          },
                          child: CommonImageView(
                            imagePath: Assets.imagesWhatsapp,
                            height: 30,
                          ),
                        ),
                        MyText(
                          text: 'Join Group',
                          paddingTop: 5,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Get.to(() => ContactUs(
                                  isshow: true,
                                ));
                          },
                          child: CommonImageView(
                            imagePath: Assets.imagesContact,
                            height: 30,
                          ),
                        ),
                        MyText(
                          text: 'Contact us',
                          paddingTop: 5,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

joingroup() async {
  // Specify the WhatsApp chat link with the phone number and message
  var whatsappUrl = 'https://chat.whatsapp.com/H7LvKwjQq7k4zsXF301Y7q';

  // Check if the WhatsApp app is installed
  if (await canLaunch(whatsappUrl)) {
    // Open the WhatsApp chat link
    await launch(whatsappUrl);
  } else {
    // Show an error message if WhatsApp is not installed
    await launch(
      whatsappUrl,
      forceWebView: false,
      forceSafariVC: false,
    );
  }
}

class WaveBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: kPrimaryColor,
          child: ClipPath(
            clipper: WaveClipper(),
            child: Container(
              decoration: const BoxDecoration(color: kGrey1Color),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          color: Colors.transparent,
          child: ClipPath(
            clipper: WaveClipper(),
            child:
                Container(decoration: const BoxDecoration(color: kGrey2Color)),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 40),
          color: Colors.transparent,
          child: ClipPath(
            clipper: WaveClipper(),
            child: Container(
              decoration: const BoxDecoration(gradient: bluess),
            ),
          ),
        ),
      ],
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..lineTo(0, size.height * 0.7)
      ..quadraticBezierTo(
        size.width / 4,
        size.height,
        size.width / 1.7,
        size.height * 0.8,
      )
      ..quadraticBezierTo(
        3 * size.width / 2.5,
        size.height / 2.4,
        size.width,
        size.height * 0.95,
      )
      ..lineTo(size.width, 0.3)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Your login form fields, buttons, etc.
            // Example:
            const TextField(
              decoration: InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 10),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
