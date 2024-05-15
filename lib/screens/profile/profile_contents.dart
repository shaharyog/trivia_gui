import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trivia/providers/session_provider.dart';
import 'package:trivia/src/rust/api/error.dart';
import 'package:trivia/src/rust/api/request/get_user_data.dart';
import 'package:trivia/src/rust/api/request/update_user_data.dart';
import '../../consts.dart';
import '../../utils/error_dialog.dart';
import '../../utils/input_field.dart';
import '../../utils/user_data.dart';
import 'color_picker.dart';

class ProfilePageContent extends StatefulWidget {
  final UserData userData;

  const ProfilePageContent({super.key, required this.userData});

  @override
  State<ProfilePageContent> createState() => _ProfilePageContentState();
}

class _ProfilePageContentState extends State<ProfilePageContent> {
  bool first = true;
  late Color avatarColor;
  TextEditingController passwordController = TextEditingController();
  String? passwordErrorText;
  bool _showPassword = false;
  TextEditingController emailController = TextEditingController();
  String? emailErrorText;
  TextEditingController addressController = TextEditingController();
  String? addressErrorText;
  TextEditingController phoneNumberController = TextEditingController();
  String? phoneNumberErrorText;
  TextEditingController birthdateController = TextEditingController();
  bool _isLoading = false;
  String? _errorText;

  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
    addressController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (first) {
      first = false;
      avatarColor = avatarColorsMap[widget.userData.avatarColor]!;
      emailController.text = widget.userData.email;
      addressController.text = widget.userData.address;
      phoneNumberController.text = widget.userData.phoneNumber;
      birthdateController.text = widget.userData.birthday;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
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
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(
                                color: Colors.white,
                              ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).colorScheme.inversePrimary,
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
                  suffixIcon: const Icon(Icons.email_outlined),
                  enabled: !_isLoading,
                  label: "Email",
                  inputType: TextInputType.emailAddress,
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
                  suffixIcon: const Icon(Icons.home_work_outlined),
                  enabled: !_isLoading,
                  controller: addressController,
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
                  suffixIcon: const Icon(Icons.phone_outlined),
                  enabled: !_isLoading,
                  inputType: TextInputType.phone,
                  controller: phoneNumberController,
                  label: "Phone number",
                  errorText: phoneNumberErrorText,
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
                onPressed: isAllFieldsValid() && isSomethingChanged() && !_isLoading ? _save : null,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text(
                        "Save",
                      ),
              ),
            ],
          ),
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
      await Provider.of<SessionProvider>(context, listen: false)
          .session!
          .updateUserData(
              updateUserDataRequest: UpdateUserDataRequest(
                  password: passwordController.text.isEmpty
                      ? null
                      : passwordController.text,
                  email: emailController.text,
                  address: addressController.text,
                  phoneNumber: phoneNumberController.text,
                  avatarColor: avatarColorsMapReversed[avatarColor]!));
    } on Error_ServerConnectionError catch (_) {
      if (!mounted) return;
      Provider.of<SessionProvider>(context, listen: false).session = null;
      Navigator.of(context).pushReplacementNamed('/login');
    } on Error_UpdateUserDataError catch (e) {
      setState(() {
        _errorText = "• ${e.format()}";
      });
      return;
    } on Error catch (e) {
      if (!mounted) return;
      showDialog(
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
    return emailController.text != widget.userData.email ||
        addressController.text != widget.userData.address ||
        phoneNumberController.text != widget.userData.phoneNumber ||
        avatarColorsMap[widget.userData.avatarColor] != avatarColor ||
        passwordController.text.isNotEmpty;
  }

  // Method to show color picker dialog
  void _showColorPicker() async {

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ColorPickerDialog(
          initialColor: avatarColor,
          onColorSave: (Color newColor) {
            setState(() {
              avatarColor = newColor;
            });
          },
        );
      },
    );
  }
}