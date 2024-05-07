import 'package:flutter/foundation.dart';
import 'package:retail_app_flutter/models/attendance_screen_model.dart';

class AttendanceModelProvider extends ChangeNotifier{

  AttendanceScreenModel attendanceScreenModel = AttendanceScreenModel(
      cycle_start_date: '',
      cycle_end_date: '',
      current_date: DateTime.now(),
      hasLoggedInToday: false,
      get_attendance: [],

  );

  AttendanceScreenModel get attendanceModel => attendanceScreenModel;

  void setAttendance(String attendance){
    attendanceScreenModel = AttendanceScreenModel.fromJson(attendance);
    notifyListeners();
  }

  void addNewLoginDate(String newLoginDate){
    var attLength = attendanceScreenModel.get_attendance.length;
    attendanceScreenModel.get_attendance[attLength-1].login_status = 1;
    // attendanceScreenModel.date.add(newLoginDate);
    notifyListeners();
  }

}