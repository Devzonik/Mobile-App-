import 'package:flutter/material.dart';
import 'package:grow_x/constants/app_colors.dart';
import 'package:grow_x/constants/app_styling.dart';
import 'package:grow_x/generated/assets.dart';
import 'package:grow_x/view/widgets/common_image_view_widget.dart';
import 'package:grow_x/view/widgets/my_text_widget.dart';

class PlanTile extends StatelessWidget {
  PlanTile(
      {super.key,
      required this.day,
      required this.depositlimit,
      required this.name,
      required this.profit,
      required this.ontap});
  String name, day, depositlimit, profit;
  VoidCallback ontap;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      decoration: rounded(kPrimaryColor),
      child: Column(children: [
        ListTile(
          title: MyText(
            text: '$name Plan',
            paddingBottom: 5,
            size: 14,
            weight: FontWeight.bold,
          ),
          subtitle: MyText(text: '$day days package'),
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 40,
                decoration: const BoxDecoration(color: kSecondaryColor),
                child: Center(
                    child: MyText(
                  text: '$profit% daily profit',
                  color: kPrimaryColor,
                  size: 16,
                  weight: FontWeight.bold,
                )),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  MyText(
                    paddingLeft: 10,
                    weight: FontWeight.bold,
                    text: 'Range:\n$depositlimit',
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              InkWell(
                onTap: ontap,
                child: Container(
                  width: 120,
                  height: 36,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: kSecondaryColor),
                  child: Center(
                      child: MyText(
                    text: 'Invest Now',
                    weight: FontWeight.bold,
                    color: kPrimaryColor,
                  )),
                ),
              )
            ],
          ),
        )
      ]),
    );
  }
}
