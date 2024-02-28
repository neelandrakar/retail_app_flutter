import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:retail_app_flutter/attendance/screens/submit_odometer_screen.dart';
import 'package:retail_app_flutter/attendance/services/attendance_services.dart';
import 'package:retail_app_flutter/attendance/widgets/attendance_card.dart';
import 'package:retail_app_flutter/attendance/widgets/grace_box.dart';
import 'package:retail_app_flutter/attendance/widgets/grace_pie_chart.dart';
import 'package:retail_app_flutter/attendance/widgets/logout_alert.dart';
import 'package:retail_app_flutter/attendance/widgets/present_absent_leave.dart';
import 'package:retail_app_flutter/attendance/widgets/week_days_box.dart';
import 'package:retail_app_flutter/constants/assets_constants.dart';
import 'package:retail_app_flutter/constants/custom_button.dart';
import 'package:retail_app_flutter/constants/custom_button_two.dart';
import 'package:retail_app_flutter/constants/my_colors.dart';
import 'package:intl/intl.dart';
import 'package:retail_app_flutter/constants/utils.dart' as utils;
import 'package:retail_app_flutter/home/screens/home_screen.dart';
import 'package:timezone/timezone.dart';
import '../../models/attendance_screen_model.dart';
import '../../models/employee.dart';
import '../../providers/attendance_model_provider.dart';
import '../../providers/attendance_model_provider.dart';
import '../../providers/user_provider.dart';
import '../../sidemenu/screens/side_menu.dart';

