import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grow_x/constants/app_colors.dart';
import 'package:grow_x/constants/app_sizes.dart';
import 'package:grow_x/generated/assets.dart';
import 'package:grow_x/view/screens/auth/login.dart';
import 'package:grow_x/view/widgets/my_text_widget.dart';

AppBar simpleAppBar({
  Color? bgColor,
  bool? hasIcon,
  Color? backiconColor,
  Widget? choiceicon,
  required BuildContext context,
}) {
  return AppBar(
    backgroundColor: bgColor ?? Colors.transparent,
    leadingWidth: MediaQuery.of(context).size.width,
    iconTheme: const IconThemeData(color: Colors.transparent),
    //automaticallyImplyLeading: false,
    elevation: 0.0, // Remove the shadow
    titleSpacing: 0.0,
    toolbarHeight: 60,
    leading: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: AppSizes.DEFAULT_HORIZONTAL,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      color: kSecondaryColor,
                    ),
                  ),
                  // SizedBox(
                  //   width: 10,
                  // ),
                  // ImageIcon(
                  //   AssetImage(Assets.imagesBlack),
                  //   color: kSecondaryColor,
                  //   size: 50,
                  // ),
                ],
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
        const SizedBox(
          height: 23,
        )
      ],
    ),
  );
}

AppBar homeappbar({
  Color? bgColor,
  bool? hasIcon,
  Color? backiconColor,
  VoidCallback? onMenutap,
  Widget? choiceicon,
  required BuildContext context,
  required String title,
}) {
  return AppBar(
    backgroundColor: bgColor ?? kSecondaryColor,
    leadingWidth: MediaQuery.of(context).size.width,
    iconTheme: const IconThemeData(color: Colors.transparent),
    //automaticallyImplyLeading: false,
    elevation: 0.0, // Remove the shadow
    titleSpacing: 0.0,
    toolbarHeight: 100,

    leading: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                SizedBox(
                  // width: 150, // Adjust the width to make the image bigger
                  height: 25,
                  // Adjust the height to make the image bigger
                  child: GestureDetector(
                      onTap: onMenutap ?? () {},
                      child: Icon(
                        Icons.menu,
                        size: 20,
                        color: backiconColor ?? kQuaternaryColor,
                      )),
                ),
              ],
            ),

            MyText(
              text: title,
              weight: FontWeight.w600,
              color: kQuaternaryColor,
              size: 18,
            ),
            hasIcon == true
                ? const Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: kQuaternaryColor,
                      ),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  )
                : Row(
                    children: [
                      Container(
                        width: 25,
                        child: choiceicon ?? const Icon(null),
                      ),
                      const SizedBox(
                        width: 20,
                      )
                    ],
                  ),

            // backgroundColor: bgColor ?? kTertiaryColor,
            //Image(image: icon?? Assets.Me!)
          ],
        ),
        const SizedBox(
          height: 24,
        )
      ],
    ),
  );
}
