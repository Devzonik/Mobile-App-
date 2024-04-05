import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grow_x/config/routes/custom_route_widget.dart';
import 'package:grow_x/constants/app_colors.dart';
import 'package:grow_x/constants/app_fonts.dart';
import 'package:grow_x/constants/app_sizes.dart';
import 'package:grow_x/constants/app_styling.dart';
import 'package:grow_x/generated/assets.dart';
import 'package:grow_x/view/screens/home/deposit_detials.dart';
import 'package:grow_x/view/widgets/common_image_view_widget.dart';
import 'package:grow_x/view/widgets/my_text_widget.dart';
import 'package:grow_x/view/widgets/range_selector.dart';
import 'package:grow_x/view/widgets/simple_app_bar.dart';

class Deposit extends StatefulWidget {
  const Deposit({super.key});

  @override
  State<Deposit> createState() => _DepositState();
}

class _DepositState extends State<Deposit> {
  String selectedCategory = '';
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
                      text: 'Select Deposit Range',
                      fontFamily: AppFonts.PLAY,
                      size: 22,
                      weight: FontWeight.bold,
                      paddingBottom: 16,
                    ),
                    RangeSelector(
                      selectedRange: selectedCategory,
                      onRangeSelected: (category) {
                        setState(() {
                          selectedCategory = category;
                        });
                      },
                    )
                  ],
                ),
              ),
              Padding(
                padding: AppSizes.DEFAULT_HORIZONTAL,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                            CustomPageRoute(page: const DepositDetails()));
                      },
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: circle(kSecondaryColor, kSecondaryColor),
                        child: Center(
                            child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: kPrimaryColor,
                        )),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 100,
              )
            ],
          ),
        ),
      ],
    );
  }
}
