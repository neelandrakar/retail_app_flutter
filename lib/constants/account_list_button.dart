import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'my_colors.dart';
import 'my_fonts.dart';

class AccountListButton extends StatelessWidget {
  final Color buttonColor;
  final String buttonText;
  final IconData buttonIcon;
  final Color iconColor;
  final double iconSize;
  final VoidCallback onClick;
  const AccountListButton({super.key, required this.buttonColor, required this.buttonText, required this.buttonIcon, required this.iconColor, required this.iconSize, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: (){
            onClick.call();
            print(buttonText);
          },
          child: Container(
            height: 25,
            // width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: buttonColor
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                children: [
                  Icon(buttonIcon, color: iconColor, size: iconSize,),
                  SizedBox(width: 3),
                  Text(
                    buttonText,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      color: MyColors.blackColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      fontFamily: MyFonts.poppins,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 4,)
      ],
    );
  }
}
