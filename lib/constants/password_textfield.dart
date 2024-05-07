import 'package:flutter/material.dart';
import 'package:retail_app_flutter/constants/my_colors.dart';

import 'my_fonts.dart';

class PasswordTextField extends StatefulWidget {
  final Color textFieldColor;
  final String hintText;
  final String labelText;
  final String? helperText;
  final TextEditingController controller;
  const PasswordTextField({super.key, required this.textFieldColor, required this.hintText, required this.labelText, required this.controller, this.helperText});

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: !showPassword,
      controller: widget.controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none
        ),
        hintText: widget.hintText,
        helperText: widget.helperText,
        helperStyle: TextStyle(
            color: MyColors.redColor
        ),
        hintStyle: TextStyle(
            color: MyColors.greyColor,
            fontSize: 14,
            fontFamily: MyFonts.poppins,
            fontWeight: FontWeight.w600),
        suffixIcon: IconButton(
          icon: Icon(showPassword
              ? Icons.visibility
              : Icons.visibility_off),
          onPressed: () {
            setState(
                  () {
                    showPassword = !showPassword;
              },
            );
          },
        ),
        alignLabelWithHint: false,
        filled: true,
        fillColor: widget.textFieldColor
      ),
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
    );
  }
}
