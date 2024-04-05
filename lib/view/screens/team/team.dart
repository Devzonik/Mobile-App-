import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grow_x/constants/app_colors.dart';
import 'package:grow_x/constants/app_fonts.dart';
import 'package:grow_x/constants/app_sizes.dart';
import 'package:grow_x/constants/app_styling.dart';
import 'package:grow_x/controllers/home/home_controller.dart';
import 'package:grow_x/controllers/teams/team_controller.dart';
import 'package:grow_x/core/constants/firebase_collection_references.dart';
import 'package:grow_x/generated/assets.dart';
import 'package:grow_x/view/screens/auth/login.dart';
import 'package:grow_x/view/screens/team/team_members.dart';
import 'package:grow_x/view/widgets/common_image_view_widget.dart';
import 'package:grow_x/view/widgets/my_text_widget.dart';

class Team extends StatefulWidget {
  const Team({super.key});

  @override
  State<Team> createState() => _TeamState();
}

class _TeamState extends State<Team> {
  final TeamsController controller = Get.find<TeamsController>();
  final HomeController controller2 = Get.find<HomeController>();
  @override
  void initState() {
    super.initState();
    // Call the function in initState
    controller.getUserCountWithReferrerCode();

    controller2.loadUsername();
    //  calculateTotalCommission();
    controller.accumulateDepositAmounts();
  }

  double totalCommission = 0;
  double total = 0;
  double totalCommissionForDocuments = 0.0;
  double totalCommissionForCurrentUser = 0.0;
  double subtotal = 0.0;
  // Future<void> calculateTotalCommission() async {
  //   // Get the current user's UID
  //   String currentUserUid = FirebaseAuth.instance.currentUser!.uid;

  //   // Retrieve user plans collection
  //   QuerySnapshot userPlansSnapshot = await userPlansCollection.get();

  //   // Initialize variables for commission amounts
  //   double commission7Percent = 0.0;
  //   double commission5Percent = 0.0;
  //   double commission2Percent = 0.0;

  //   // Iterate through user plans
  //   userPlansSnapshot.docs.forEach((userPlanDoc) {
  //     // Check if the document's UID matches the current user's UID
  //     if (userPlanDoc.exists &&
  //         userPlanDoc.data() != null &&
  //         userPlanDoc['uid'] == currentUserUid) {
  //       // Accumulate profit amounts based on different commission percentages
  //       double profitAmount = userPlanDoc['profitamount'] ?? 0.0;

  //       // Check user's level and calculate commission accordingly
  //       int userLevel = controller2.level.value ?? 0;
  //       if (userLevel == 1) {
  //         commission7Percent += profitAmount * 0.07;
  //       } else if (userLevel == 2) {
  //         commission5Percent += profitAmount * 0.05;
  //       } else if (userLevel == 3) {
  //         commission2Percent += profitAmount * 0.02;
  //       }
  //     }
  //   });

  //   QuerySnapshot usersWithSameReferralCode = await users2Collection
  //       .where('referrerCode', isEqualTo: controller2.referrerCode.value)
  //       .get();
  //   int countSameReferrerCode = usersWithSameReferralCode.docs.length;
  //   QuerySnapshot linkquery = await users2Collection
  //       .where('referralLink', isEqualTo: controller2.referrerCode.value)
  //       .get();

  //   // Add commission to appropriate levels

  //   // Add commission to 3rd level users

  //   for (DocumentSnapshot userDoc in usersWithSameReferralCode.docs) {
  //     Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
  //     int userLevel = userData['level'] ?? 0;
  //     if (userDoc.id != currentUserUid && userLevel == 3) {
  //       print('level 3');
  //       // Exclude the current user

  //       await userDoc.reference.update({
  //         'commissionList': FieldValue.arrayUnion([commission2Percent])
  //       });
  //     }

  //     if (userDoc.id != currentUserUid && userLevel == 2) {
  //       log('level 2');

