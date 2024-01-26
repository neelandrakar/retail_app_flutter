import 'package:flutter/material.dart';
import 'package:retail_app_flutter/constants/my_colors.dart';

import '../../constants/my_fonts.dart';

class SecondaryAccountBox extends StatefulWidget {
  final String? box_image;
  final String? box_title;
  final String? box_subtitle;
  final VoidCallback onClick;
  const SecondaryAccountBox({super.key, required this.box_image, required this.box_title, required this.box_subtitle, required this.onClick});

  @override
  State<SecondaryAccountBox> createState() => _SecondaryAccountBoxState();
}

class _SecondaryAccountBoxState extends State<SecondaryAccountBox> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onClick,
      child: Container(
        height: 80,
        width: double.infinity,
        decoration: BoxDecoration(
          color: MyColors.whiteColor,
          borderRadius: BorderRadius.circular(20)
        ),
        child: Row(
          children: [
            SizedBox(width: 10,),
            Image.asset(widget.box_image!, fit: BoxFit.fill,height: 50,width: 50,),
            SizedBox(width: 10,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.box_title!,
                  style: TextStyle(
                      color: MyColors.blackColor,
                      fontFamily: MyFonts.poppins,
                      fontWeight: FontWeight.w600
                  ),
                ),
                Text(widget.box_subtitle!,
                  style: TextStyle(
                    color: MyColors.fadedBlack,
                    fontFamily: MyFonts.poppins,
                    fontWeight: FontWeight.w100,
                    fontSize: 10,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
