import 'package:flutter/material.dart';
import 'package:retail_app_flutter/constants/custom_elevated_button.dart';

import '../../constants/my_colors.dart';
import '../../constants/my_fonts.dart';

class PointsWidget extends StatefulWidget {
  final String box_text;
  final String total_points;
  final bool show_button;
  const PointsWidget({
    super.key,
    required this.box_text,
    required this.total_points,
    required this.show_button
  });

  @override
  State<PointsWidget> createState() => _PointsWidgetState();
}

class _PointsWidgetState extends State<PointsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 130,
      decoration: BoxDecoration(
        color: MyColors.boneWhite,
        borderRadius: BorderRadius.circular(20)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.box_text,
            maxLines: 1,
            style: TextStyle(
                color: MyColors.fadedBlack,
                fontSize: 11,
                fontFamily: MyFonts.poppins,
                fontWeight: FontWeight.normal,
                overflow: TextOverflow.ellipsis
            ),
          ),
          SizedBox(height: 2),
          Text(
            widget.total_points,
            maxLines: 1,
            style: TextStyle(
                color: MyColors.blackColor,
                fontSize: 15,
                fontFamily: MyFonts.poppins,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis
            ),
          ),
          SizedBox(height: 2),
          Text(
            '(₹${widget.total_points})',
            maxLines: 1,
            style: TextStyle(
                color: MyColors.fadedBlack,
                fontSize: 12,
                fontFamily: MyFonts.poppins,
                fontWeight: FontWeight.normal,
                overflow: TextOverflow.ellipsis
            ),
          ),
          if(widget.show_button)
            Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: CustomElevatedButton(
                buttonText: 'Redeem',
                buttonColor: MyColors.redColor,
                buttonTextColor: MyColors.boneWhite,
                height: 20,
                onClick: (){
                  print('navigate');
                }),
          ),
        ],
      ),
    );
  }
}
