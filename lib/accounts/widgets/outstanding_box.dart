import 'package:flutter/material.dart';
import 'package:retail_app_flutter/constants/my_colors.dart';
import 'package:retail_app_flutter/constants/utils.dart';

import '../../constants/my_fonts.dart';

class OutstandingBox extends StatelessWidget {
  final String date_range;
  final int osValue;
  const OutstandingBox({super.key, required this.date_range, required this.osValue});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 10),
        Container(
          height: 40,
          width: 60,
          decoration: BoxDecoration(
            color: MyColors.ashColor,
            borderRadius: BorderRadius.circular(10)
          ),
          child: Column(
            children: [
              Container(
                height: 20,
                alignment: Alignment.center,
                child: Text(
                  date_range,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    color: MyColors.blackColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                    fontFamily: MyFonts.poppins,
                  ),
                ),
              ),
              Container(
                height: 20,
                width: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: MyColors.outstandingBoxBlue,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  )
                ),
                child: Text(
                  convertToINR(osValue),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    color: MyColors.boneWhite,
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                    fontFamily: MyFonts.poppins,
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
