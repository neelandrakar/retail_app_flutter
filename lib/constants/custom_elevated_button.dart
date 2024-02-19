import 'package:flutter/material.dart';
import 'package:retail_app_flutter/constants/my_fonts.dart';

class CustomElevatedButton extends StatelessWidget {
  final String buttonText;
  final IconData? buttonIcon;
  final Color buttonColor;
  final Color buttonTextColor;
  final Color? buttonIconColor;
  final double? width;
  final double height;
  final double? iconSize;
  final double? textSize;
  final VoidCallback onClick;
  const CustomElevatedButton({
    super.key,
    required this.buttonText,
    this.buttonIcon,
    required this.buttonColor,
    required this.buttonTextColor,
    this.buttonIconColor,
    this.width,
    required this.height,
    required this.onClick,
    this.iconSize = 15,
    this.textSize = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 10),
            foregroundColor: buttonTextColor,
            backgroundColor: buttonColor,
            textStyle: TextStyle(
              overflow: TextOverflow.ellipsis,
              fontFamily: MyFonts.poppins,
              color: buttonTextColor,
              fontSize: textSize
        )),
        onPressed: onClick,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              if(buttonIcon!=null)
              Icon(buttonIcon, color: buttonIconColor, size: iconSize,),
            if(buttonIcon!=null)
              SizedBox(width: 3,),
              Container(
                  alignment: Alignment.center,
                  width: (width!-20),
                  child: Text(buttonText, maxLines: 1, overflow: TextOverflow.ellipsis,))
          ],
        ),
      ),
    );
  }
}
