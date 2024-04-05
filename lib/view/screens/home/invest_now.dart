import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grow_x/config/routes/custom_route_widget.dart';
import 'package:grow_x/constants/app_colors.dart';
import 'package:grow_x/constants/app_fonts.dart';
import 'package:grow_x/constants/app_styling.dart';
import 'package:grow_x/controllers/home/invest_controller.dart';
import 'package:grow_x/core/utils/snackbars.dart';
import 'package:grow_x/generated/assets.dart';
import 'package:grow_x/view/screens/bottom_nav_bar/persistent_nav_bar.dart';
import 'package:grow_x/view/widgets/common_image_view_widget.dart';
import 'package:grow_x/view/widgets/my_button.dart';
import 'package:grow_x/view/widgets/my_text_field.dart';
import 'package:grow_x/view/widgets/my_text_widget.dart';
import 'package:grow_x/view/widgets/simple_app_bar.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class InvestNow extends StatefulWidget {
  InvestNow(
      {super.key,
      required this.deposit,
      required this.days,
      required this.planName,
      required this.profit,
      required this.range,
      required this.pid,
      required this.lowerrange,
      required this.upperlinmit});
  final String planName;
  final String range, pid;
  final double days, profit, deposit, upperlinmit, lowerrange;
  @override
  State<InvestNow> createState() => _InvestNowState();
}

final InvestController controller = Get.find<InvestController>();

class _InvestNowState extends State<InvestNow> {
  String formattedDateTime =
      DateFormat("d-M-yyyy , h:mma").format(DateTime.now());

  final investform = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    DateTime enddate = DateTime.now().add(Duration(days: widget.days.toInt()));
    String formattedendTime = DateFormat("d-M-yyyy , h:mma").format(enddate);

    return Stack(children: [
      CommonImageView(
        imagePath: Assets.imagesWaves,
        width: Get.width,
        height: Get.height,
        fit: BoxFit.cover,
      ),
      Scaffold(
        backgroundColor: Colors.transparent,
        appBar: simpleAppBar(context: context),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Form(
                key: investform,
                child: ListView(
                  shrinkWrap: true,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    CommonImageView(
                        imagePath: Assets.imagesSuccess,
                        height: 100,
                        fit: BoxFit.contain),
                    MyText(
                      text: widget.planName,
                      size: 22,
                      fontFamily: AppFonts.PLAY,
                      paddingBottom: 10,
                      textAlign: TextAlign.center,
                    ),
                    MyText(
                      text: '${widget.days.toStringAsFixed(0)} Day',
                      paddingBottom: 10,
                      textAlign: TextAlign.center,
                      size: 18,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyText(
                          text: 'Current Balance: ',
                          weight: FontWeight.bold,
                          textAlign: TextAlign.center,
                          size: 18,
                        ),
                        MyText(
                          text: widget.deposit.toString(),
                          size: 18,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 200,
                            decoration: rounded2(kPrimaryColor),
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  MyText(
                                    text: 'Profit',
                                    fontFamily: AppFonts.PLAY,
                                    size: 16,
                                  ),
                                  CommonImageView(
                                    imagePath: Assets.imagesProfits,
                                    height: 50,
                                  ),
                                  MyText(
                                    text: '${widget.profit.toString()}%',
                                    size: 20,
                                    weight: FontWeight.bold,
                                  )
                                ]),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Container(
                            height: 200,
                            decoration: rounded2(kPrimaryColor),
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  MyText(
                                    text: 'Invest Range',
                                    fontFamily: AppFonts.PLAY,
                                    size: 16,
                                  ),
                                  CommonImageView(
                                    imagePath: Assets.imagesRange,
                                    height: 50,
                                  ),
                                  MyText(
                                    text: widget.range,
                                    size: 20,
                                    weight: FontWeight.bold,
                                  )
                                ]),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    MyTextField(
                      controller: controller.amountctrl,
                      validator: (value) =>
                          controller.validateAmount(value, widget.range),
                      hintText: 'Enter Investent Amount',
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    MyText(
                      text:
                          'Your Profit will be: ${calculateProfit()} per day\n',
                      size: 16,
                      color: kRedColor,
                      weight: FontWeight.bold,
                    ),
                    Container(
                      decoration: rounded2(kPrimaryColor.withOpacity(0.5)),
                      child: DataTable(
                        columns: [
                          DataColumn(label: Text('Title')),
                          DataColumn(label: Text('Data')),
                        ],
                        rows: [
                          DataRow(cells: [
                            DataCell(MyText(
                              text: 'Start Date',
                              color: kSecondaryColor,
                              weight: FontWeight.bold,
                              size: 14,
                            )),
                            DataCell(Text('$formattedDateTime')),
                          ]),
                          DataRow(cells: [
                            DataCell(MyText(
                              text: 'End Date',
                              color: kSecondaryColor,
                              weight: FontWeight.bold,
                              size: 14,
                            )),
                            DataCell(Text(formattedendTime)),
                          ]),
                          DataRow(cells: [
                            DataCell(MyText(
                              text: 'Profit per day',
                              color: kSecondaryColor,
                              weight: FontWeight.bold,
                              size: 14,
                            )),
                            DataCell(Text('Rs.${calculateProfit()}')),
                          ]),
                          DataRow(cells: [
                            DataCell(MyText(
                              text:
                                  'Total ${widget.days.toStringAsFixed(0)} days Profit',
                              color: kSecondaryColor,
                              weight: FontWeight.bold,
                              size: 14,
                            )),
                            DataCell(Text('${calculateTotalprofit()}')),
                          ]),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    MyButton(
                        buttonText: 'Submit',
                        onTap: () {
                          if (investform.currentState!.validate()) {
                            double? amount =
                                double.tryParse(controller.amountctrl.text);
                            if (amount != null && amount > 0) {
                              log("$widget.deposit");
                              // log(widget.upperlinmit);
                              if (widget.deposit < amount) {
                                CustomSnackBars.instance.showFailureSnackbar(
                                    title: "Failed Invest",
                                    message:
                                        "you are out of deposit, please deposit more to continue");
                              } else {
                                if (widget.upperlinmit < amount) {
                                  CustomSnackBars.instance.showFailureSnackbar(
                                      title: "Failed Invest",
                                      message:
                                          "your remaining limit to invest is ${widget.upperlinmit} ");
                                } else if (amount <= widget.upperlinmit) {
                                  controller.addInvestmentData(widget.pid);
                                  CustomSnackBars.instance.showSuccessSnackbar(
                                    title: "Successful Completion",
                                    message: "Invested",
                                  );
                                  controller.amountctrl.clear();
                                  Navigator.of(context).pop();
                                }
                              }
                            }
                            //  controller.submitDeposit();
                          }
                        }),
                    SizedBox(
                      height: 100,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    ]);
  }

  String calculateProfit() {
    try {
      double amount = double.tryParse(controller.amountctrl.text) ?? 0;
      double profit = (amount * widget.profit / 100);
      return '$profit ';
    } catch (e) {
      return 'Invalid input';
    }
  }

  String calculateTotalprofit() {
    try {
      double amount = double.tryParse(controller.amountctrl.text) ?? 0;
      double profit = (amount * widget.profit / 100);
      return (profit * widget.days).toString();
    } catch (e) {
      return 'Invalid input';
    }
  }
}
