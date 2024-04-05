import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grow_x/constants/app_colors.dart';
import 'package:grow_x/constants/app_fonts.dart';
import 'package:grow_x/constants/app_sizes.dart';
import 'package:grow_x/constants/app_styling.dart';
import 'package:grow_x/controllers/auth/signup_controller.dart';
import 'package:grow_x/core/constants/firebase_collection_references.dart';
import 'package:grow_x/core/utils/dialogs.dart';
import 'package:grow_x/core/utils/validators.dart';
import 'package:grow_x/generated/assets.dart';
import 'package:grow_x/services/firebase/firebase_authentication.dart';
import 'package:grow_x/view/screens/auth/bank_details.dart';
import 'package:grow_x/view/screens/auth/login.dart';
import 'package:grow_x/view/screens/home/contactus.dart';
import 'package:grow_x/view/widgets/my_button.dart';
import 'package:grow_x/view/widgets/my_text_field.dart';
import 'package:grow_x/view/widgets/my_text_widget.dart';

class Signup extends StatefulWidget {
  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  //finding SignUpController

  SignUpController controller = Get.put(SignUpController());

  //creating form key

  final signUpFormKey = GlobalKey<FormState>();
  String? _linkMessage;
  bool _isCreatingLink = false;

  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  final String DynamicLink = 'https://growx.com';
  final String Link = 'https://flutterfiretests.page.link/MEGs';

  @override
  void initState() {
    super.initState();
    initDynamicLinks();
  }

  Future<void> initDynamicLinks() async {
    dynamicLinks.onLink.listen((dynamicLinkData) {
      String? referralCode = dynamicLinkData.link.queryParameters['userId'];

      // Agar referral code mila hai, usko referral text field mein set karo
      if (referralCode != null) {
        controller.referralctrl.text = referralCode;
      }

      Navigator.pushNamed(context, dynamicLinkData.link.path);
    }).onError((error) {
      log('onLink error');
      log(error.message);
    });
  }

