import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputField extends StatefulWidget {
  final String label;
  final bool obscureText;
  final bool moveFocusToNext;
  final bool isNumberField;
  final List<TextInputFormatter>? formatter;
  final Function(String) onChanged;

  const InputField({
    super.key,
    required this.label,
    required this.onChanged,
    this.moveFocusToNext = false,
    this.isNumberField = false,
    this.obscureText = false,
    this.formatter,
  });

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late TextEditingController _controller;
  bool _isObscure = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _isObscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      child: TextField(
        onChanged: (String value) {
          widget.onChanged(value);
        },
        keyboardType: widget.obscureText
            ? TextInputType.visiblePassword
            : widget.isNumberField
                ? TextInputType.number
                : null,
        controller: _controller,
        inputFormatters: widget.formatter,
        obscureText: _isObscure,
        textInputAction: widget.moveFocusToNext
            ? TextInputAction.next
            : TextInputAction.done,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: widget.label,
          suffixIcon: widget.obscureText
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Icon(
                        _isObscure
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        size: 24,
                      ),
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
