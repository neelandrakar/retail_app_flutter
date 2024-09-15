import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:retail_app_flutter/attendance/services/attendance_services.dart';
import 'package:retail_app_flutter/constants/data_sync_loader.dart';
import 'package:retail_app_flutter/constants/global_variables.dart';
import 'package:retail_app_flutter/constants/my_colors.dart';
import 'package:retail_app_flutter/constants/saved_location_sp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/employee.dart';
import '../providers/ssml_loyalty_provider.dart';
import '../providers/user_provider.dart';
import 'assets_constants.dart';

void showSnackBar(BuildContext context,String text){
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: MyColors.fadedAppbarColor,
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'Dismiss',
            disabledTextColor: MyColors.boneWhite,
            textColor: Colors.yellow,
            onPressed: () {
              //Do whatever you want
            },
          ),
          content:
          Text(
            text,
            style: TextStyle(
                fontFamily: 'Poppins',
              color: MyColors.boneWhite
            ),
          )));
}

List<DateTime> getAllWeekDays() {
  DateTime getWeekStart(DateTime date) {
    date = DateTime(date.year, date.month, date.day);
    var weekday = date.weekday;
    if (weekday == DateTime.sunday) {
      return date;
    } else {
      return date.subtract(Duration(days: weekday - 1));
    }
  }

  List<DateTime> getNextDays(DateTime date) {
    date = DateTime(date.year, date.month, date.day);
    var weekday = date.weekday;

    // Calculate Sunday of the current week
    var sunday = getWeekStart(date);

    // Get a list of the next 7 days starting from Sunday
    var nextDays = List<DateTime>.generate(7, (index) {
      return sunday.add(Duration(days: index));
    });

    return nextDays;
  }

  var date = DateTime.now();
  var nextDays = getNextDays(date);
  return nextDays;
}

String fetchISTDate(bool calenderView, DateTime date) {
  DateTime utcDate = date;
  DateTime istDate = utcDate.add(Duration(hours: 5, minutes: 30));
  String formattedDate = calenderView
      ? DateFormat('MMM, yyy').format(istDate)
      : DateFormat('d MMM').format(istDate);

  return formattedDate;
}

String fetchBasicTimeFormat(DateTime date){

  DateTime istDate = date.add(Duration(hours: 5, minutes: 30));
  var timeFormat = DateFormat('HH:mm:ss');
  String formattedTime = timeFormat.format(istDate);

  return formattedTime;
}

String fetchBasicTimeInAMPM(DateTime date){

  DateTime istDate = date.add(Duration(hours: 5, minutes: 30));
  var timeFormat = DateFormat('hh:mm a');
  String formattedTime = timeFormat.format(istDate);

  return formattedTime;
}

String fetchBasicDateFormat(DateTime date){
  DateTime istDate = date.add(Duration(hours: 5, minutes: 30));
  var timeFormat = DateFormat('dd-MM-yyyy');
  String formattedTime = timeFormat.format(istDate);

  return formattedTime;
}

// void getLocation() async {
//   Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
//   print(position.latitude);
//   print(position.longitude);
//   currentLatitude = position.latitude;
//   currentLongitude = position.longitude;
// }

// Future getImage(ImageSource source) async {
//   try {
//     final image = await ImagePicker().pickImage(source: source);
//     if (image == null) return;
//     final imageTemporary = File(image.path);
//     return imageTemporary;
//   } on PlatformException catch (e) {
//     debugPrint('Failed to pick image: $e');
//   }
// }

// Future<List<File>>  clickImage() async {
//   List<File> images = [];
//
//   try{
//
//     var files = await FilePicker.platform.pickFiles(
//         type: FileType.image,
//         allowMultiple: true
//     );
//
//     if(files!=null && files.files.isNotEmpty){
//       for(int i=0; i< files.files.length; i++){
//
//         images.add(File(files.files[i].path!));
//       }
//     }
//   } catch(e){
//     print(e.toString());
//   }
//
//   return images;
// }

