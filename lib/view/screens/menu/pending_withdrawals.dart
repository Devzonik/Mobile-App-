import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grow_x/constants/app_colors.dart';
import 'package:grow_x/constants/app_sizes.dart';
import 'package:grow_x/constants/app_styling.dart';
import 'package:grow_x/controllers/home/withdraw_controller.dart';
import 'package:grow_x/core/constants/firebase_collection_references.dart';
import 'package:grow_x/generated/assets.dart';
import 'package:grow_x/view/widgets/common_image_view_widget.dart';
import 'package:grow_x/view/widgets/my_text_widget.dart';
import 'package:intl/intl.dart';

class PendingWithdrawals extends StatefulWidget {
  const PendingWithdrawals({Key? key});

  @override
  State<PendingWithdrawals> createState() => _PendingWithdrawalsState();
}

class _PendingWithdrawalsState extends State<PendingWithdrawals> {
  final WithdrawController controller = Get.find<WithdrawController>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: withdrawalRequestCollection
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('status', isEqualTo: 'pending')
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
                  text: 'No items found',
                  size: 18,
                  weight: FontWeight.bold,
                ),
              ),
            ),
          );
        } else {
          final requests =
              snapshot.data!.docs; // Corrected accessing the docs property

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              double deductedamount = double.parse(request['amount']) * 0.05;

              deductedamount = double.parse(request['amount']) - deductedamount;

              DateTime createdAt = request['createdat'].toDate();

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
                          imagePath: Assets.imagesPending,
                          height: 50,
                        ),
                      ),
                      Column(
                        children: [
                          MyText(
                            paddingTop: 10,
                            text: 'Name: ${request['accountHolderName']}',
                            size: 16,
                            weight: FontWeight.bold,
                          ),
                          Row(
                            children: [
                              MyText(
                                text: 'Bank Name: ${request['bankName']}',
                                paddingLeft: 20,
                                paddingTop: 10,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              MyText(
                                text:
                                    'Account Number: ${request['accountNumber']}',
                                paddingLeft: 20,
                                paddingTop: 10,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              MyText(
                                text:
                                    'Amount: ${request['amount'].toString()} ',
                                paddingLeft: 20,
                                paddingTop: 10,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              MyText(
                                text: 'Amount after 5% Withdrawal fees: ',
                                paddingLeft: 20,
                                paddingTop: 10,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              MyText(
                                text:
                                    '${deductedamount.toStringAsFixed(0).toString()} Rs',
                                weight: FontWeight.bold,
                                paddingLeft: 20,
                                paddingTop: 10,
                                size: 20,
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: MyText(
                                  text:
                                      'Request Submission date:\n ${formattedCreatedAt} ',
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
          );
        }
      },
    );
  }
}
