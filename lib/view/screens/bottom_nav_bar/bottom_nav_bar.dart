import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:grow_x/constants/app_colors.dart';
import 'package:grow_x/generated/assets.dart';
import 'package:grow_x/view/screens/home/home.dart';
import 'package:grow_x/view/widgets/my_text_widget.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({
    super.key,
  });

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar>
    with SingleTickerProviderStateMixin {
  int selectedIndex = 0;

  MotionTabBarController? _motionTabBarController;

  @override
  void initState() {
    super.initState();

    //// use "MotionTabBarController" to replace with "TabController", if you need to programmatically change the tab
    _motionTabBarController = MotionTabBarController(
      initialIndex: 1,
      length: 4,
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();

    _motionTabBarController!.dispose();
  }

  final List<Map<String, dynamic>> _items = [
    {
      'icon': Assets.imagesHome,
    },
    {
      'icon': Assets.imagesPortfolio,
    },
    {
      'icon': Assets.imagesTeam,
    },
    {
      'icon': Assets.imagesMenu,
    },
  ];
  final List<Widget> screens = [
    Home(),
    Home(),
    Home(),
    Home(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.black,
      body: TabBarView(controller: _motionTabBarController, children: [
        Home(),
        Home(),
        Home(),
        Home(),
      ]),

      // return null; // Return null to hide the bottom navigation bar
      bottomNavigationBar: MotionTabBar(
        controller:
            _motionTabBarController, // ADD THIS if you need to change your tab programmatically
        initialSelectedTab: "Home",
        labels: const ["Home", "Portfolio", "Team", "Menu"],
        icons: const [
          Icons.home,
          Icons.menu_book_outlined,
          Icons.people_alt,
          Icons.dashboard_outlined
        ],

        // optional badges, length must be same with labels

        tabSize: 50,
        tabBarHeight: 55,
        textStyle: const TextStyle(
          fontSize: 12,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        tabIconColor: kSecondaryColor,

        tabIconSize: 28.0,

        tabIconSelectedSize: 26.0,
        tabSelectedColor: kSecondaryColor,
        tabIconSelectedColor: Colors.white,
        tabBarColor: Colors.white,
        onTabItemSelected: (int value) {
          setState(() {
            // _tabController!.index = value;
            _motionTabBarController!.index = value;
          });
        },
      ),
    );
  }

  Widget _buildNavItem(int index, String label) {
    bool isSelected = selectedIndex == index;
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, right: 8, left: 8),
      child: InkWell(
        onTap: () => _onItemTapped(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ImageIcon(
                    AssetImage(
                      _items[index]['icon'],
                    ),
                    size: 50,
                    color: isSelected ? kPrimaryColor : kGrey4Color,
                  ),
                ],
              ),
            ),
            MyText(
              text: label,
              size: 10,
              color: isSelected ? kPrimaryColor : kGrey4Color,
              weight: FontWeight.bold,
            ),
            if (isSelected)
              Icon(
                Icons.circle,
                size: 10,
                color: kSecondaryColor2,
              )
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
      log(selectedIndex.toString());
    });
  }
}
