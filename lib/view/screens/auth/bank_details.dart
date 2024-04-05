import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grow_x/constants/app_colors.dart';
import 'package:grow_x/constants/app_fonts.dart';
import 'package:grow_x/controllers/auth/bank_details_controller.dart';
import 'package:grow_x/core/constants/firebase_collection_references.dart';
import 'package:grow_x/core/utils/snackbars.dart';
import 'package:grow_x/core/utils/validators.dart';
import 'package:grow_x/view/screens/auth/login.dart';
import 'package:grow_x/view/screens/auth/signup.dart';
import 'package:grow_x/view/screens/bottom_nav_bar/persistent_nav_bar.dart';
import 'package:grow_x/view/widgets/custom_drop_down.dart';
import 'package:grow_x/view/widgets/my_button.dart';
import 'package:grow_x/view/widgets/my_text_field.dart';
import 'package:grow_x/view/widgets/my_text_widget.dart';

class BankDetails extends StatefulWidget {
  const BankDetails({super.key});

  @override
  State<BankDetails> createState() => _BankDetailsState();
}

class _BankDetailsState extends State<BankDetails> {
  BankDetailsController controller = Get.find<BankDetailsController>();
  final bankdetailsformkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          signupWaveBackground(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Form(
                  key: bankdetailsformkey,
                  child: ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      MyText(
                        paddingTop: 30,
                        text: 'Add Bank Details',
                        size: 24,
                        weight: FontWeight.bold,
                        fontFamily: AppFonts.PLAY,
                      ),
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
                          bgColor: kPrimaryColor,
                          hint: controller.selectedBankName.value.isEmpty
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
                        controller: controller.accHolderNameController,
                        validator: ValidationService.instance.emptyValidator,
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
                        hintText: '',
                        keyboardType: TextInputType.number,
                        controller: controller.accNumberController,
                        validator: ValidationService.instance.emptyValidator,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      MyButton(
                          buttonText: 'Save Details',
                          onTap: () {
                            if (bankdetailsformkey.currentState!.validate() &&
                                controller.selectedBankName.value.isNotEmpty) {
                              controller.saveBankDetails();
                              CustomSnackBars.instance.showSuccessSnackbar(
                                  title: "Saved Successfully",
                                  message: "Your Bank details are now saved");
                              Get.offAll(() => Login());
                            }
                          })
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
