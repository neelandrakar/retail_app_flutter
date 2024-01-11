import 'package:flutter/material.dart';
import 'package:retail_app_flutter/constants/my_colors.dart';

class WeekDaysBox extends StatefulWidget {
  final String day;
  final int date;
  final bool isToday;
  const WeekDaysBox({super.key, required this.day, required this.date, required this.isToday});

  @override
  State<WeekDaysBox> createState() => _WeekDaysBoxState();
}

class _WeekDaysBoxState extends State<WeekDaysBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 35,
      decoration: BoxDecoration(
        border: Border.all(color: MyColors.black12),
        borderRadius: BorderRadius.circular(10),
        color: widget.isToday ? MyColors.purpleColor : MyColors.boneWhite
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(widget.day,
            style: TextStyle(
                color: widget.isToday ? MyColors.whiteColor : MyColors.fadedBlack,
              fontSize: 13,
              fontFamily: 'Poppins'
            ),
          ),
          Text(widget.date.toString(),
            style: TextStyle(
                color: widget.isToday ? MyColors.whiteColor : MyColors.appBarColor,
                fontSize: 13,
                fontFamily: 'Poppins',
              fontWeight: FontWeight.w600
            ),
          ),
        ],
      ),
    );
  }
}
