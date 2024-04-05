import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:grow_x/constants/app_colors.dart';
import 'package:grow_x/constants/app_fonts.dart';
import 'package:grow_x/constants/app_sizes.dart';
import 'package:grow_x/constants/app_styling.dart';
import 'package:grow_x/controllers/home/home_controller.dart';
import 'package:grow_x/core/constants/firebase_collection_references.dart';
import 'package:grow_x/core/constants/instances_constants.dart';
import 'package:grow_x/generated/assets.dart';
import 'package:grow_x/view/widgets/common_image_view_widget.dart';
import 'package:grow_x/view/widgets/my_text_widget.dart';
import 'package:grow_x/view/widgets/simple_app_bar.dart';
import 'package:intl/intl.dart';

class TeamMembers extends StatefulWidget {
  const TeamMembers({super.key});

  @override
  State<TeamMembers> createState() => _TeamMembersState();
}

class _TeamMembersState extends State<TeamMembers> {
  final HomeController controller2 = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    String? currentUserReferralLink = controller2.referralLink.value;
    log(controller2.referralLink.value);
    return Stack(children: [
      CommonImageView(
        imagePath: Assets.imagesWaves,
        width: Get.width,
        height: Get.height,
        fit: BoxFit.cover,
      ),
      SafeArea(
          child: Scaffold(
        appBar: simpleAppBar(context: context),
        backgroundColor: Colors.transparent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MyText(
              text: 'Team Members',
              paddingLeft: 20,
              fontFamily: AppFonts.PLAY,
              size: 22,
              weight: FontWeight.bold,
              paddingBottom: 16,
            ),
            Expanded(
                child: ListView(children: [
              StreamBuilder(
                stream: users2Collection
                    .where('referrerCode', isEqualTo: currentUserReferralLink)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.data!.docs.isEmpty) {
                    // Added this condition to handle empty data
                    return Padding(
                      padding: AppSizes.DEFAULT_HORIZONTAL,
                      child: Container(
                        decoration: rounded(kPrimaryColor),
                        height: 200,
                        child: Center(
                          child: MyText(
                            text: 'No members found',
                            size: 18,
                            weight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  } else {
                    final userinfos = snapshot
                        .data!.docs; // Corrected accessing the docs property

                    return SizedBox(
                      height: Get.height,
                      child: ListView.builder(
                        itemCount: userinfos.length,
                        itemBuilder: (context, index) {
                          final userinfo = userinfos[index];

                          DateTime createdAt = userinfo['joinedOn'].toDate();

                          String formattedCreatedAt =
                              DateFormat("d-M-yyyy , h:mma").format(createdAt);

                          return Padding(
                            padding: AppSizes.DEFAULT_PADDING,
                            child: Container(
                              decoration: rounded(
                                kPrimaryColor,
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 20,
                                    right: 20,
                                    child: CommonImageView(
                                      imagePath: Assets.imagesProfile,
                                      height: 50,
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      MyText(
                                        paddingTop: 10,
                                        text: 'Name: ${userinfo['username']}',
                                        size: 16,
                                        weight: FontWeight.bold,
                                      ),
                                      Row(
                                        children: [
                                          MyText(
                                            text: 'Email: ${userinfo['email']}',
                                            paddingLeft: 20,
                                            paddingTop: 10,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          MyText(
                                            text:
                                                'Phone: ${userinfo['phone']} ',
                                            paddingLeft: 20,
                                            paddingTop: 10,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          MyText(
                                            text:
                                                'Level: ${userinfo['level'].toString()} ',
                                            paddingLeft: 20,
                                            paddingTop: 10,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: MyText(
                                              text:
                                                  'Joined On:\n ${formattedCreatedAt} ',
                                              paddingBottom: 20,
                                              paddingLeft: 20,
                                              paddingTop: 10,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ]))
          ],
        ),
      ))
    ]);
  }
}
