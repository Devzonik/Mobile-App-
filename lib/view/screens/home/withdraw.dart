import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:grow_x/constants/app_colors.dart';
import 'package:grow_x/constants/app_fonts.dart';
import 'package:grow_x/constants/app_styling.dart';
import 'package:grow_x/controllers/home/withdraw_controller.dart';
import 'package:grow_x/core/constants/firebase_collection_references.dart';
import 'package:grow_x/core/utils/snackbars.dart';
import 'package:grow_x/core/utils/validators.dart';
import 'package:grow_x/generated/assets.dart';
import 'package:grow_x/view/widgets/common_image_view_widget.dart';
import 'package:grow_x/view/widgets/custom_drop_down.dart';
import 'package:grow_x/view/widgets/my_button.dart';
import 'package:grow_x/view/widgets/my_text_field.dart';
import 'package:grow_x/view/widgets/my_text_widget.dart';
import 'package:grow_x/view/widgets/simple_app_bar.dart';

class Withdraw extends StatefulWidget {
  Withdraw({
    super.key,
    required this.deposit,
  });
  double deposit;
  @override
  State<Withdraw> createState() => _WithdrawState();
}

WithdrawController controller = Get.find<WithdrawController>();

class _WithdrawState extends State<Withdraw> {
  final withdrawform = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? _user;

  List<DocumentSnapshot> _bankDetails = [];

  @override
  void initState() {
    super.initState();
    _fetchBankDetails();
  }

  Future<void> _fetchBankDetails() async {
    _user = _auth.currentUser;
    final String? currentUserId = _user?.uid;
    final bankDetailsSnapshot = await bankCollection
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    setState(() {
      _bankDetails = bankDetailsSnapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CommonImageView(
          imagePath: Assets.imagesWaves,
          width: Get.width,
          height: Get.height,
          fit: BoxFit.cover,
        ),
        Scaffold(
          appBar: simpleAppBar(context: context),
          backgroundColor: Colors.transparent,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    ImageIcon(
                      AssetImage(Assets.imagesWithdraw),
                      size: 100,
                      color: kSecondaryColor,
                    ),
                    MyText(
                      text: 'Withdrawal',
                      size: 24,
                      fontFamily: AppFonts.PLAY,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: withdrawform,
                      child: Container(
                        decoration: rounded2(kPrimaryColor.withOpacity(0.7)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Container(
                                height: 150,
                                decoration: rounded(kPrimaryColor),
                                child: _bankDetails.isEmpty
                                    ? Center(
                                        child: Text('No bank details found'),
                                      )
                                    : Column(
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          CommonImageView(
                                            imagePath: Assets.imagesBank,
                                            height: 30,
                                          ),
                                          Expanded(
                                            child: ListView.builder(
                                              itemCount: _bankDetails.length,
                                              itemBuilder: (context, index) {
                                                final bankDetail =
                                                    _bankDetails[index].data()
                                                        as Map<String, dynamic>;
                                                final bankName =
                                                    bankDetail['bankName'];
                                                final accountHolderName =
                                                    bankDetail[
                                                        'accountHolderName'];
                                                final accountNumber =
                                                    bankDetail['accountNumber'];
                                                return ListTile(
                                                  title: MyText(
                                                      text:
                                                          'Bank Name: $bankName'),
                                                  subtitle: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          MyText(
                                                              text:
                                                                  'Account Holder Name: $accountHolderName'),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          MyText(
                                                              text:
                                                                  'Account Number: $accountNumber'),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                              Row(
                                children: [
                                  MyText(
                                    text: 'Amount',
                                    paddingTop: 15,
                                    paddingBottom: 16,
                                  ),
                                ],
                              ),
                              MyTextField(
                                onChanged: (value) {
                                  setState(() {});
                                },
                                keyboardType: TextInputType.number,
                                controller: controller.amountctrl,
                                validator: (value) =>
                                    amountValidator(value, widget.deposit),
                              ),
                              MyButton(
                                  buttonText: 'Submit Request',
                                  onTap: () {
                                    log(controller.amountctrl.text);
                                    if (withdrawform.currentState!.validate()) {
                                      controller.addWithdrawalRequest(
                                          controller.amountctrl.text,
                                          calculateTotalprofit());
                                      CustomSnackBars.instance
                                          .showSuccessSnackbar(
                                              title: "Successful Completion",
                                              message: "Request Submitted");
                                      controller.amountctrl.clear();
                                      Navigator.pop(context);
                                    }
                                  }),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                decoration: rounded(kYellowColor),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: MyText(
                                    text:
                                        'Note: According to the policy, service charges will be deducted on every withdrawal, which is 5% of the total Amount',
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Row(
                                children: [
                                  MyText(
                                    text: 'Service Charges:',
                                    weight: FontWeight.bold,
                                  ),
                                  MyText(
                                    size: 26,
                                    text: ' 5% =  ${calculateProfit()}',
                                    weight: FontWeight.bold,
                                    fontFamily: AppFonts.PLAY,
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  MyText(
                                    text: 'You Received: ',
                                    weight: FontWeight.bold,
                                  ),
                                  MyText(
                                    size: 26,
                                    paddingBottom: 5,
                                    text: ' ${calculateTotalprofit()} ',
                                    weight: FontWeight.bold,
                                    fontFamily: AppFonts.PLAY,
                                  ),
                                  MyText(
                                    text: 'PKR',
                                    weight: FontWeight.bold,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String? amountValidator(String? value, double depositAmount) {
    // Perform validation based on the value and depositAmount
    if (value == null || value.isEmpty) {
      return "Field is required";
    }
    double? enteredAmount = double.tryParse(value);
    if (enteredAmount == null) {
      return "Invalid amount";
    }
    if (enteredAmount > depositAmount) {
      return "Amount cannot be greater than balance";
    }
    return null;
  }

  String calculateProfit() {
    try {
      double amount = double.tryParse(controller.amountctrl.text) ?? 0;
      double fees = (amount * 0.05);
      int feesAsInteger = fees.toInt();
      return '$feesAsInteger ';
    } catch (e) {
      return 'Invalid input';
    }
  }

  String calculateTotalprofit() {
    try {
      double amount = double.tryParse(controller.amountctrl.text) ?? 0;
      double fees = (amount * 0.05);
      double getamount = amount - fees;
      int feesAsInteger = getamount.toInt();
      return (feesAsInteger).toString();
    } catch (e) {
      return 'Invalid input';
    }
  }
}
