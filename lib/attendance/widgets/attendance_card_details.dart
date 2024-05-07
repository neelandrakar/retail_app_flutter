import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:retail_app_flutter/attendance/widgets/odometer_dialogue.dart';

import '../../constants/my_colors.dart';

class AttendanceCardDetails extends StatefulWidget {
  final double fontSize;
  final String dataOne;
  final String dataTwo;
  final String dataThree;
  final String dataFour;
  final bool isKM;
  final bool isStartKM;
  final bool isEndKM;
  final String startOdometer;
  final String endOdometer;
  const AttendanceCardDetails({
    super.key,
    required this.fontSize,
    required this.dataOne,
    required this.dataTwo,
    required this.dataThree,
    required this.dataFour,
    this.isKM = false,
    this.isStartKM = false,
    this.isEndKM = false,
    this.startOdometer = '',
    this.endOdometer = ''
  });

  @override
  State<AttendanceCardDetails> createState() => _AttendanceCardDetailsState();
}

class _AttendanceCardDetailsState extends State<AttendanceCardDetails> {
  @override
  Widget build(BuildContext context) {




    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.dataOne,
          style: TextStyle(
              fontFamily: 'Poppins',
              color: MyColors.fadedBlack,
              fontSize: widget.fontSize
          ),
        ),
        SizedBox(height: 2,),
        Text(
          widget.dataTwo,
          style: TextStyle(
              color: MyColors.blackColor,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: widget.fontSize
          ),
        ),
        SizedBox(height: 5,),
        Text(
          widget.dataThree,
          style: TextStyle(
              fontFamily: 'Poppins',
              color: MyColors.fadedBlack,
              fontSize: widget.fontSize
          ),
        ),
        SizedBox(height: 2,),
        widget.isKM ? Row(
          children: [
            Text(
              widget.dataFour,
              style: TextStyle(
                  color: MyColors.blackColor,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: widget.fontSize
              ),
            ),
            SizedBox(width: 3,),
            Icon(Icons.remove_red_eye, size: 12,),
            SizedBox(width: 3,),
            GestureDetector(
              onTap: () async{
                print(widget.endOdometer);
                await showDialog(
                    context: context,
                    builder: (_) => OdometerDialogue(odometerImage: widget.isStartKM ? widget.startOdometer : widget.endOdometer)
                );
              },
              child: Text('View',
                style: TextStyle(
                    color: MyColors.purpleColor,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: widget.fontSize,
                    decoration: TextDecoration.underline
                ),
              ),
            )
          ],
        ) : Text(
          widget.dataFour,
          style: TextStyle(
              color: MyColors.blackColor,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: widget.fontSize
          ),
        )

      ],
    );
  }
}
