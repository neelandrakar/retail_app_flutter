import 'package:flutter/material.dart';
import 'package:retail_app_flutter/constants/my_colors.dart';

class CustomButton extends StatefulWidget {
  final VoidCallback onClick;
  final String buttonText;
  final double height; // Add a parameter for height
  final double width;  // Add a parameter for width
  final Color? buttonColor;
  final Color? borderColor;
  final Color? textColor;
  final bool? suffixIcon;
  final double borderRadius;
  final double buttonTextSize;

  const CustomButton({
    Key? key,
    required this.onClick,
    required this.buttonText,
    this.height = 50, // Default height value
    this.width = 200,
    this.buttonColor,
    this.borderColor,
    this.textColor,
    this.suffixIcon = false,
    this.buttonTextSize = 18,
    required this.borderRadius,  // Default width value
  }) : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onClick,
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            side:  BorderSide(
              width: 1,
              color: widget.borderColor ?? Colors.transparent, // Use the null-aware operator

            )
          ),
          fixedSize: Size(widget.width, widget.height),
          backgroundColor: widget.buttonColor == null ? MyColors.whiteColor : widget.buttonColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(widget.buttonText,
          style: TextStyle(
            fontSize: widget.buttonTextSize,

            color: widget.textColor == null ? MyColors.mainYellowColor : widget.textColor
          ),
          ),
          Visibility(
            visible: widget.suffixIcon == true, // Show the icon if suffixIcon is true
            child: Icon(Icons.keyboard_arrow_down_rounded,color: Colors.blueAccent,),
          ),        ],
      ),
    );
  }
}
