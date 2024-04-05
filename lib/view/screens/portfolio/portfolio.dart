import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grow_x/constants/app_colors.dart';
import 'package:grow_x/constants/app_fonts.dart';
import 'package:grow_x/constants/app_sizes.dart';
import 'package:grow_x/generated/assets.dart';
import 'package:grow_x/view/screens/auth/login.dart';
import 'package:grow_x/view/screens/portfolio/claimed.dart';
import 'package:grow_x/view/screens/portfolio/completed.dart';
import 'package:grow_x/view/screens/portfolio/running.dart';
import 'package:grow_x/view/widgets/common_image_view_widget.dart';
import 'package:grow_x/view/widgets/my_text_widget.dart';

class Portfolio extends StatefulWidget {
  Portfolio({super.key, this.hasback});
  bool? hasback;
  @override
  State<Portfolio> createState() => _PortfolioState();
}

class _PortfolioState extends State<Portfolio> {
  int _currentIndex = 0;

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<Map<String, String>> _tabs = [
    {'label': 'Running', 'imagePath': Assets.imagesHourglass},
    {'label': 'Completed', 'imagePath': Assets.imagesComplete},
    {'label': 'Claimed', 'imagePath': Assets.imagesClaim},
  ];

  final List<Widget> tabBarView = [
    const Running(),
    const Completed(),
    const Claimed()
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
              backgroundColor: Colors.transparent,
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: AppSizes.DEFAULT_PADDING,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        widget.hasback == true
                            ? InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Icon(
                                  Icons.arrow_back,
                                  color: kSecondaryColor,
                                ),
                              )
                            : const ImageIcon(
                                AssetImage(Assets.imagesBlack),
                                color: kSecondaryColor,
                                size: 50,
                              ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const ImageIcon(
                              AssetImage(Assets.imagesSettings),
                              color: kSecondaryColor,
                              size: 20,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            InkWell(
                              onTap: () {
                                FirebaseAuth.instance.signOut();
                                Get.offAll(() => Login());
                              },
                              child: const ImageIcon(
                                AssetImage(Assets.imagesLogout2),
                                color: kSecondaryColor,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  MyText(
                    text: 'Portfolio',
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