  //       // Exclude the current user
  //       await userDoc.reference.update({
  //         'commissionList': FieldValue.arrayUnion([commission5Percent])
  //       });
  //     }
  //   }
  //   for (DocumentSnapshot userDoc2 in linkquery.docs) {
  //     if (linkquery.docs.isNotEmpty) {
  //       log('level 1');

  //       // Exclude the current user
  //       await userDoc2.reference.update({
  //         'commissionList': FieldValue.arrayUnion([commission7Percent])
  //       });
  //     }
  //   }
  //   // Show a success message
  //   //  Get.snackbar('Success', 'Deposit submitted successfully');
  //   // Retrieve data from Firebase Firestore
  //   QuerySnapshot commissionSnapshot = await users2Collection.get();
  //   DocumentReference currentUserDocRef =
  //       users2Collection.doc(FirebaseAuth.instance.currentUser!.uid);

  //   DocumentSnapshot currentUserDoc = await currentUserDocRef.get();
  //   // Iterate through commission lists
  //   commissionSnapshot.docs.forEach((doc) async {
  //     if (doc.exists &&
  //         (doc.data() as Map<String, dynamic>).containsKey('commissionList')) {
  //       List<dynamic> commissions = doc['commissionList'];
  //       String referrerCode = doc['referrerCode'];
  //       if (referrerCode == controller2.referralLink.value) {
  //         // Calculate sum of commissions
  //         log(referrerCode);

  //         // Calculate the total commission
  //         double totalCommission = commissions.fold(0.0,
  //             (previousValue, element) => previousValue + element as double);

  //         // Update the document with the total commission
  //         await doc.reference.update({'totalCommission': totalCommission});
  //         await currentUserDocRef.update({
  //           'totalCommission': totalCommission,
  //         });
  //         totalCommissionForDocuments += totalCommission;
  //       }
  //       // Check if the document exists and has the commissionList field
  //       if (currentUserDoc.exists &&
  //           currentUserDoc.data() != null &&
  //           (currentUserDoc.data() as Map<String, dynamic>)
  //               .containsKey('commissionList')) {
  //         List<dynamic> commissions = currentUserDoc['commissionList'];

  //         // Calculate the total commission
  //         double totalCommission = commissions.fold(0.0,
  //             (previousValue, element) => previousValue + (element as double));
  //         totalCommissionForCurrentUser = totalCommission;
  //         log('Total commission for current user: $totalCommission');
  //       } else {
  //         log(
  //             'Document does not exist or commissionList field is empty for the current user.');
  //       }
  //       subtotal = totalCommissionForDocuments + totalCommissionForCurrentUser;
  //       log('Subtotal of commissions: $subtotal');
  //     }

  //     // Check if the current user's link matches the referrer code
  //   });

