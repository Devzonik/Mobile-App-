import 'package:grow_x/core/extensions/validation.dart';

class ValidationService {
  //private constructor
  ValidationService._privateConstructor();

  //singleton instance variable
  static ValidationService? _instance;

  //This code ensures that the singleton instance is created only when it's accessed for the first time.
  //Subsequent calls to ValidationService.instance will return the same instance that was created before.

  //getter to access the singleton instance
  static ValidationService get instance {
    _instance ??= ValidationService._privateConstructor();
    return _instance!;
  }

  //empty validator
  String? emptyValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Field is required";
    }
    return null;
  }

  String? fourDigitsValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Field is required";
    }
    if (value.length != 4) {
      return "Please enter last 4 digits of your account";
    }
    if (!RegExp(r'^[0-9]*$').hasMatch(value)) {
      return "Please enter digits only";
    }
    return null;
  }

  //email validator
  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email address';
    } else if (value.isValidEmail() == false) {
      return 'Invalid email address';
    } else {
      return null;
    }
  }

  String? amountValidator(String? value) {
    double depositAmount =
        0; // Initialize with a default value or fetch it from where you have access
    // Perform validation based on the value and depositAmount
    if (value == null || value.isEmpty) {
      return "Field is required";
    }
    double? enteredAmount = double.tryParse(value);
    if (enteredAmount == null) {
      return "Invalid amount";
    }
    if (enteredAmount > depositAmount) {
      return "Amount cannot be greater than deposit";
    }
    return null;
  }

  //username validator
  String? userNameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your username';
    } else if (value.isValidUsername() == false) {
      return 'Invalid username';
    } else {
      return null;
    }
  }

  //password validator
  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }

    if (password.length < 8) {
      return 'Password must be at least 8 characters long';
    }

    if (password.isUpperCase() == false) {
      return 'Password must contain at least one uppercase letter';
    }

    if (password.isLowerCase() == false) {
      return 'Password must contain at least one lowercase letter';
    }

    if (password.isContainDigit() == false) {
      return 'Password must contain at least one digit';
    }

    if (password.isContainSpecialCharacter() == false) {
      return 'Password must contain at least one special character';
    }

    return null; // Return null if the password is valid
  }

  //password match function
  String? validateMatchPassword(String value, String password) {
    if (value.isEmpty) {
      return 'Please enter your password again';
    } else if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }
}