String convertToINR(int money){

  var _formattedNumber = NumberFormat.compactCurrency(
    decimalDigits: 0,
    locale: 'en_IN',
    symbol: '₹',
  ).format(money);

  return _formattedNumber;
}

String getFinantialYear(int yearKey){

  String lastFY = '22-23';
  String currentFY = '23-24';

  return yearKey==1 ? currentFY : lastFY;
}

//Get date in 20 Jul, 2023 format
String getDateUniversalFormat(DateTime date){

  String formattedDate = DateFormat('d, MMM, yyy').format(date);

  return formattedDate;
}

void dataSync(BuildContext context, VoidCallback onSuccess)async{

  AttendanceServices attendanceServices = AttendanceServices();
  bool allowClosing = false;
  SavedLocationSP.clearSavedVisitLocationsKey();
  // SavedLocationSP.clearLastCheckInData();

  showDialog(
      context: context,
      builder: (BuildContext con){
        return DataSyncLoader(onSuccessCallBack: (){
          onSuccess.call();
        },);
      });

  // await attendanceServices.updateEmployeeData(context: context, onSuccess: () async {
  //   print('emp data updated');
  //   await attendanceServices.fetchDealerData(context: context, onSuccess: () async {
  //     print('dealer data fetched');
  //     await attendanceServices.fetchDistributorData(context: context, onSuccess: () async{
  //       print('distributor data fetched');
  //       await attendanceServices.fetchEngineerData(context: context, onSuccess: (){
  //         print('engineer data fetched');
  //         onSuccess.call();
  //       });
  //     });
  //   });
  // });
}

double calculateDistance(double lat1, double lon1, double lat2, double lon2){
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 - c((lat2 - lat1) * p)/2 +
      c(lat1 * p) * c(lat2 * p) *
          (1 - c((lon2 - lon1) * p))/2;
  return 12742 * asin(sqrt(a))* 1000;
}

String getEmployeeName(BuildContext context){

  Employee emp =
      Provider.of<EmployeeProvider>(context, listen: false).employee;

  return emp.emp_name;
}

double getTotalPoints(BuildContext context){

  double total_points = 0;
  final SSMLLoyaltyProvider ssmlLoyaltyProvider = Provider.of<SSMLLoyaltyProvider>(context, listen: false);

  total_points = ssmlLoyaltyProvider.loyaltyPointsModel.total_pending.toDouble();

  return total_points;
}

saveVisitLocation(String key, value) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(key, json.encode(value));
}

ImageProvider<Object> getProfilePic(BuildContext context){

  ImageProvider<Object> backgroundImageProvider = AssetImage(AssetsConstants.no_profile_pic);
  Employee emp = Provider.of<EmployeeProvider>(context, listen: false).employee;

    String userProfilePic = emp.profile_pic;

    if (userProfilePic != '') {
      return
      backgroundImageProvider = NetworkImage(userProfilePic);
    }
    return backgroundImageProvider;
  }

String getDesignation(BuildContext context){
  Employee emp = Provider.of<EmployeeProvider>(context, listen: false).employee;
  String designation = 'NA';

  if(emp.profile_id==59){
    designation = 'State Head';
  } else if(emp.profile_id==2){
    designation = 'RSM';
  } else if(emp.profile_id==3){
    designation = 'ASM';
  } else if(emp.profile_id==5){
    designation = 'SO';
  } else if(emp.profile_id==28){
    designation = 'Sr. SO';
  } else if(emp.profile_id==7){
    designation = 'ME';
  } else if(emp.profile_id==23){
    designation = 'Sr. ME';
  } else if(emp.profile_id==65){
    designation = 'ATM';
  }
  return designation;
}

Future<String> getAppInfo()async{
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  print('fetching appversion');

  String appName = packageInfo.appName;
  String packageName = packageInfo.packageName;
  String version = packageInfo.version;
  String buildNumber = packageInfo.buildNumber;

  return version;
}