  //   setState(() {
  //     totalCommission = total; // Cast total to int before updating state
  //     log(totalCommission);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    String? currentUserReferralLink = controller2.referralLink.value;
    return Stack(
      children: [
        CommonImageView(
          imagePath: Assets.imagesWaves,
          width: Get.width,
          height: Get.height,
          fit: BoxFit.cover,
        ),
        SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: AppSizes.DEFAULT_PADDING,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const ImageIcon(
                        AssetImage(Assets.imagesBlack),
                        color: kSecondaryColor,
                        size: 50,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const ImageIcon(
                            AssetImage(Assets.imagesSettings),
                            color: kSecondaryColor,
                            size: 20,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          InkWell(
                            onTap: () {
                              FirebaseAuth.instance.signOut();
                              Get.offAll(() => Login());
                            },
                            child: const ImageIcon(
                              AssetImage(Assets.imagesLogout2),
                              color: kSecondaryColor,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      MyText(
                        text: 'Team Details',
                        fontFamily: AppFonts.PLAY,
                        size: 22,
                        weight: FontWeight.bold,
                        paddingBottom: 16,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 200,
                              decoration:
                                  rounded2(kPrimaryColor.withOpacity(0.9)),
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    MyText(
                                      text: 'Total Team Deposit',
                                      size: 15,
                                      textAlign: TextAlign.center,
                                      weight: FontWeight.bold,
                                    ),
                                    MyText(
                                      // Use Obx to automatically update the UI when userCount changes
                                      text: '0',
                                      size: 20,
                                      color: kSecondaryColor,
                                      fontFamily: AppFonts.PLAY,
                                    )
                                  ]),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Container(
                              height: 200,
                              decoration:
                                  rounded2(kSecondaryColor.withOpacity(0.4)),
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    MyText(
                                      text: 'Total Team Commission',
                                      color: kPrimaryColor,
                                      size: 15,
                                      textAlign: TextAlign.center,
                                      weight: FontWeight.bold,
                                    ),
                                    MyText(
                                      text: subtotal.toStringAsFixed(0),
                                      size: 20,
                                      color: kPrimaryColor,
                                      fontFamily: AppFonts.PLAY,
                                    )
                                  ]),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Get.to(() => TeamMembers());
                              },
                              child: Container(
                                height: 200,
                                decoration:
                                    rounded2(kPrimaryColor.withOpacity(0.8)),
                                child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      MyText(
                                        text: 'Total Team Members',
                                        size: 15,
                                        textAlign: TextAlign.center,
                                        weight: FontWeight.bold,
                                      ),
                                      StreamBuilder(
                                          stream: users2Collection
                                              .where('referrerCode',
                                                  isEqualTo:
                                                      currentUserReferralLink)
                                              .snapshots(),
                                          builder: (context,
                                              AsyncSnapshot<QuerySnapshot>
                                                  snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            } else if (snapshot.hasError) {
                                              return Text(
                                                  'Error: ${snapshot.error}');
                                            } else {
                                              int totalCount =
                                                  snapshot.data!.docs.length;
                                              return MyText(
                                                // Use Obx to automatically update the UI when userCount changes
                                                text: totalCount.toString(),
                                                size: 20,
                                                color: kSecondaryColor,
                                                fontFamily: AppFonts.PLAY,
                                              );
                                            }
                                          })
                                    ]),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 200,
                              decoration:
                                  rounded2(kPrimaryColor.withOpacity(0.9)),
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    MyText(
                                      text: 'Level 1 Commission',
                                      size: 15,
                                      textAlign: TextAlign.center,
                                      weight: FontWeight.bold,
                                    ),
                                    MyText(
                                      // Use Obx to automatically update the UI when userCount changes
                                      text: '7%',
                                      size: 20,
                                      color: kSecondaryColor,
                                      fontFamily: AppFonts.PLAY,
                                    ),
                                  ]),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Container(
                              height: 200,
                              decoration:
                                  rounded2(kSecondaryColor.withOpacity(0.4)),
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    MyText(
                                      text: 'Level 2 Commission',
                                      color: kPrimaryColor,
                                      size: 15,
                                      textAlign: TextAlign.center,
                                      weight: FontWeight.bold,
                                    ),
                                    MyText(
                                      // Use Obx to automatically update the UI when userCount changes
                                      text: '5%',
                                      size: 20,
                                      color: kSecondaryColor,
                                      fontFamily: AppFonts.PLAY,
                                    )
                                  ]),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Container(
                              height: 200,
                              decoration:
                                  rounded2(kPrimaryColor.withOpacity(0.8)),
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    MyText(
                                      text: 'Level 3 Commission',
                                      size: 15,
                                      textAlign: TextAlign.center,
                                      weight: FontWeight.bold,
                                    ),
                                    MyText(
                                      // Use Obx to automatically update the UI when userCount changes
                                      text: '1%',
                                      size: 20,
                                      color: kSecondaryColor,
                                      fontFamily: AppFonts.PLAY,
                                    )
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
