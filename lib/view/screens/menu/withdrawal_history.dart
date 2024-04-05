import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grow_x/constants/app_colors.dart';
import 'package:grow_x/constants/app_fonts.dart';
import 'package:grow_x/constants/app_sizes.dart';
import 'package:grow_x/generated/assets.dart';
import 'package:grow_x/view/screens/menu/claimed_withdrawals.dart';
import 'package:grow_x/view/screens/menu/pending_withdrawals.dart';
import 'package:grow_x/view/screens/menu/withdrawal_rejected.dart';
import 'package:grow_x/view/widgets/common_image_view_widget.dart';
import 'package:grow_x/view/widgets/my_text_widget.dart';
import 'package:grow_x/view/widgets/simple_app_bar.dart';

class ManageWithdrawals extends StatefulWidget {
  const ManageWithdrawals({super.key});

  @override
  State<ManageWithdrawals> createState() => _ManageWithdrawalsState();
}

class _ManageWithdrawalsState extends State<ManageWithdrawals> {
  int _currentIndex = 0;

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<Map<String, String>> _tabs = [
    {'label': 'Pending', 'imagePath': Assets.imagesPending},
    {'label': 'Received', 'imagePath': Assets.imagesRecieved},
    {'label': 'Rejected', 'imagePath': Assets.imagesRejected},
  ];

  final List<Widget> tabBarView = [
    const PendingWithdrawals(),
    const ClaimedWithdrawals(),
    const RejectedWithdrawals()
  ];
  @override
  Widget build(BuildContext context) {
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
                    text: 'Withdrawals ',
                    paddingLeft: 20,
                    fontFamily: AppFonts.PLAY,
                    size: 22,
                    weight: FontWeight.bold,
                    paddingBottom: 16,
                  ),
                  Padding(
                    padding: AppSizes.DEFAULT_PADDING,
                    child: Container(
                      height: 80.87,
                      width: 400,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: List.generate(
                          _tabs.length,
                          (index) {
                            final label = _tabs[index]['label'];
                            return Expanded(
                              child: GestureDetector(
                                onTap: () => _onTap(index),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 180),
                                    height: Get.height,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 2,
                                          color: _currentIndex == index
                                              ? kPrimaryColor
                                              : Colors.transparent),
                                      borderRadius: BorderRadius.circular(10),
                                      color: _currentIndex == index
                                          ? kPrimaryColor.withOpacity(0.2)
                                          : kPrimaryColor,
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          CommonImageView(
                                            imagePath: _tabs[index]
                                                ['imagePath']!,
                                            height: 30,
                                          ),
                                          MyText(
                                            text: label!,
                                            size: 13,
                                            weight: FontWeight.bold,
                                            color: _currentIndex == index
                                                ? kSecondaryColor
                                                : kGrey8Color,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      child: IndexedStack(
                    index: _currentIndex,
                    children: tabBarView,
                  )),
                ],
              )))
    ]);
  }
}
