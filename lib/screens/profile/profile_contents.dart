import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:intl/intl.dart';
import 'package:trivia/src/rust/api/error.dart';
import 'package:trivia/src/rust/api/request/get_user_data.dart';
import 'package:trivia/src/rust/api/request/update_user_data.dart';
import '../../consts.dart';
import '../../src/rust/api/session.dart';
import '../../utils/dialogs/error_dialog.dart';
import '../../utils/common_widgets/input_field.dart';
import '../../utils/common_functionalities/reset_providers.dart';
import '../../utils/common_functionalities/user_data_validation.dart';

class ProfilePageContent extends StatefulWidget {
  final UserData userData;
  final bool isSkeletonLoading;
  final Session session;

  const ProfilePageContent({
    super.key,
    required this.userData,
    this.isSkeletonLoading = false,
    required this.session,
  });

  @override
  State<ProfilePageContent> createState() => _ProfilePageContentState();
}

class _ProfilePageContentState extends State<ProfilePageContent> {
  late UserData lastUserData;
  bool first = true;
  late Color avatarColor;
  TextEditingController passwordController = TextEditingController();
  String? passwordErrorText;
  bool _showPassword = false;
  TextEditingController emailController = TextEditingController();
  String? emailErrorText;
  FocusNode emailFocusNode = FocusNode();
  TextEditingController addressController = TextEditingController();
  String? addressErrorText;
  FocusNode addressFocusNode = FocusNode();
  TextEditingController phoneNumberController = TextEditingController();
  String? phoneNumberErrorText;
  FocusNode phoneNumberFocusNode = FocusNode();
  TextEditingController birthdateController = TextEditingController();
  bool _isLoading = false;
  String? _errorText;

