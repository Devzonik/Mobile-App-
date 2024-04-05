import 'package:flutter/material.dart';
import 'package:grow_x/constants/app_colors.dart';
import 'package:grow_x/constants/app_styling.dart';
import 'package:grow_x/view/widgets/common_image_view_widget.dart';
import 'package:grow_x/view/widgets/my_text_widget.dart';

// ignore: must_be_immutable
class CustomExpansionTile extends StatefulWidget {
  CustomExpansionTile(
      {super.key, required this.title, this.isleft, required this.body});
  String title;
  List<Widget> body;
  bool? isleft;

  @override
  State<CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: rounded2(kSecondaryColor),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
            trailing: Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              size: 20,
              color: kPrimaryColor,
            ),
            onExpansionChanged: (expanded) {
              setState(() {
                isExpanded = expanded;
              });
            },
            collapsedTextColor: kTertiaryColor,
            textColor: kTertiaryColor,
            title: MyText(
              text: widget.title,
              color: kQuaternaryColor,
              size: 16,
              paddingRight: 20,
            ),
            children: widget.body),
      ),
    );
  }
}
