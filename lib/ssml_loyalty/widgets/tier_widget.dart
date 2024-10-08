import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../constants/my_colors.dart';
import '../../constants/my_fonts.dart';

class TierWidget extends StatefulWidget {
  final String tier_name;
  final String tier_img;
  final int tier_id;
  final int min_points;
  final int max_points;
  final int is_current;
  final int till_next_tier;
  final int total_points;
  final int widgetWidth;
  const TierWidget({
    super.key,
    required this.tier_name,
    required this.tier_img,
    required this.tier_id,
    required this.min_points,
    required this.max_points,
    required this.is_current,
    required this.till_next_tier,
    required this.total_points,
    required this.widgetWidth
  });

  @override
  State<TierWidget> createState() => _TierWidgetState();
}

class _TierWidgetState extends State<TierWidget> {

  double filled_up = 0;

  double getFillUpData(){
    if(widget.is_current==1){
      filled_up = 1;
    } else if(widget.is_current==2){

      filled_up = ((widget.max_points-widget.min_points)/widget.total_points);

    } else if(widget.is_current==3){
      filled_up = 0;
    }
    return filled_up;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.widgetWidth.toDouble(),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.network(widget.tier_img, width: 100,height: 100),
          SizedBox(height: 20),
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
          SizedBox(height: 10),
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
          SizedBox(height: 25),
          LinearPercentIndicator(
                width: 120,
                lineHeight: 8.0,
                percent: getFillUpData(),
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
      ),
    );
  }
}