class AttendanceScreen extends StatefulWidget {
  static const String routeName = '/attendance-screen';
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {

  final AttendanceServices attendanceServices = AttendanceServices();
  int sideMenuItemNo = 2;


  Future<void> _fetchAttendanceData(BuildContext context) async {
    await Future.delayed(Duration.zero, () {
      attendanceServices.fetchAttendanceData(
          context: context,
          setState: () {
            setState(() {});
          });
    });
  }

  @override
  void initState() {
    _fetchAttendanceData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Employee emp =
        Provider.of<EmployeeProvider>(context, listen: false).employee;
    var attendanceprovider =
        Provider.of<AttendanceModelProvider>(context, listen: false)
            .attendanceScreenModel;
    var getAttendance = attendanceprovider.get_attendance;

    DateTime joiningDate = emp.joining_date;
    String formattedJoiningDate = utils.getDateUniversalFormat(joiningDate);

    void openHRMS() {
      print(emp.emp_name);
    }



    int presentDays = 0;
    int absentDays = 0;
    int leaveDays = 0;

    for (int i = 0; i < attendanceprovider.get_attendance.length; i++) {
      if (attendanceprovider.get_attendance[i].login_status == 1) {
        presentDays += 1;
      }

      if (attendanceprovider.get_attendance[i].login_status == 2) {
        absentDays += 1;
      }

      if (attendanceprovider.get_attendance[i].login_status == 3) {
        leaveDays += 1;
      }
    }

    String getInitials(String name) {
      List<String> words = name.split(' ');
      print(words);
      String initials = '';

      for (String word in words) {
        initials += word[0];
      }

      return initials;
    }

    void performLogin() async{
      // utils.getLocation();

      if (!attendanceprovider.hasLoggedInToday) {

        attendanceServices.login(
            context: context,
            onSuccess: () {
              attendanceprovider.hasLoggedInToday = true;

              setState(() {});
              Navigator.pushNamed(context, SubmitOdometerScreen.routeName);
            });
      } else if(attendanceprovider.hasLoggedInToday && getAttendance[getAttendance.length-1].vehicle==0){

        Navigator.pushNamed(context, SubmitOdometerScreen.routeName);
      } else if(attendanceprovider.hasLoggedInToday && getAttendance[getAttendance.length-1].vehicle>0){

        await attendanceServices.updateEmployeeData(context: context, onSuccess: () async {
            Navigator.pushNamed(context, HomeScreen.routeName);
          });
      }
    }


    void performLogout() {

      if (attendanceprovider.hasLoggedInToday) {
        attendanceServices.logout(
            context: context,
            onSuccess: () {
              setState(() {});
              showDialog(
                  context: context,
                  builder: (BuildContext con){
                    return LogoutAlert();
                  });
            });
      }
    }



    List<DateTime> allWeekDays = utils.getAllWeekDays();

    return Scaffold(
      backgroundColor: MyColors.offWhiteColor,
      drawer: Drawer(
        backgroundColor: MyColors.appBarColor,
        child: SideMenu(
          side_menu_item_no: sideMenuItemNo,
        ),
        width: 280,
      ),
      appBar: AppBar(
          title: Image.asset(
            AssetsConstants.shyam_steel_logo_round,
            width: 50,
            height: 50,
          ),
          centerTitle: true,
          backgroundColor: MyColors.appBarColor,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(160),
            child: Container(
              color: MyColors.offWhiteColor,
              child: Container(
                height: 160.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: MyColors.boneWhite,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(25),
                      bottomLeft: Radius.circular(25)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: const Offset(
                        1.0,
                        1.0,
                      ),
                      blurRadius: 3.0,
                      spreadRadius: 1.0,
                    ), //BoxShadow
                    BoxShadow(
                      color: Colors.white,
                      offset: const Offset(0.0, 0.0),
                      blurRadius: 0.0,
                      spreadRadius: 0.0,
                    ), //BoxShadow
                  ],
                ),
                child: Container(
                  // color: MyColors.redColor,
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  transform: Matrix4.translationValues(0.0, -25.0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                              height: 45,
                              width: 50,
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Color(0xffa1d4f3),
                                  borderRadius: BorderRadius.circular(10)),
                              alignment: Alignment.center,
                              child: Text(
                                getInitials(emp.emp_name),
                                style: TextStyle(
                                    color: MyColors.appBarColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              )),
                          Container(
                              transform:
                                  Matrix4.translationValues(0.0, 20.0, 0),
                              child: CustomButtonTwo(
                                onClick: () {
                                  print(emp.emp_name);
                                },
                                height: 25,
                                width: 75,
                                buttonColor: Colors.green.shade700,
                                borderRadius: 20,
                                button_text: 'Open HRMS',
                                text_color: MyColors.whiteColor,
                                button_text_size: 10,
                              ))
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                emp.emp_name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 16,
                                    overflow: TextOverflow.ellipsis,
                                    color: MyColors.appBarColor,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.calendar_month_outlined,
                                      size: 13, color: MyColors.fadedBlack),
                                  SizedBox(width: 5),
                                  Text(
                                    'Joined on $formattedJoiningDate',
                                    style: TextStyle(
                                      color: MyColors.fadedBlack,
                                      fontSize: 12,
                                      fontFamily: 'Poppins',
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.refresh_outlined,
                                      size: 13, color: MyColors.fadedBlack),
                                  SizedBox(width: 5),
                                  Text(
                                    'Cycle ${attendanceprovider.cycle_start_date} to ${attendanceprovider.cycle_end_date}',
                                    style: TextStyle(
                                      color: MyColors.fadedBlack,
                                      fontSize: 12,
                                      fontFamily: 'Poppins',
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                  // color: MyColors.offWhiteColor,
                                  width: 180,
                                  child: Row(
                                    children: [
                                      PresentAbsentLeave(
                                        textColor: Colors.green,
                                        text: 'Present',
                                        value: presentDays,
                                      ),
                                      PresentAbsentLeave(
                                        textColor: Colors.redAccent,
                                        text: 'Absent',
                                        value: absentDays,
                                      ),
                                      PresentAbsentLeave(
                                        textColor: Colors.blue.shade900,
                                        isLast: true,
                                        text: 'Leave',
                                        value: leaveDays,
                                      )
                                    ],
                                  )),
                            ],
                          ),
                          GraceBox(
                            totalGrace: 600,
                            totalUsed: 145,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 137,
                  width: 220,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        AssetsConstants.attendance_img,
                        fit: BoxFit.fill,
                      ),
                      Positioned(
                        top: 90,
                        left: 20,
                        child: GestureDetector(
                          onTap: performLogin,
                          child: Text(
                            attendanceprovider.hasLoggedInToday
                                ? 'Go to dashboard'
                                : 'Login',
                            style: TextStyle(
                              color: MyColors.whiteColor,
                              fontFamily: 'Poppins',
                              overflow: TextOverflow.ellipsis,
                              decoration: TextDecoration.underline,
                              decorationColor: MyColors.whiteColor,
                              decorationThickness: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Container(
                    height: 130,
                    width: 119,
                    child: Stack(
                      children: [
                        Image.asset(
                          AssetsConstants.logout_background,
                          fit: BoxFit.fill,
                        ),
                        Positioned(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                utils.fetchISTDate(false, attendanceprovider.current_date),
                                maxLines: 1,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: MyColors.whiteColor,
                                  fontSize: 19,
                                ),
                              ),
                              Text('2024',
                                  style: TextStyle(
                                      fontSize: 28,
                                      color: MyColors.whiteColor,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold)),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: CustomButton(
                                  onClick: performLogout,
                                  buttonText: 'Logout',
                                  borderRadius: 20,
                                  textColor: MyColors.whiteColor,
                                  buttonColor: MyColors.blueColorInsidePurple,
                                  width: 50,
                                  height: 30,
                                  buttonTextSize: 14,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: MyColors.boneWhite,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25),
                  topLeft: Radius.circular(25),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(
                      1.0,
                      1.0,
                    ),
                    blurRadius: 3.0,
                    spreadRadius: 1.0,
                  ), //BoxShadow
                  BoxShadow(
                    color: Colors.white,
                    offset: Offset(0.0, 0.0),
                    blurRadius: 0.0,
                    spreadRadius: 0.0,
                  ), //BoxShadow
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              AssetsConstants.bar_chart_icon,
                              height: 20,
                              width: 20,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Attendance Report',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: MyColors.blackColor,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                  fontSize: 17),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              utils.fetchISTDate(true, attendanceprovider.current_date),
                              style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'Poppins',
                                  color: MyColors.blackColor,
                                  fontWeight: FontWeight.w500),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: MyColors.greyColor,
                              size: 18,
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 15,),
                    Container(
                      // color: MyColors.offWhiteColor,
                      height: 50,
                      width: double.infinity,
                      child: ListView.separated(
                        itemCount: allWeekDays.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {

                          String fetchWeekDate() {
                            DateTime utcDate = allWeekDays[index];
                            DateTime istDate = utcDate.add(Duration(hours: 5, minutes: 30));
                            String date = DateFormat('d').format(istDate);

                            return date;
                          }

                          String fetchDayName(){
                            String dayName = DateFormat('EE').format(allWeekDays[index]);

                            return dayName;
                          }



                          bool isToday = (DateFormat.yMd().format(allWeekDays[index]) == DateFormat.yMd().format(attendanceprovider.current_date.toLocal()));



                          return WeekDaysBox(
                            date: int.parse(fetchWeekDate()),
                            day: fetchDayName(),
                            isToday: isToday ? true : false,
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(width: 13,);
                        },
                      ),
                    ),
                    SizedBox(height: 15,),
                    Expanded(
                        child: ListView.separated(
                            itemCount: attendanceprovider.get_attendance.length,
                            itemBuilder: (context,index){

                              var attIndex = attendanceprovider.get_attendance[index];

                              // print('odo: '+ attIndex.endOdometer);


                              return AttendanceCard(
                                field_time: attIndex.field_time,
                                checkin_time: attIndex.checkin_time,
                                checkout_time: attIndex.checkout_time,
                                date: attIndex.date,
                                visit_count: 0,
                                start_km: attIndex.startKM,
                                end_km: attIndex.endKM,
                                checkin_deviation: attIndex.checkin_deviation,
                                checkout_deviation: attIndex.checkout_deviation,
                                vehicle_type: attIndex.vehicle,
                                login_status: attIndex.login_status,
                                startOdometer: attIndex.startOdometer,
                                endOdometer: attIndex.endOdometer
                              );
                            }, separatorBuilder: (context,index) {
                              return SizedBox(
                                height: 10);
                        },
                        )
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
