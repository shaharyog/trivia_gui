import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../consts.dart';

class InputField extends StatefulWidget {
  final String label;
  final bool isPassword;
  final TextInputType inputType;
  final TextInputAction textInputAction;
  final List<TextInputFormatter>? formatters;
  final Function(String)? validate;
  final String? errorText;
  final TextEditingController controller;
  final String? initialValue;
  final bool showPassword;
  final Widget? suffixIcon;

  const InputField({
    required this.controller,
    required this.errorText,
    required this.validate,
    required this.label,
    this.suffixIcon,
    this.initialValue,
    this.isPassword = false,
    this.showPassword = false,
    this.inputType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.formatters,
    super.key,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: maxTextFieldWidth),
      child: TextFormField(
        initialValue: widget.initialValue,
        onChanged: widget.validate,
        validator: (value) => widget.errorText,
        controller: widget.controller,
        inputFormatters: widget.formatters,
        keyboardType: widget.inputType,
        textInputAction: widget.textInputAction,
        obscureText: widget.isPassword ? !widget.showPassword : false,
        decoration: InputDecoration(
          errorText: widget.errorText,
          border: const OutlineInputBorder(),
          labelText: widget.label,
          suffixIcon: widget.suffixIcon,
        ),
      ),
    );
  }
}
