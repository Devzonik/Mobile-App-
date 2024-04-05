import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grow_x/constants/app_colors.dart';

class RangeSelector extends StatefulWidget {
  final String selectedRange;
  final ValueChanged<String> onRangeSelected;

  RangeSelector({
    required this.selectedRange,
    required this.onRangeSelected,
  });

  @override
  _RangeSelectorState createState() => _RangeSelectorState();
}

class _RangeSelectorState extends State<RangeSelector> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8),
        CategoryBox(
          category: '1000-5000',
          isSelected: widget.selectedRange == '1000-5000',
          onSelected: () {
            widget.onRangeSelected('1000-5000');
          },
        ),
        SizedBox(
          height: 10,
        ),
        CategoryBox(
          category: '5100-20000',
          isSelected: widget.selectedRange == '5100-20000',
          onSelected: () {
            widget.onRangeSelected('5100-20000');
          },
        ),
        SizedBox(
          height: 10,
        ),
        CategoryBox(
          category: '21000-50000',
          isSelected: widget.selectedRange == '21000-50000',
          onSelected: () {
            widget.onRangeSelected('21000-50000');
          },
        ),
      ],
    );
  }
}

class CategoryBox extends StatelessWidget {
  final String category;
  final bool isSelected;
  final VoidCallback onSelected;

  CategoryBox({
    required this.category,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelected,
      child: Container(
        margin: EdgeInsets.all(8),
        width: Get.width,
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? kSecondaryColor : kSecondaryColor,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? kSecondaryColor : Colors.transparent,
        ),
        child: Center(
          child: Text(
            category,
            style: TextStyle(
              color: isSelected ? kPrimaryColor : kSecondaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

final List<String> categoryOptions = [
  '1000-5000',
  '5100-20000',
  '21000-50000',
];
