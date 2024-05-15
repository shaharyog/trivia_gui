import 'package:intl/intl.dart';

String getInitials(String name) {
  if (name.isEmpty) return '';
  List<String> words = name.split(' ');
  String initials = '';
  for (var word in words) {
    if (initials.length < 2) {
      initials += word[0].toUpperCase();
    }
  }
  return initials;
}

String? getPasswordErrorText(String value) {
  if (value.isEmpty) {
    return null;
  } else if (!isValidPassword(value)) {
    bool isPasswordTooShort = value.length < 8;
    bool doesPasswordContainUppercase = value.contains(RegExp(r'[A-Z]'));
    bool doesPasswordContainLowercase = value.contains(RegExp(r'[a-z]'));
    bool doesPasswordContainNumber = value.contains(RegExp(r'[0-9]'));
    bool doesPasswordContainSpecialCharacter =
    value.contains(RegExp(r'[*&^%$#@!]'));

    String tempErrorText = "";
    if (isPasswordTooShort) {
      tempErrorText += "• Password must be at least 8 characters long\n";
    }
    if (!doesPasswordContainUppercase) {
      tempErrorText +=
      "• Password must contain at least one uppercase letter\n";
    }
    if (!doesPasswordContainLowercase) {
      tempErrorText +=
      "• Password must contain at least one lowercase letter\n";
    }
    if (!doesPasswordContainNumber) {
      tempErrorText += "• Password must contain at least one number\n";
    }
    if (!doesPasswordContainSpecialCharacter) {
      tempErrorText +=
      "• Password must contain at least one special character\n";
    }
    if (tempErrorText.isNotEmpty) {
      tempErrorText = tempErrorText.substring(0, tempErrorText.length - 1);
    }
    return tempErrorText;
  } else {
    return null;
  }
}

String? getEmailErrorText(String value) {
  if (value.isEmpty) {
    return null;
  } else if (!isValidEmail(value)) {
    return "• Invalid email address";
  } else {
    return null;
  }
}

String? getAddressErrorText(String value) {
  if (value.isEmpty) {
    return null;
  } else if (!isValidAddress(value)) {
    return "• Invalid address, format should be: 'Street, Number, City'\n• Street and City must contain only letters";
  } else {
    return null;
  }
}

String? getPhoneNumberErrorText(String value) {
  if (value.isEmpty) {
    return null;
  } else if (!isValidPhoneNumber(value)) {
    return "• Phone number must be a valid Israeli phone number";
  } else {
    return null;
  }
}

bool isValidPassword(String pass) {
  bool isPasswordTooShort = pass.length < 8;
  bool doesPasswordContainUppercase = pass.contains(RegExp(r'[A-Z]'));
  bool doesPasswordContainLowercase = pass.contains(RegExp(r'[a-z]'));
  bool doesPasswordContainNumber = pass.contains(RegExp(r'[0-9]'));
  bool doesPasswordContainSpecialCharacter =
  pass.contains(RegExp(r'[*&^%$#@!]'));
  // R"((?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[*&^%$#@!])[A-Za-z0-9*&^%$#@!]{8,})";
  return !isPasswordTooShort &&
      doesPasswordContainUppercase &&
      doesPasswordContainLowercase &&
      doesPasswordContainNumber &&
      doesPasswordContainSpecialCharacter;
}

bool isValidEmail(String email) {
  const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
      r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
      r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
      r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
      r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
      r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
      r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';

  return RegExp(pattern).hasMatch(email.toLowerCase());
}

bool isValidAddress(String address) {
  return RegExp(r'^[a-zA-Z\s]+, \d+, [a-zA-Z\s]+$').hasMatch(address);
}

bool isValidPhoneNumber(String phoneNumber) {
  return RegExp(
      r'^(?:(?:(\+?972|\(\+?972\)|\+?\(972\))(?:\s|\.|-)?([1-9]\d?))|(0[23489]{1})|(0[57]{1}[0-9]))(?:\s|\.|-)?([^0\D]{1}\d{2}(?:\s|\.|-)?\d{4})$')
      .hasMatch(phoneNumber);
}

DateTime? parseDate(String date) {
  try {
    return DateFormat("dd-MM-yyyy").tryParseStrict(date) != null
        ? DateFormat("dd-MM-yyyy").parseStrict(date)
        : DateFormat("dd/MM/yyyy").tryParseStrict(date) != null
        ? DateFormat("dd/MM/yyyy").parseStrict(date)
        : DateFormat("dd.mm.yyyy").parse(date);
  } catch (e) {
    return null;
  }
}

String? getBirthdateErrorText(String value) {
  if (value.isEmpty) {
    return null;
  } else {
    DateTime? date = parseDate(value);
    if (date == null) {
      return "• Invalid birthdate format";
    }

    if (date.isBefore(DateTime(1900, 1, 1)) || date.isAfter(DateTime.now())) {
      return "• Invalid birthdate";
    } else {
      return null;
    }
  }
}


String? getUsernameErrorText(String value) {

  if (value.length < 4 && value.isNotEmpty) {
    return "• Username must be at least 4 characters long";
  }

  return null;

}
