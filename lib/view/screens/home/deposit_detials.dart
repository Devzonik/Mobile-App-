import 'dart:developer';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:grow_x/constants/app_colors.dart';
import 'package:grow_x/constants/app_fonts.dart';
import 'package:grow_x/constants/app_sizes.dart';
import 'package:grow_x/constants/app_styling.dart';
import 'package:grow_x/controllers/home/deposit_controller.dart';
import 'package:grow_x/core/utils/snackbars.dart';
import 'package:grow_x/core/utils/validators.dart';
import 'package:grow_x/generated/assets.dart';
import 'package:grow_x/view/widgets/common_image_view_widget.dart';
import 'package:grow_x/view/widgets/custom_drop_down.dart';
import 'package:grow_x/view/widgets/my_button.dart';
import 'package:grow_x/view/widgets/my_text_field.dart';
import 'package:grow_x/view/widgets/my_text_widget.dart';
import 'package:grow_x/view/widgets/simple_app_bar.dart';

class DepositDetails extends StatefulWidget {
  const DepositDetails({super.key});

  @override
  State<DepositDetails> createState() => _DepositDetailsState();
}

class _DepositDetailsState extends State<DepositDetails> {
  DepositController controller = Get.find<DepositController>();
  bool isLoading = false;
  final depositForm = GlobalKey<FormState>();
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
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    MyText(
                      text: 'Bank Details',
                      fontFamily: AppFonts.PLAY,
                      size: 22,
                      weight: FontWeight.bold,
                      paddingBottom: 16,
                    ),
                    MyText(
                      text: 'Bank Name',
                      size: 14,
                      paddingBottom: 16,
                      weight: FontWeight.bold,
                    ),
                    Container(
                      height: 50,
                      decoration: rounded(kPrimaryColor),
                      child: Center(
                        child: MyText(
                          textAlign: TextAlign.center,
                          text: 'Meezan bank',
                          color: kSecondaryColor,
                          weight: FontWeight.bold,
                          size: 20,
                        ),
                      ),
                    ),
                    MyText(
                      text: 'Account Holder Name',
                      paddingTop: 16,
                      size: 14,
                      paddingBottom: 16,
                      weight: FontWeight.bold,
                    ),
                    Container(
                        height: 50,
                        decoration: rounded(kPrimaryColor),
                        child: Center(
                          child: MyText(
                            text: 'KHAN AGRICULTURE TRADERS',
                            weight: FontWeight.bold,
                          ),
                        )),
                    MyText(
                      text: 'Account Number',
                      size: 14,
                      paddingTop: 16,
                      paddingBottom: 16,
                      weight: FontWeight.bold,
                    ),
                    Container(
                        height: 70,
                        decoration: rounded(kPrimaryColor),
                        child: Center(
                          child: ListTile(
                            title: MyText(
                              text: '68020109286122',
                              size: 19,
                              fontFamily: AppFonts.PLAY,
                            ),
                            trailing: InkWell(
                              onTap: () {
                                _copyToClipboard('68020109286122');
                                Get.snackbar('Copied', '');
                              },
                              child: Icon(
                                Icons.copy,
                                size: 18,
                                color: kBlack2Color,
                              ),
                            ),
                          ),
                        )),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      decoration: rounded(kRedColor),
                      height: 150,
                      child: Center(
                        child: MyText(
                            paddingLeft: 16,
                            paddingRight: 16,
                            color: kPrimaryColor,
                            weight: FontWeight.bold,
                            text:
                                'NOTE: Send amount(you want to deposit) to the above mentioned account. And upload the payment proof below, the amount will be added to your wallet, once admin verify the transanction'),
                      ),
                    ),
                    MyText(
                      paddingTop: 16,
                      text: 'Enter Transanction Details',
                      fontFamily: AppFonts.PLAY,
                      size: 18,
                      weight: FontWeight.bold,
                      paddingBottom: 16,
                    ),
                    Form(
                      key: depositForm,
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: kPrimaryColor.withOpacity(0.8)),
                          child: Padding(
                            padding: AppSizes.DEFAULT_HORIZONTAL,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    MyText(
                                      text: 'Sender Bank Name',
                                      paddingTop: 30,
                                      paddingBottom: 16,
                                    ),
                                  ],
                                ),
                                Obx(() => CustomDropDown(
                                    bgColor: kSecondaryColor.withOpacity(0.4),
                                    hint: controller
                                            .selectedBankName.value.isEmpty
                                        ? 'Select Bank'
                                        : controller.selectedBankName.value,
                                    items: const [
                                      'Easypaisa',
                                      'Jazzcash',
                                      'Sadapay',
                                      'Nayapay',
                                      'Bank Al-Habib',
                                      'Meezan Bank',
                                      'RAAST',
                                      'United Bank Limited (UBL)',
                                      'National Bank of Pakistan (NBP)',
                                      'MCB Bank Limited ',
                                      'Allied Bank Limited (ABL)',
                                      'Askari Bank Limited',
                                      'Bank Alfalah Limited',
                                      'Faysal Bank Limited',
                                      'Bank Al Habib Limited',
                                      'Standard Chartered Bank',
                                      'Summit Bank Limited',
                                      'Silkbank Limited',
                                      'Sindh Bank Limited',
                                      'BankIslami Pakistan Limited',
                                      'The Bank of Punjab (BOP)',
                                      'JS Bank Limited',
                                      'Al Baraka Bank (Pakistan)',
                                      'Dubai Islamic Bank Pakistan',
                                      'Bank of Khyber (BOK)',
                                      'Soneri Bank',
                                      'Zarai Taraqiati Bank Limited (ZTBL)',
                                      'Samba Bank',
                                    ],
                                    onChanged: (Value) {
                                      controller.selectedBankName.value = Value;
                                    })),
                                Row(
                                  children: [
                                    MyText(
                                      text: 'Account Holder Name',
                                      paddingTop: 15,
                                      paddingBottom: 16,
                                    ),
                                  ],
                                ),
                                MyTextField(
                                  controller:
                                      controller.accHolderNameController,
                                  validator:
                                      ValidationService.instance.emptyValidator,
                                ),
                                Row(
                                  children: [
                                    MyText(
                                      text: 'Sender Account Number ',
                                      paddingTop: 15,
                                      paddingBottom: 16,
                                    ),
                                  ],
                                ),
                                MyTextField(
                                  hintText: 'last 4 digits',
                                  keyboardType: TextInputType.number,
                                  controller: controller.accNumberController,
                                  validator: ValidationService
                                      .instance.fourDigitsValidator,
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
                                  keyboardType: TextInputType.number,
                                  controller: controller.amountController,
                                  validator:
                                      ValidationService.instance.emptyValidator,
                                ),
                                Row(
                                  children: [
                                    MyText(
                                      text: 'Reciept Image',
                                      paddingTop: 15,
                                      paddingBottom: 16,
                                    ),
                                  ],
                                ),
                                ListTile(
                                  contentPadding: EdgeInsets.all(0),
                                  leading: GestureDetector(
                                    onTap: () async {
                                      await controller.selectImageFromGallery();

                                      updateImageUI(); // You can use this for gallery
                                      // OR
                                      // await selectImageFromCamera(); // You can use this for camera
                                      // Update UI as needed after image selection
                                      updateImageUI();
                                      setState(() {});
                                    },
                                    child: DottedBorder(
                                      borderType: BorderType.RRect,
                                      radius: Radius.circular(12),
                                      dashPattern: const [4, 4, 4],
                                      padding: EdgeInsets.all(0),
                                      color: kSecondaryColor,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)),
                                        child: Container(
                                          padding: EdgeInsets.all(0),
                                          height: 57,
                                          width: 72,
                                          color:
                                              kSecondaryColor.withOpacity(0.2),
                                          child: Center(
                                            child: controller
                                                    .pickedImages.isNotEmpty
                                                ? Image.file(
                                                    File(controller.pickedImages
                                                        .first.path),
                                                    height: 57,
                                                    width: 72,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Icon(
                                                    Icons.add,
                                                    color: kSecondaryColor,
                                                    size: 30,
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  title: controller.pickedImages.isNotEmpty
                                      ? MyText(
                                          text: 'Added',
                                          color: kGreenColor,
                                        )
                                      : RichText(
                                          text: TextSpan(children: const [
                                            TextSpan(
                                              text: 'Tap',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: kSecondaryColor),
                                            ),
                                            TextSpan(
                                              text: ' to add',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: kSecondaryColor2),
                                            )
                                          ]),
                                        ),
                                  subtitle: MyText(
                                    text: 'choose your receipt image',
                                    size: 12,
                                    color: kGrey5Color,
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                isLoading == true
                                    ? Container(
                                        decoration: rounded(kSecondaryColor),
                                        height: 35,
                                        child: Center(
                                            child: CircularProgressIndicator()),
                                      )
                                    : MyButton(
                                        buttonText: 'Deposit',
                                        onTap: () {
                                          if (depositForm.currentState!
                                                  .validate() &&
                                              controller.selectedBankName.value
                                                  .isNotEmpty) {
                                            // Check if the user has picked an image
                                            if (controller
                                                .pickedImages.isNotEmpty) {
                                              setState(() {
                                                isLoading = true;
                                              });
                                              // Update UI as needed after image selection
                                              updateImageUI();
                                              log(controller
                                                  .amountController.text
                                                  .trim());
                                              //    log(controller.pickedImages);
                                              controller.submitDeposit(
                                                  context,
                                                  controller
                                                      .amountController.text
                                                      .trim(),
                                                  controller.pickedImages);
                                              setState(() {
                                                isLoading = false;
                                              });
                                              CustomSnackBars.instance
                                                  .showSuccessSnackbar(
                                                      title:
                                                          "Successful Completion",
                                                      message:
                                                          "It will take some time until we verify your transanction");
                                              controller.bankNameController
                                                  .clear();
                                              controller.accNumberController
                                                  .clear();
                                              controller.accHolderNameController
                                                  .clear();
                                              controller.amountController
                                                  .clear();
                                              controller.pickedImages.clear();

                                              Navigator.pop(context, true);
                                            } else {
                                              // Show a message to the user indicating that an image must be selected
                                              CustomSnackBars.instance
                                                  .showFailureSnackbar(
                                                title: "Image Selection",
                                                message:
                                                    "Please select an image before proceeding.",
                                              );
                                            }
                                          }
                                        },
                                        height: 38,
                                      ),
                                SizedBox(
                                  height: 30,
                                )
                              ],
                            ),
                          )),
                    ),
                    SizedBox(
                      height: 100,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }

  void updateImageUI() {
    // Implement UI updates after image selection, if needed
    controller.update(); // You can use this to trigger a redraw of the widget
  }
}
