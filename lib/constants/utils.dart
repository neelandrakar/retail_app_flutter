import 'dart:io';

// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:retail_app_flutter/constants/global_variables.dart';

void showSnackBar(BuildContext context,String text){
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
          Text(text,
            style: TextStyle(
                fontFamily: 'Poppins'
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