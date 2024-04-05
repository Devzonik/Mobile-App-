import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grow_x/view/screens/home/home.dart';
import 'package:grow_x/view/screens/menu/menu.dart';
import 'package:grow_x/view/screens/portfolio/portfolio.dart';
import 'package:grow_x/view/screens/team/team.dart';

class BottomNavBarController extends GetxController {
  static final BottomNavBarController instance =
      Get.find<BottomNavBarController>();

  RxBool isHide = false.obs;

  void onHide() {
    isHide.value = !isHide.value;
  }

  static const HOME = '/home';
  static const PORTFOLIO = '/portfolio';
  static const TEAM = '/team';
  static const MENU = '/menu';

  RxInt currentIndex = 0.obs;
  RxString currentRoute = '/home'.obs;

  Map<String, GlobalKey<NavigatorState>> navigatorKeys = {
    HOME: GlobalKey<NavigatorState>(),
    PORTFOLIO: GlobalKey<NavigatorState>(),
    TEAM: GlobalKey<NavigatorState>(),
    MENU: GlobalKey<NavigatorState>(),
  };

  List<String> pageRoutes = [
    HOME,
    PORTFOLIO,
    TEAM,
    MENU,
  ];

  void getCurrentScreen(
    String currentPage,
    int index,
  ) {
    if (currentPage == currentRoute.value) {
      navigatorKeys[currentPage]!.currentState!.popUntil(
            (route) => route.isFirst,
          );
    } else {
      currentIndex.value = index;
      currentRoute.value = pageRoutes[index];
    }
  }

  Widget buildOffStageNavigator(String page) {
    return Obx(
      () => Offstage(
        offstage: currentRoute.value != page,
        child: PageNavigator(
          navigatorKey: navigatorKeys[page]!,
          page: page,
        ),
      ),
    );
  }

  Future<bool> onBackTap(BuildContext context) async {
    final NavigatorState? currentState =
        navigatorKeys[currentRoute.value]?.currentState;

    if (currentState != null && currentState.canPop()) {
      currentState.pop();
      return false;
    } else {
      if (currentIndex.value != 3) {
        getCurrentScreen(HOME, 0);
        return false;
      }
    }

    return true;
  }
}

class PageNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final String page;

  const PageNavigator({
    Key? key,
    required this.navigatorKey,
    required this.page,
  }) : super(key: key);

  // ignore: constant_identifier_names
  static const HOME = '/home';
  static const PORTFOLIO = '/portfolio';
  static const TEAM = '/team';
  static const MENU = '/menu';
  @override
  Widget build(BuildContext context) {
    Widget? child;

    if (page == HOME)
      child = const Home();
    else if (page == PORTFOLIO)
      child = Portfolio();
    else if (page == TEAM)
      child = const Team();
    else if (page == MENU) child = const Menu();

    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(builder: (_) => child!);
      },
    );
  }
}
