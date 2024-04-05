import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:grow_x/constants/app_colors.dart';
import 'package:grow_x/constants/app_fonts.dart';
import 'package:grow_x/constants/app_styling.dart';
import 'package:grow_x/generated/assets.dart';
import 'package:grow_x/view/widgets/common_image_view_widget.dart';
import 'package:grow_x/view/widgets/my_text_widget.dart';
import 'package:grow_x/view/widgets/simple_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatelessWidget {
  ContactUs({super.key, this.isshow});
  bool? isshow;
  @override
  Widget build(BuildContext context) {
    // log(isshow);
    return Stack(children: [
      CommonImageView(
        imagePath: Assets.imagesWaves,
        width: Get.width,
        height: Get.height,
        fit: BoxFit.cover,
      ),
      Scaffold(
          appBar: isshow == true
              ? AppBar(
                  backgroundColor: Colors.transparent,
                  leading: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: kSecondaryColor,
                      )),
                )
              : simpleAppBar(context: context),
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
                    AssetImage(Assets.imagesContact),
                    size: 100,
                    color: kSecondaryColor,
                  ),
                  MyText(
                    text: 'Contact Us',
                    size: 24,
                    fontFamily: AppFonts.PLAY,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    height: 100,
                    decoration: rounded(kPrimaryColor),
                    child: Center(
                      child: ListTile(
                        title: MyText(
                          text: 'Support@growthxinvest.com',
                          paddingLeft: 10,
                          paddingTop: 10,
                          color: kBlueColor,
                          paddingBottom: 10,
                          weight: FontWeight.bold,
                          size: 15,
                        ),
                        subtitle: MyText(
                          text: 'Send us your queries',
                          paddingLeft: 10,
                        ),
                        trailing: InkWell(
                          onTap: () {
                            _copyToClipboard('Support@growthxinvest.com');
                            Get.snackbar('Copied', 'Inbox us');
                          },
                          child: Icon(
                            Icons.copy,
                            size: 18,
                            color: kBlack2Color,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      _launchWhatsApp();
                    },
                    child: Container(
                      height: 100,
                      decoration: rounded(kPrimaryColor),
                      child: Center(
                        child: ListTile(
                          title: MyText(
                            text: 'Chat with us',
                            paddingLeft: 10,
                            paddingTop: 10,
                            color: kBlueColor,
                            paddingBottom: 10,
                            weight: FontWeight.bold,
                            size: 15,
                          ),
                          subtitle: MyText(
                            text: 'Feel free to inbox us',
                            paddingLeft: 10,
                          ),
                          trailing: InkWell(
                              onTap: () {
                                _launchWhatsApp();
                                //Get.snackbar('Copied', 'Inbox us');
                              },
                              child: CommonImageView(
                                imagePath: Assets.imagesWhatsapp,
                                height: 18,
                              )),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      joingroup();
                    },
                    child: Container(
                      height: 100,
                      decoration: rounded(kPrimaryColor),
                      child: Center(
                        child: ListTile(
                          title: MyText(
                            text: 'Join Whatsapp Group ',
                            paddingLeft: 10,
                            paddingTop: 10,
                            color: kBlueColor,
                            paddingBottom: 10,
                            weight: FontWeight.bold,
                            size: 15,
                          ),
                          subtitle: MyText(
                            text: 'Be a part of our GrowthX community',
                            paddingLeft: 10,
                          ),
                          trailing: InkWell(
                              onTap: () {
                                joingroup();
                                //Get.snackbar('Copied', 'Inbox us');
                              },
                              child: CommonImageView(
                                imagePath: Assets.imagesWhatsapp,
                                height: 18,
                              )),
                        ),
                      ),
                    ),
                  )
                ]))
          ]))
    ]);
  }

  _launchWhatsApp() async {
    var whatsappUrl = 'https://wa.link/u8b5h3';

    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      // WhatsApp is not installed, open in Chrome browser
      await launch(
        whatsappUrl,
        forceWebView: false,
        forceSafariVC: false,
      );
    }
  }

  joingroup() async {
    // Specify the WhatsApp chat link with the phone number and message
    var whatsappUrl = 'https://chat.whatsapp.com/H7LvKwjQq7k4zsXF301Y7q';

    // Check if the WhatsApp app is installed
    if (await canLaunch(whatsappUrl)) {
      // Open the WhatsApp chat link
      await launch(whatsappUrl);
    } else {
      // Show an error message if WhatsApp is not installed
      await launch(
        whatsappUrl,
        forceWebView: false,
        forceSafariVC: false,
      );
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }
}