  @override
  void initState() {
    lastUserData = widget.userData;
    avatarColor = avatarColorsMap[widget.userData.avatarColor]!;
    emailController.text = widget.userData.email;
    addressController.text = widget.userData.address;
    phoneNumberController.text = widget.userData.phoneNumber;
    birthdateController.text = widget.userData.birthday;
    super.initState();
  }

  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
    addressController.dispose();
    phoneNumberController.dispose();
    birthdateController.dispose();
    emailFocusNode.dispose();
    addressFocusNode.dispose();
    phoneNumberFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                _showColorPicker();
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const SizedBox(
                      width: 128,
                    ),
                    CircleAvatar(
                      radius: 64,
                      backgroundColor: avatarColor,
                      child: Text(
                        getInitials(widget.userData.username),
                        style:
                            Theme.of(context).textTheme.displaySmall!.copyWith(
                                  color: Colors.white,
                                ),
                      ),
                    ),
                    if (!widget.isSkeletonLoading)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHigh,
                          ),
                          child: IconButton(
                            onPressed: _showColorPicker,
                            icon: const Icon(
                              Icons.edit,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              widget.userData.username,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              "Member since: ${DateFormat("dd/MM/yyyy").format(widget.userData.memberSince.toLocal())}",
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: InputField(
                enabled: !_isLoading,
                label: "Password",
                inputType: TextInputType.visiblePassword,
                controller: passwordController,
                errorText: passwordErrorText,
                showPassword: _showPassword,
                isPassword: true,
                onFieldSubmitted: (value) {
                  // move focus to next field (email)
                  FocusScope.of(context).requestFocus(emailFocusNode);
                },
                validate: (String value) {
                  setState(() {
                    _errorText = null;
                    passwordErrorText = getPasswordErrorText(value);
                  });
                },
                suffixIcon: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Icon(
                        _showPassword
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: InputField(
                focusNode: emailFocusNode,
                suffixIcon: const Icon(Icons.email_outlined),
                enabled: !_isLoading,
                label: "Email",
                inputType: TextInputType.emailAddress,
                onFieldSubmitted: (value) {
                  // move focus to next field (address)
                  FocusScope.of(context).requestFocus(addressFocusNode);
                },
                controller: emailController,
                errorText: emailErrorText,
                validate: (String value) {
                  setState(() {
                    _errorText = null;
                    emailErrorText = getEmailErrorText(value);
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: InputField(
                focusNode: addressFocusNode,
                suffixIcon: const Icon(Icons.home_work_outlined),
                enabled: !_isLoading,
                controller: addressController,
                inputType: TextInputType.streetAddress,
                onFieldSubmitted: (value) {
                  // move focus to next field (phone number)
                  FocusScope.of(context).requestFocus(phoneNumberFocusNode);
                },
                label: "Address",
                errorText: addressErrorText,
                validate: (String value) {
                  setState(() {
                    _errorText = null;
                    addressErrorText = getAddressErrorText(value);
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: InputField(
                focusNode: phoneNumberFocusNode,
                suffixIcon: const Icon(Icons.phone_outlined),
                enabled: !_isLoading,
                inputType: TextInputType.phone,
                controller: phoneNumberController,
                label: "Phone number",
                errorText: phoneNumberErrorText,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (value) {
                  if (isAllFieldsValid() && isSomethingChanged()) _save();
                },
                validate: (String value) {
                  setState(() {
                    _errorText = null;
                    phoneNumberErrorText = getPhoneNumberErrorText(value);
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: InputField(
                suffixIcon: const Icon(Icons.calendar_today_outlined),
                enabled: false,
                controller: birthdateController,
                label: "Birthday",
                errorText: null,
                validate: null,
              ),
            ),
            if (_errorText != null)
              Text(
                _errorText!,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
              ),
            const SizedBox(height: 16),
            FilledButton(
              style: FilledButton.styleFrom(
                minimumSize: signInAndUpButtonSize,
              ),
              onPressed:
                  isAllFieldsValid() && isSomethingChanged() && !_isLoading
                      ? _save
                      : null,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text(
                      "Save",
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _save() async {
    setState(() {
      _errorText = null;
      _isLoading = true;
    });
    try {
      await widget.session.updateUserData(
          updateUserDataRequest: UpdateUserDataRequest(
              password: passwordController.text.isEmpty
                  ? null
                  : passwordController.text,
              email: emailController.text,
              address: addressController.text,
              phoneNumber: phoneNumberController.text,
              avatarColor: avatarColorsMapReversed[avatarColor]!));
    } on Error_ServerConnectionError catch (e) {
      if (!mounted) return;
      resetProviders(context);
      Navigator.of(context).pushReplacementNamed('/login');
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return ErrorDialog(
              title: "Server Connection Error",
              message: "${e.format()}, Returning to login page...");
        },
      );
    } on Error_UpdateUserDataError catch (e) {
      setState(() {
        _errorText = "• ${e.format()}";
      });
      return;
    } on Error catch (e) {
      if (!mounted) return;
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return ErrorDialog(
            title: "Error",
            message: e.format(),
          );
        },
      );
      return;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
    setState(() {
      lastUserData = UserData(
          username: widget.userData.username,
          email: emailController.text,
          address: addressController.text,
          phoneNumber: phoneNumberController.text,
          birthday: widget.userData.birthday,
          avatarColor: avatarColorsMapReversed[avatarColor]!,
          memberSince: widget.userData.memberSince);
    });
    passwordController.text = '';
  }

  bool isAllFieldsValid() {
    bool isAllFieldsEntered = emailController.text.isNotEmpty &&
        addressController.text.isNotEmpty &&
        phoneNumberController.text.isNotEmpty;
    bool isAllFieldsWithoutError = emailErrorText == null &&
        passwordErrorText == null &&
        addressErrorText == null &&
        phoneNumberErrorText == null;
    return isAllFieldsEntered && isAllFieldsWithoutError;
  }

  bool isSomethingChanged() {
    return emailController.text != lastUserData.email ||
        addressController.text != lastUserData.address ||
        phoneNumberController.text != lastUserData.phoneNumber ||
        avatarColorsMap[lastUserData.avatarColor] != avatarColor ||
        passwordController.text.isNotEmpty;
  }

  // Method to show color picker dialog
  void _showColorPicker() async {
    Color? tempAvatarColor = avatarColor;
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(18.0),
          title: const Text("Select Avatar Color"),
          content: MaterialColorPicker(
            colors: avatarColors,
            selectedColor: tempAvatarColor,
            allowShades: false,
            onMainColorChange: (color) =>
                setState(() => tempAvatarColor = color),
          ),
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (tempAvatarColor != null) {
                  setState(() => avatarColor = tempAvatarColor!);
                }
              },
              child: const Text('Select'),
            ),
          ],
        );
      },
    );
  }
}
