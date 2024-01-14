import 'package:flutter/material.dart';

import '../../constants/my_colors.dart';
import '../../constants/my_fonts.dart';

class SaleBoxColumn extends StatelessWidget {
  final String upperText;
  final String lowerText;
  const SaleBoxColumn({super.key, required this.upperText, required this.lowerText});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          upperText,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
            color: MyColors.fadedBlack,
            fontWeight: FontWeight.w400,
            fontSize: 11,
            fontFamily: MyFonts.poppins,
          ),
        ),
        SizedBox(height: 2,),
        Text(
          lowerText,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
            color: MyColors.deepBlueColor,
            fontWeight: FontWeight.w600,
            fontSize: 12,
            fontFamily: MyFonts.poppins,
          ),
        ),
      ],
    );
  }
}
