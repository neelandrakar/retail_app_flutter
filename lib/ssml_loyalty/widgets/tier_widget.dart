import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:retail_app_flutter/constants/assets_constants.dart';

import '../../constants/my_colors.dart';
import '../../constants/my_fonts.dart';

class TierWidget extends StatefulWidget {
  final String tier_name;
  final String tier_img;
  final int tier_id;
  final int min_points;
  final int max_points;
  const TierWidget({
    super.key,
    required this.tier_name,
    required this.tier_img,
    required this.tier_id,
    required this.min_points,
    required this.max_points
  });

  @override
  State<TierWidget> createState() => _TierWidgetState();
}

class _TierWidgetState extends State<TierWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Image.asset(
          widget.tier_img,
          width: 100,
          height: 100
        ),
        Text(
          widget.tier_name,
          maxLines: 1,
          style: TextStyle(
              color: MyColors.boneWhite,
              fontSize: 13,
              fontFamily: MyFonts.poppins,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis
          ),
        ),
        Text(
          "${widget.min_points.toString()} pts",
          maxLines: 1,
          style: TextStyle(
              color: MyColors.boneWhite,
              fontSize: 11,
              fontFamily: MyFonts.poppins,
              fontWeight: FontWeight.normal,
              overflow: TextOverflow.ellipsis
          ),
        ),
        LinearPercentIndicator(
              width: 100,
              lineHeight: 8.0,
              percent: 0.5,
              alignment: MainAxisAlignment.start,
              // fillColor: Colors.orange,
              leading: Container(
                decoration: BoxDecoration(
                    color: Colors.yellow,
                    shape: BoxShape.circle,
                    border: Border.all(color: MyColors.orangeColor, width: 2)
                ),
                width: 20,
                height: 20,
              ),
              animation: true,
              padding: EdgeInsets.zero,
              progressColor: Colors.yellow,
            ),
          ],
    );
  }
}
