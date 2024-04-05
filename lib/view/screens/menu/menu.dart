import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grow_x/config/routes/custom_route_widget.dart';
import 'package:grow_x/constants/app_colors.dart';
import 'package:grow_x/constants/app_fonts.dart';
import 'package:grow_x/constants/app_sizes.dart';
import 'package:grow_x/constants/app_styling.dart';
import 'package:grow_x/generated/assets.dart';
import 'package:grow_x/view/screens/auth/login.dart';
import 'package:grow_x/view/screens/home/contactus.dart';
import 'package:grow_x/view/screens/home/deposit_detials.dart';
import 'package:grow_x/view/screens/home/home.dart';
import 'package:grow_x/view/screens/home/withdraw.dart';
import 'package:grow_x/view/screens/menu/recharge_history.dart';
import 'package:grow_x/view/screens/menu/referral_link_copy.dart';
import 'package:grow_x/view/screens/menu/view_plan.dart';
import 'package:grow_x/view/screens/menu/withdrawal_history.dart';
import 'package:grow_x/view/screens/portfolio/portfolio.dart';
import 'package:grow_x/view/screens/team/team.dart';
import 'package:grow_x/view/widgets/common_image_view_widget.dart';
import 'package:grow_x/view/widgets/my_text_widget.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            CommonImageView(
              imagePath: Assets.imagesWaves,
              width: Get.width,
              height: Get.height,
              fit: BoxFit.cover,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: AppSizes.DEFAULT_PADDING,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const ImageIcon(
                        AssetImage(Assets.imagesBlack),
                        color: kSecondaryColor,
                        size: 50,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(CustomPageRoute(
                                page: const Home(),
                              ));
                            },
                            child: const ImageIcon(
                              AssetImage(Assets.imagesHome),
                              color: kSecondaryColor,
                              size: 20,
                            ),
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
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      MenuTile(Assets.imagesHome, 'Home', () {
                        Navigator.of(context)
                            .push(CustomPageRoute(page: const Home()));
                      }),
                      // MenuTile(Assets.imagesPackage, 'All Packages', () {

                      // }),
                      MenuTile(Assets.imagesPortfolio, 'Portfolio', () {
                        Navigator.of(context)
                            .push(CustomPageRoute(page: Portfolio()));
                      }),

                      MenuTile(Assets.imagesDeposit, 'Add Balance', () {
                        Navigator.of(context).push(
                            CustomPageRoute(page: const DepositDetails()));
                      }),

                      MenuTile(Assets.imagesTeam, 'Teams', () {
                        Navigator.of(context)
                            .push(CustomPageRoute(page: const Team()));
                      }),
                      MenuTile(Assets.imagesLink, 'Refferal Link', () {
                        Navigator.of(context)
                            .push(CustomPageRoute(page: const ReferralCopy()));
                      }),
                      MenuTile(Assets.imagesContact, 'Contact Us', () {
                        Navigator.of(context)
                            .push(CustomPageRoute(page: ContactUs()));
                      }),
                      MenuTile(Assets.imagesPlan2, 'View our Plan', () {
                        Navigator.of(context)
                            .push(CustomPageRoute(page: PDFViewerPage()));
                      }),
                      MenuTile(Assets.imagesDeposit, 'Manage Recharges', () {
                        Navigator.of(context)
                            .push(CustomPageRoute(page: RechargeHistory()));
                      }),
                      MenuTile(Assets.imagesWithdraw, 'Withdrawals Management',
                          () {
                        Navigator.of(context)
                            .push(CustomPageRoute(page: ManageWithdrawals()));
                      }),
                      // MyText(
                      //   text: 'Our Plan',
                      //   size: 22,
                      //   fontFamily: AppFonts.PLAY,
                      //   paddingTop: 20,
                      //   paddingBottom: 10,
                      // ),
                      // CommonImageView(
                      //   imagePath: Assets.imagesPlan,
                      // )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget MenuTile(String leading, title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Container(
        decoration: rounded(kPrimaryColor),
        child: ListTile(
          onTap: onTap,
          leading: ImageIcon(
            AssetImage(leading),
            size: 20,
            color: kTertiaryColor,
          ),
          title: MyText(
            text: title,
            size: 14,
            weight: FontWeight.bold,
          ),
          trailing: const Icon(
            Icons.keyboard_arrow_right,
            color: kTertiaryColor,
          ),
        ),
      ),
    );
  }
}
