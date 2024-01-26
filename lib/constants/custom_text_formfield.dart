import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'my_colors.dart';
import 'my_fonts.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextStyle hintStyle;
  final TextStyle enteredTextStyle;
  final Color textFieldColor;
  final int? maxLines;
  final Icon prefixIcon;
  final double width;
  final double height;
  final TextInputType? keyBoardType;
  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.textFieldColor,
    required this.hintStyle,
    this.maxLines=1,
    this.keyBoardType=TextInputType.text,
    required this.enteredTextStyle,
    required this.prefixIcon,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      child: TextFormField(
        maxLines: maxLines,
        controller: controller,
        keyboardType: keyBoardType,
        // expands: true,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: prefixIcon,
          filled: true,
          hintStyle: hintStyle,
          fillColor: textFieldColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
        ),
        style: enteredTextStyle,
      ),
    );
  }
}
