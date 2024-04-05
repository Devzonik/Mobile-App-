import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grow_x/constants/app_colors.dart';

class PhoneNumberInput extends StatefulWidget {
  const PhoneNumberInput({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PhoneNumberInputState createState() => _PhoneNumberInputState();
}

class _PhoneNumberInputState extends State<PhoneNumberInput> {
  String _selectedCountryCode = '+123'; // Default country code
  final TextEditingController _phoneNumberController = TextEditingController();

  final List<String> _countryCodes = [
    '+123', '+44', '+91', '+81', '+86', // Add more country codes as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: kGrey4Color)),
      child: Row(
        children: [
          // Country Code Dropdown
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 26,
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                color: kSecondaryColor2, // Set your desired fill color
                borderRadius: BorderRadius.circular(
                    30.0), // Set your desired corner radius
              ),
              child: DropdownButton<String>(
                value: _selectedCountryCode,
                underline: const SizedBox(),

                //style: mystyle12white,
                focusColor: kSecondaryColor2,
                dropdownColor: kSecondaryColor2,
                onChanged: (String? value) {
                  setState(() {
                    _selectedCountryCode = value!;
                  });
                },
                items: _countryCodes.map((String countryCode) {
                  return DropdownMenuItem<String>(
                    value: countryCode,
                    child: Container(
                        width: 35,
                        alignment: Alignment.centerLeft,
                        child: Text(countryCode)),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(width: 16.0),

          // Phone Number TextField
          Expanded(
            child: TextFormField(
                controller: _phoneNumberController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                    hintText: '1234567890',
                    //  hintStyle: mystyle12white,
                    border: InputBorder.none)),
          ),
        ],
      ),
    );
  }
}