  Future<void> _createDynamicLink(bool short, String userId) async {
    setState(() {
      _isCreatingLink = true;
    });

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://growx.page.link',
      longDynamicLink: Uri.parse(
        'https://flutterfiretests.page.link?efr=0&ibi=io.flutter.plugins.firebase.dynamiclinksexample&apn=io.flutter.plugins.firebase.dynamiclinksexample&imv=0&amv=0&link=https%3A%2F%2Fexample%2Fhelloworld&ofl=https://ofl-example.com',
      ),
      link: Uri.parse(DynamicLink + '/?userId=$userId'),
      androidParameters: const AndroidParameters(
        packageName: 'com.gowthInvestment.growthX',
        minimumVersion: 0,
      ),
    );
    log("finded");
    final link = await FirebaseDynamicLinks.instance.buildLink(parameters);
    log("ssigned");
    await saveDynamicLinkToDatabase(link.toString(), userId);
    log("good");
  }

  Future<void> saveDynamicLinkToDatabase(String dynamicLink, String uid) async {
    // Add code to save the dynamic link to the database

    await users2Collection.doc(uid).update({
      'referralLink': dynamicLink,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background with gradient and waves effect
          signupWaveBackground(),
          Column(
            children: [
              Expanded(
                child: Form(
                  key: signUpFormKey,
                  child: ListView(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        Column(
                          children: [
                            const SizedBox(
                              height: 40,
                            ),
                            const Center(
                              child: ImageIcon(
                                AssetImage(Assets.imagesBlack),
                                color: kSecondaryColor,
                                size: 159,
                              ),
                            ),
                            MyText(
                              text: 'Sign Up',
                              paddingTop: 16,
                              size: 30,
                              color: kSecondaryColor,
                              paddingBottom: 30,
                              fontFamily: AppFonts.PLAY,
                            ),
                            Padding(
                              padding: AppSizes.DEFAULT_HORIZONTAL,
                              child: MyTextField(
                                labelText: 'Your name',
                                hintText: 'e.g. John Doe',
                                controller: controller.fullNameCtrlr,
                                validator: ValidationService
                                    .instance.userNameValidator,
                              ),
                            ),

                            Padding(
                              padding: AppSizes.DEFAULT_HORIZONTAL,
                              child: MyTextField(
                                labelText: 'Your email',
                                hintText: 'youremail@gmail.com',
                                controller: controller.emailCtrlr,
                                validator:
                                    ValidationService.instance.emailValidator,
                              ),
                            ),

                            const SizedBox(
                              width: 40,
                            ),
                            Padding(
                              padding: AppSizes.DEFAULT_HORIZONTAL,
                              child: MyTextField(
                                labelText: 'Phone Number',
                                hintText: '03001234564',
                                controller: controller.phoneNoCtrlr,
                                validator:
                                    ValidationService.instance.emptyValidator,
                                // prefixIcon: const Padding(
                                //     padding: EdgeInsets.all(8.0),
                                //     child: Icon(
                                //       Icons.email,
                                //       color: kSecondaryColor,
                                //       size: 18,
                                //     )
                                //     ),
                              ),
                            ),
                            const SizedBox(
                              width: 40,
                            ),
                            MyText(
                                paddingLeft: 45,
                                paddingTop: 10,
                                paddingRight: 45,
                                textAlign: TextAlign.center,
                                text:
                                    'You will need this mail for your password recovery incase you forgot your password'),

                            const SizedBox(
                              width: 40,
                            ),
                            Padding(
                              padding: AppSizes.DEFAULT_HORIZONTAL,
                              child: MyTextField(
                                hintText: 'referral (optional)',
                                controller: controller.referralctrl,
                              ),
                            ),

                            const SizedBox(
                              height: 20,
                            ),

                            Obx(() => Padding(
                                  padding: AppSizes.DEFAULT_HORIZONTAL,
                                  child: MyTextField(
                                    labelText: 'Password',
                                    hintText: '***************',
                                    marginBottom: 22,
                                    isObSecure: controller.isShowPwd.value,
                                    haveSuffix: true,
                                    validator: ValidationService
                                        .instance.validatePassword,
                                    controller: controller.pwdCtrlr,
                                    suffixIcon: controller.isShowPwd.value
                                        ? Assets.imagesShuteye
                                        : Assets.imagesSee,
                                    onSuffixTap: () {
                                      controller.togglePwdView();
                                    },
                                  ),
                                )),
                            const SizedBox(
                              width: 40,
                            ),

                            Obx(() => Padding(
                                  padding: AppSizes.DEFAULT_HORIZONTAL,
                                  child: MyTextField(
                                    labelText: 'Confirm Password',
                                    hintText: '***************',
                                    marginBottom: 22,
                                    isObSecure:
                                        controller.isShowConfirmPwd.value,
                                    haveSuffix: true,
                                    validator: (value) => ValidationService
                                        .instance
                                        .validateMatchPassword(
                                            value!, controller.pwdCtrlr.text),
                                    suffixIcon:
                                        controller.isShowConfirmPwd.value
                                            ? Assets.imagesShuteye
                                            : Assets.imagesSee,
                                    onSuffixTap: () {
                                      controller.toggleConfirmPwdView();
                                    },
                                  ),
                                )),
                            Padding(
                              padding: AppSizes.DEFAULT_HORIZONTAL,
                              child: Container(
                                height: 50,
                                decoration: rounded(kYellowColor),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: MyText(
                                    text:
                                        'Password must be at least 8 character, uppercase, lowercase, and unique code!',
                                    size: 12,
                                    color: kTextColor3,
                                    paddingLeft: 8,
                                    weight: FontWeight.bold,
                                  ),
                                ),
                              ),
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
                                        buttonText: 'Sign Up',
                                        onTap: () async {
                                          if (signUpFormKey.currentState!
                                              .validate()) {
                                            DialogService.instance
                                                .showProgressDialog(
                                                    context: context);

                                            FirebaseAuthService
                                                firebaseAuthService =
                                                Get.find<FirebaseAuthService>();
                                            String username = controller
                                                .fullNameCtrlr.text
                                                .trim();
                                            //level = 1;
                                            String email = controller
                                                .emailCtrlr.text
                                                .trim();
                                            String phone = controller
                                                .phoneNoCtrlr.text
                                                .trim();
                                            String password =
                                                controller.pwdCtrlr.text.trim();
                                            String referrallink = "";
                                            String refferrercode = controller
                                                .referralctrl.text
                                                .trim();
                                            bool isDoccreated = false;
                                            String userid = "";
                                            // Step 1: Extracting the current user's referral code
                                            // Step 1: Extracting the current user's referral code
                                            String currentUserReferralCode =
                                                controller.referralctrl.text;

                                            // Step 1: Check if the referral code matches any existing user's referrer code
                                            QuerySnapshot querySnapshot =
                                                await users2Collection
                                                    .where('referrerCode',
                                                        isEqualTo:
                                                            currentUserReferralCode)
                                                    .get();

                                            if (querySnapshot.docs.isNotEmpty &&
                                                currentUserReferralCode != "") {
                                              log('level 3');
                                              try {
                                                // Sign in the user with email and password
                                                FirebaseAuthService
                                                    firebaseAuthService =
                                                    Get.find<
                                                        FirebaseAuthService>();

                                                User? firebaseUser =
                                                    await firebaseAuthService
                                                        .signUpUsingEmailAndPassword(
                                                  email: email,
                                                  password: password,
                                                );

                                                // Get the user ID (UID)
                                                userid = FirebaseAuth
                                                    .instance.currentUser!.uid;

                                                await users2Collection
                                                    .doc(userid)
                                                    .set({
                                                  "username": username,
                                                  "level": 3,
                                                  "email": email,
                                                  "phone": phone,
                                                  "referrerCode": refferrercode,
                                                  "userid": userid,
                                                  "joinedOn": DateTime.now()
                                                });
                                              } catch (e) {
                                                // Handle sign-in errors
                                                log("Error signing in: $e");
                                              }
                                              await _createDynamicLink(
                                                  true, userid);
                                              log("User's level set to 3!");
                                              Navigator.pop(context);
                                              log("User data stored in Firestore!");
                                              Get.offAll(() => BankDetails());
                                            } else {
                                              querySnapshot = await users2Collection
                                                  .where('referralLink',
                                                      isEqualTo:
                                                          currentUserReferralCode)
                                                  .get();

                                              if (querySnapshot
                                                  .docs.isNotEmpty) {
                                                String matchedUserId =
                                                    querySnapshot.docs.first.id;
                                                await users2Collection
                                                    .doc(matchedUserId)
                                                    .update({'level': 1});
                                                try {
                                                  // Sign in the user with email and password
                                                  FirebaseAuthService
                                                      firebaseAuthService =
                                                      Get.find<
                                                          FirebaseAuthService>();

                                                  User? firebaseUser =
                                                      await firebaseAuthService
                                                          .signUpUsingEmailAndPassword(
                                                    email: email,
                                                    password: password,
                                                  );

                                                  // Get the user ID (UID)
                                                  userid = FirebaseAuth.instance
                                                      .currentUser!.uid;

                                                  // Store user data in Firestore collection "Testing"
                                                  await users2Collection
                                                      .doc(userid)
                                                      .set({
                                                    "username": username,
                                                    "level": 2,
                                                    "email": email,
                                                    "phone": phone,
                                                    "referrerCode":
                                                        refferrercode,
                                                    "userid": userid,
                                                    "joinedOn": DateTime.now()
                                                  });
                                                } catch (e) {
                                                  // Handle sign-in errors
                                                  log("Error signing in: $e");
                                                }
                                                await _createDynamicLink(
                                                    true, userid);

                                                Navigator.pop(context);

                                                log("User data stored in Firestore!");
                                                Get.offAll(() => BankDetails());

                                                log("User's level set to 2 and matched user's level set to 1!");
                                              } else {
                                                try {
                                                  // Sign in the user with email and password
                                                  FirebaseAuthService
                                                      firebaseAuthService =
                                                      Get.find<
                                                          FirebaseAuthService>();

                                                  User? firebaseUser =
                                                      await firebaseAuthService
                                                          .signUpUsingEmailAndPassword(
                                                    email: email,
                                                    password: password,
                                                  );

                                                  // Get the user ID (UID)
                                                  userid = FirebaseAuth.instance
                                                      .currentUser!.uid;

                                                  // Store user data in Firestore collection "Testing"
                                                  await users2Collection
                                                      .doc(userid)
                                                      .set({
                                                    "username": username,
                                                    "level": 0,
                                                    "email": email,
                                                    "phone": phone,
                                                    "referrerCode":
                                                        refferrercode,
                                                    "userid": userid,
                                                    "joinedOn": DateTime.now()
                                                  });
                                                } catch (e) {
                                                  // Handle sign-in errors
                                                  log("Error signing in: $e");
                                                }
                                                await _createDynamicLink(
                                                    true, userid);
                                                log("User's level set to 0!");
                                                Navigator.pop(context);
                                                log("User data stored in Firestore!");
                                                Get.offAll(() => BankDetails());
                                              }
                                            }
                                          }
                                        })),
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
                                      buttonText: 'Log In',
                                      onTap: () {
                                        Get.to(() => Login());
                                      },
                                    )),
                              ],
                            ),
                            //  Spacer(),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
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
                                  child: Image.asset(
                                    Assets.imagesWhatsapp,
                                    color: kPrimaryColor,
                                    height: 30,
                                  ),
                                ),
                                MyText(
                                  text: 'Join Group',
                                  paddingTop: 5,
                                  color: kPrimaryColor,
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
                                  child: Image.asset(
                                    Assets.imagesContact,
                                    color: kPrimaryColor,
                                    height: 30,
                                  ),
                                ),
                                MyText(
                                  text: 'Contact us',
                                  color: kPrimaryColor,
                                  paddingTop: 5,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        )
                      ]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class signupWaveBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(gradient: bluess),
          child: ClipPath(
            clipper: WaveClipper(),
            child: Container(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
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
