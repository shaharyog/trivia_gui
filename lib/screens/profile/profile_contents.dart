import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:trivia/src/rust/api/error.dart';
import 'package:trivia/src/rust/api/request/get_user_data.dart';
import 'package:trivia/src/rust/api/request/update_user_data.dart';
import 'package:trivia/utils/common_functionalities/seconds_to_readable.dart';
import '../../consts.dart';
import '../../src/rust/api/session.dart';
import '../../utils/dialogs/error_dialog.dart';
import '../../utils/common_widgets/input_field.dart';
import '../../utils/common_functionalities/user_data_validation.dart';
import '../auth/login.dart';

class ProfilePageContent extends StatefulWidget {
  final UserDataAndStatistics userDataAndStats;
  final Session session;

  const ProfilePageContent({
    super.key,
    required this.userDataAndStats,
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
    super.initState();
    lastUserData = widget.userDataAndStats.userData;
    avatarColor =
        avatarColorsMap[widget.userDataAndStats.userData.avatarColor] ??
            Colors.blue;
    emailController.text = widget.userDataAndStats.userData.email;
    addressController.text = widget.userDataAndStats.userData.address;
    phoneNumberController.text = widget.userDataAndStats.userData.phoneNumber;
    birthdateController.text = widget.userDataAndStats.userData.birthday;
  }

  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
    addressController.dispose();
    phoneNumberController.dispose();
    birthdateController.dispose();
    addressFocusNode.dispose();
    phoneNumberFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 16),
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
                        Skeleton.shade(
                          child: CircleAvatar(
                            radius: 64,
                            backgroundColor: avatarColor,
                            child: Text(
                              getInitials(
                                  widget.userDataAndStats.userData.username),
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge!
                                  .copyWith(
                                    color: Colors.white,
                                  ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Skeleton.ignore(
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                              ),
                              child: IconButton(
                                onPressed: _showColorPicker,
                                icon: const Icon(
                                  Icons.edit,
                                ),
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
                  widget.userDataAndStats.userData.username,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    "Member since: ${DateFormat("dd/MM/yyyy").format(widget.userDataAndStats.userData.memberSince.toLocal())}",
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: _buildStatistics(
                      context, widget.userDataAndStats.userStatistics),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
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
                      FocusScope.of(context).requestFocus(addressFocusNode);
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
                    suffixIcon: const Icon(Icons.email_sharp),
                    enabled: false,
                    controller: emailController,
                    label: "Email",
                    errorText: null,
                    validate: null,
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
                const SizedBox(height: 16),
              ],
            ),
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
      await widget.session.updateUserData(
        updateUserDataRequest: UpdateUserDataRequest(
          password:
              passwordController.text.isEmpty ? null : passwordController.text,
          address: addressController.text,
          phoneNumber: phoneNumberController.text,
          avatarColor: avatarColorsMapReversed[avatarColor]!,
        ),
      );

      setState(() {
        lastUserData = UserData(
            username: widget.userDataAndStats.userData.username,
            email: emailController.text,
            address: addressController.text,
            phoneNumber: phoneNumberController.text,
            birthday: widget.userDataAndStats.userData.birthday,
            avatarColor: avatarColorsMapReversed[avatarColor]!,
            memberSince: widget.userDataAndStats.userData.memberSince);
      });
      passwordController.text = '';
    } on Error_ServerConnectionError catch (e) {
      if (!mounted || !context.mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(
            errorDialogData: ErrorDialogData(
              title: serverConnErrorText,
              message: e.format(),
            ),
          ),
        ),
      );
    } on Error_UpdateUserDataError catch (e) {
      setState(() {
        _errorText = "• ${e.format()}";
      });
    } on Error catch (e) {
      if (!mounted || !context.mounted) return;
      showErrorDialog(context, unknownErrorText, e.format());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool isAllFieldsValid() {
    bool isAllFieldsEntered = emailController.text.isNotEmpty &&
        addressController.text.isNotEmpty &&
        phoneNumberController.text.isNotEmpty;
    bool isAllFieldsWithoutError = passwordErrorText == null &&
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

Widget _buildStatistics(BuildContext context, UserStatistics userStats) {
  if (userStats.totalGames == 0) {
    return Text(
      "No Games Played Yet",
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.titleMedium!.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.error),
    );
  }

  return Text.rich(
    textAlign: TextAlign.center,
    style: Theme.of(context).textTheme.titleMedium,
    TextSpan(
      children: [
        if (userStats.totalAnswers != 0)
          TextSpan(
            text: "Accuracy:  ",
            style: TextStyle(
              color: accuracyToColor(
                  (userStats.correctAnswers / userStats.totalAnswers)),
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text:
                    "${((userStats.correctAnswers / userStats.totalAnswers) * 100).round()}%\n",
                style: TextStyle(
                  color: accuracyToColor(
                      (userStats.correctAnswers / userStats.totalAnswers)),
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: "Correct Answers:  ",
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: "${userStats.correctAnswers}",
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              TextSpan(
                  text: "    •    ",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.normal,
                  )),
              TextSpan(
                text: "Wrong Answers:  ",
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: "${userStats.wrongAnswers}\n",
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        TextSpan(
          text: "Total Games Played:  ",
          style: const TextStyle(
            color: Color(0xFF43FFBD),
            fontWeight: FontWeight.bold,
          ),
          children: [
            TextSpan(
              text: "${userStats.totalGames}",
              style: const TextStyle(
                color: Color(0xFF43FFBD),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const TextSpan(
          text: "    •    ",
        ),
        TextSpan(
          text: "Score:  ",
          style: const TextStyle(
            color: Color(0xFFFFB156),
            fontWeight: FontWeight.bold,
          ),
          children: [
            TextSpan(
              text: "${userStats.score}",
              style: const TextStyle(
                color: Color(0xFFFFB156),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        if (userStats.averageAnswerTime != null)
          TextSpan(
            text: "\nAverage Answer Time:  ",
            style: const TextStyle(
              color: Color(0xFF8356FF),
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: secondsToReadableTime(userStats.averageAnswerTime!),
                style: const TextStyle(
                  color: Color(0xFF8356FF),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
      ],
    ),
  );
}

Color accuracyToColor(double accuracy) {
  // Ensure accuracy is between 0 and 1
  accuracy = accuracy.clamp(0.0, 1.0);

  // Convert hue to RGB values
  int rgbValue = (accuracy * 255).toInt();
  int redValue = 255 - rgbValue;
  int greenValue = rgbValue;

  return Color.fromARGB(255, redValue, greenValue, 0);
}
