import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:grow_x/constants/app_colors.dart';
import 'package:grow_x/view/widgets/my_button.dart';
import 'package:grow_x/view/widgets/my_text_widget.dart';

class DialogService {
  //singleton instance
  static DialogService get instance => DialogService();

  void showProgressDialog({required BuildContext context}) {
    //showing progress indicator
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Center(child: CircularProgressIndicator())));
  }

  quitAppDialogue({required VoidCallback onTap}) {
    return Container(
      color: kBlack2Color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MyText(
            text: 'Are you sure you want to quit app?',
            size: 15,
            weight: FontWeight.w700,
            textAlign: TextAlign.center,
            paddingTop: 32,
            paddingBottom: 16,
          ),
          SizedBox(
            height: 18,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: MyButton(
                  buttonText: 'No',
                  fillColor: kGreenColor,
                  // weight: FontWeight.w500,
                  onTap: () {
                    Get.back();
                  },
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: MyButton(
                  buttonText: 'Yes',
                  //  weight: FontWeight.w500,
                  onTap: onTap,
                  fillColor: kRedColor,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
