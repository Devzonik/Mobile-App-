import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grow_x/constants/app_colors.dart';
import 'package:grow_x/constants/constants.dart';
import 'package:grow_x/controllers/bottom_nav_bar_controller.dart';
import 'package:grow_x/view/widgets/my_text_widget.dart';

import '../../../generated/assets.dart';

class PersistentBottomNavBar extends StatefulWidget {
  const PersistentBottomNavBar({super.key});

  @override
  State<PersistentBottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<PersistentBottomNavBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // showCaseController.initShowCase(context);
      _animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      );
    });
  }

  @override
  void dispose() {
    //_pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> _items = [
    {
      'label': 'Home',
      'icon': Assets.imagesHome,
    },
    {
      'label': 'Portfolio',
      'icon': Assets.imagesPortfolio,
    },
    {
      'label': 'Team',
      'icon': Assets.imagesTeam,
    },
    {
      'label': 'Menu',
      'icon': Assets.imagesMenu,
    },
  ];

  final empty1 = GlobalKey();

  final empty2 = GlobalKey();

  final empty3 = GlobalKey();

  final empty4 = GlobalKey();

  bool isAlertDialogueVisible = false;
  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        bool value = await navBarController.onBackTap(context);
        return value;
      },
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            navBarController.buildOffStageNavigator(
              BottomNavBarController.HOME,
            ),
            navBarController.buildOffStageNavigator(
              BottomNavBarController.PORTFOLIO,
            ),
            navBarController.buildOffStageNavigator(
              BottomNavBarController.TEAM,
            ),
            navBarController.buildOffStageNavigator(
              BottomNavBarController.MENU,
            ),
          ],
        ),
        bottomNavigationBar: _BuildBottomNavBar(),
      ),
    );
  }

  Obx _BuildBottomNavBar() {
    return Obx(
      () {
        return Container(
          height: Platform.isIOS ? null : 82,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Container(
            color: kBlueColor.withOpacity(0.1),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60), topRight: Radius.circular(60)),
              child: BottomAppBar(
                elevation: 0,
                color: kSecondaryColor,
                height: 90,
                shape: const AutomaticNotchedShape(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(60),
                            topRight: Radius.circular(10))),
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(80)))),
                notchMargin: 0,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNavItem(
                        0,
                      ),
                      _buildNavItem(
                        1,
                      ),
                      _buildNavItem(
                        2,
                      ),
                      _buildNavItem(
                        3,
                      ),
                    ]),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem(int index) {
    bool isSelected = navBarController.currentIndex.value == index;

    return Padding(
      padding: const EdgeInsets.only(top: 16.0, right: 8, left: 8),
      child: Stack(
        children: [
          InkWell(
            onTap: () => _onItemTapped(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: ImageIcon(
                    AssetImage(
                      _items[index]['icon'],
                    ),
                    size: 24,
                    color: isSelected ? kPrimaryColor : kTertiaryColor,
                  ),
                ),
                MyText(
                  size: 10,
                  text: _items[index]['label'],
                  color: isSelected ? kPrimaryColor : kTertiaryColor,
                  weight: FontWeight.bold,
                ),
                if (isSelected)
                  Icon(
                    Icons.circle,
                    color: kSecondaryColor2,
                    size: 5,
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    navBarController.getCurrentScreen(
        navBarController.pageRoutes[index], index);
    if (navBarController.pageRoutes[index] == 1) {
      setState(() {});
    }
  }
}
