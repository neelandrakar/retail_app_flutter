import 'package:flutter/material.dart';
import 'package:retail_app_flutter/constants/my_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String hintText;
  final int maxLines;
  final Color? textColor;
  final VoidCallback? onClick;
  final bool readOnly;
  final bool isPassword;
  final bool obscureText;
  final Icon? suffixIcons;
  final IconButton? suffixIconPassword;
  final bool isTweetTextField;
  const CustomTextField({Key? key,
    required this.controller,
    required this.hintText,
    this.maxLines = 1,
    this.textColor,
    this.onChanged,
    this.onClick,
    this.readOnly = false,
    this.isPassword = false,
    this.obscureText = false,
    this.suffixIcons,
    this.suffixIconPassword,
    this.isTweetTextField = false
  })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onClick,
      readOnly: readOnly,
      onChanged: onChanged,
      controller: controller,
      obscureText: obscureText,
      maxLines: maxLines,
      cursorColor: MyColors.mainYellowColor,
      style: TextStyle(
          color: textColor ==  null ? MyColors.whiteColor : textColor
      ),
      decoration: InputDecoration(
        //hintText: isTweetTextField ? hintText : '',
        suffixIcon: isPassword ? suffixIconPassword : suffixIcons,
        //labelText: isTweetTextField ? '' :hintText,
        hintText: hintText,
        fillColor: Colors.white,
        // border: isTweetTextField ? InputBorder.none : OutlineInputBorder(
        //   borderSide: BorderSide(
        //     color: MyColors.mainYellowColor,
        //   ),
        // ),
        // enabledBorder: isTweetTextField ? InputBorder.none : OutlineInputBorder(
        //   borderSide: BorderSide(
        //     color: MyColors.mainYellowColor,
        //   ),
        // ),
        //
        // focusedBorder: isTweetTextField ? InputBorder.none : OutlineInputBorder(
        //   borderSide: BorderSide(
        //     color: MyColors.mainYellowColor,
        //   ),
        // ),


        // Set the text color of the input
        hintStyle: TextStyle(
          color: MyColors.whiteColor, // Change the hint text color
        ),
        // Set the text color of the input
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 12.0,
        ),
        // Adjust the content padding for text alignment
      ),
      validator: (val) {


        if(!isPassword) {
          if (val == null || val.isEmpty) {
            return 'Enter your $hintText';
          }
          return null;
        } else{
          if (val == null || val.isEmpty) {
            return 'Enter your $hintText';
          } else if(val.length<8){
            return 'Password must be atleast 8 characters long';
          }
          return null;
        }
      },
    );
  }
}
