import 'package:flutter/material.dart';
import 'package:retail_app_flutter/attendance/widgets/attendance_card_details.dart';
import 'package:retail_app_flutter/constants/assets_constants.dart';
import 'package:retail_app_flutter/constants/my_colors.dart';
import 'package:retail_app_flutter/constants/utils.dart';

class AttendanceCard extends StatefulWidget {
  final int? field_time;
  final DateTime? checkin_time;
  final DateTime? checkout_time;
  final DateTime date;
  final int visit_count;
  final int start_km;
  final int end_km;
  final int checkin_deviation;
  final int checkout_deviation;
  final int vehicle_type;
  final int login_status;
  final String startOdometer;
  final String endOdometer;
  const AttendanceCard({
    super.key,
    required this.field_time,
    required this.checkin_time,
    required this.date,
    required this.visit_count,
    this.checkout_time,
    required this.start_km,
    required this.end_km,
    required this.checkin_deviation,
    required this.checkout_deviation,
    required this.vehicle_type,
    required this.login_status,
    required this.startOdometer,
    required this.endOdometer
  });

  @override
  State<AttendanceCard> createState() => _AttendanceCardState();
}

class _AttendanceCardState extends State<AttendanceCard> {

  String emp_checkin_time = 'NA';
  String emp_checkout_time = 'NA';
  String date = 'NA';
  String vehicle = 'NA';
  String field_time = 'NA';

  @override
  Widget build(BuildContext context) {

    double fontSize = 9.5;
    if(widget.field_time!=null){

      field_time = '${widget.field_time.toString()} min';
    }


    if(widget.checkin_time!=null){
      emp_checkin_time = fetchBasicTimeFormat(widget.checkin_time!);
    }


    if(widget.checkout_time!=null){
      emp_checkout_time = fetchBasicTimeFormat(widget.checkout_time!);
    }

    if(widget.date!=null){
      date = fetchBasicDateFormat(widget.date);
    }

    if(widget.vehicle_type==1){
      vehicle = 'Bike';
    } else if(widget.vehicle_type==2){
      vehicle = 'Car';
    } else if(widget.vehicle_type==3){
      vehicle = 'Others';
    }

    return Container(
      width: double.infinity,
      height: 115,
      decoration: BoxDecoration(
        color: Color(0xfff8f5ff),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: MyColors.offWhiteColor, width: 0.5)
      ),
      child:
      (widget.login_status==1) ?
        Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.timelapse_outlined, color: MyColors.purpleColor,size: 15,),
                    SizedBox(width: 5,),
                    Text('Field Time:',
                      style: TextStyle(
                        color: MyColors.blackColor,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 12
                      ),
                    ),
                    SizedBox(width: 5,),
                    Text('$field_time',
                      style: TextStyle(
                          color: MyColors.purpleColor,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 12
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(date,
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          color: MyColors.fadedBlack,
                          fontSize: 12
                      ),
                    ),
                    SizedBox(width: 5,),
                    Icon(Icons.calendar_month_outlined, color: MyColors.fadedBlack,size: 12,)
                  ],
                ),
              ],
            ),
            SizedBox(height: 8,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AttendanceCardDetails(
                      fontSize: fontSize,
                      dataOne: 'Checkin time',
                      dataTwo: emp_checkin_time,
                      dataThree: 'Total Visit',
                      dataFour: widget.visit_count.toString()),
                  SizedBox(width: 15,),
                  AttendanceCardDetails(
                      fontSize: fontSize,
                      dataOne: 'Checkout time',
                      dataTwo: emp_checkout_time,
                      dataThree: 'Start KM',
                      dataFour: widget.start_km.toString(),
                      isKM: true,
                      isStartKM: true,
                      startOdometer: widget.startOdometer,
                      endOdometer: widget.endOdometer,
                  ),
                  SizedBox(width: 15,),
                  AttendanceCardDetails(
                      fontSize: fontSize,
                      dataOne: 'Checkin dev.',
                      dataTwo: '${widget.checkin_deviation.toString()} min',
                      dataThree: 'End KM',
                      dataFour: widget.end_km.toString(),
                      isKM: true,
                      isEndKM: true,
                      startOdometer: widget.startOdometer,
                      endOdometer: widget.endOdometer,
                  ),
                  SizedBox(width: 15,),
                  AttendanceCardDetails(
                      fontSize: fontSize,
                      dataOne: 'Checkout dev.',
                      dataTwo: '${widget.checkout_deviation.toString()} min',
                      dataThree: 'Vehicle',
                      dataFour: vehicle),
                ],
              ),
            )
          ],
        ),
      ) :
    Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            AssetsConstants.absent_image,
            fit: BoxFit.fill,
          ),
          Positioned(
            top: 15,
            left: 238,
            child: Row(
              children: [
                Text(date,
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      color: MyColors.absentBoxText,
                      fontSize: 12
                  ),
                ),
                SizedBox(width: 5,),
                Icon(
                  Icons.calendar_month_outlined,
                  color: MyColors.absentBoxText,
                  size: 12,)
              ],
            ),
          ),
        ],
      )
    );
  }
}
