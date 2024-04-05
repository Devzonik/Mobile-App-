import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:grow_x/constants/app_colors.dart';
import 'package:grow_x/view/widgets/my_text_widget.dart';

// ignore: must_be_immutable
class CustomDropDown extends StatelessWidget {
  CustomDropDown(
      {super.key,
      this.heading,
      required this.hint,
      required this.items,
      this.selectedValue,
      required this.onChanged,
      this.bgColor,
      this.customButton,
      this.hascustomicon,
      this.hintxtcolor});

  final List<dynamic>? items;
  String? selectedValue, heading;
  final ValueChanged<dynamic>? onChanged;
  String hint;
  Color? bgColor, hintxtcolor;
  bool? hascustomicon;
  Widget? customButton;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonHideUnderline(
          child: DropdownButton2(
            items: items!
                .map(
                  (item) => DropdownMenuItem<dynamic>(
                    value: item,
                    child: MyText(
                      text: item,
                      color: kBlackColor2,
                      size: 14,
                    ),
                  ),
                )
                .toList(),
            value: selectedValue,
            onChanged: onChanged,
            iconOnClick: hascustomicon == true
                ? customButton
                : const Icon(Icons.keyboard_arrow_up),
            icon: hascustomicon == true
                ? customButton
                : const Icon(Icons.keyboard_arrow_down),
            hint: MyText(
              text: hint,
              size: 14,
              color: hintxtcolor ?? kGrey5Color,
            ),
            isDense: true,
            isExpanded: true,
            buttonHeight: 45,
            buttonPadding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            buttonDecoration: BoxDecoration(
              border: Border.all(
                color: kGrey2Color,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
              color: bgColor ?? kTertiaryColor,
            ),
            buttonElevation: 0,
            itemHeight: 45,
            itemPadding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            dropdownMaxHeight: 200,
            dropdownPadding: null,
            dropdownDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: kQuaternaryColor,
            ),
            dropdownElevation: 4,
            scrollbarRadius: const Radius.circular(40),
            scrollbarThickness: 6,
            scrollbarAlwaysShow: true,
            offset: const Offset(-2, -5),
          ),
        ),
      ],
    );
  }
}
