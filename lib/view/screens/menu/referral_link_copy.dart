import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:grow_x/constants/app_colors.dart';
import 'package:grow_x/constants/app_fonts.dart';
import 'package:grow_x/constants/app_sizes.dart';
import 'package:grow_x/constants/app_styling.dart';
import 'package:grow_x/controllers/home/home_controller.dart';
import 'package:grow_x/generated/assets.dart';
import 'package:grow_x/view/widgets/common_image_view_widget.dart';
import 'package:grow_x/view/widgets/my_text_widget.dart';
import 'package:grow_x/view/widgets/simple_app_bar.dart';

class ReferralCopy extends StatefulWidget {
  const ReferralCopy({super.key});

  @override
  State<ReferralCopy> createState() => _ReferralCopyState();
}

class _ReferralCopyState extends State<ReferralCopy> {
  final HomeController controller = Get.find<HomeController>();

  @override
  void initState() {
    // TODO: implement initState
    controller.loadUsername();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Stack(children: [
      CommonImageView(
        imagePath: Assets.imagesWaves,
        width: Get.width,
        height: Get.height,
        fit: BoxFit.cover,
      ),
      Scaffold(
          appBar: simpleAppBar(context: context),
          backgroundColor: Colors.transparent,
          body:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Expanded(
                child: ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    physics: const BouncingScrollPhysics(),
                    children: [
                  ImageIcon(
                    AssetImage(Assets.imagesWithdraw),
                    size: 100,
                    color: kSecondaryColor,
                  ),
                  MyText(
                    text: 'Referral Link',
                    size: 24,
                    fontFamily: AppFonts.PLAY,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: AppSizes.DEFAULT_HORIZONTAL,
                    child: Container(
                      height: 50,
                      decoration: rounded(kYellowColor),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MyText(
                          text:
                              'Copy this given code and invite other to register so that you can grow',
                          size: 12,
                          color: kTextColor3,
                          paddingLeft: 8,
                          weight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Container(
                    height: 100,
                    decoration: rounded(kPrimaryColor),
                    child: Center(
                      child: ListTile(
                        title: Obx(
                          () => MyText(
                            text: '${controller.referralLink}',
                            paddingLeft: 10,
                            paddingTop: 10,
                            color: kBlueColor,
                            weight: FontWeight.bold,
                            size: 12,
                          ),
                        ),
                        trailing: InkWell(
                          onTap: () {
                            _copyToClipboard(controller.referralLink.value);
                            Get.snackbar('Copied', 'Share with your network');
                          },
                          child: Icon(
                            Icons.copy,
                            size: 18,
                            color: kBlack2Color,
                          ),
                        ),
                      ),
                    ),
                  )
                ]))
          ]))
    ]);
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }
}
