import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:retail_app_flutter/constants/http_error_handeling.dart';
import 'package:retail_app_flutter/models/attendance_screen_model.dart';
import 'package:http/http.dart' as http;
import 'package:retail_app_flutter/models/dealer_master.dart';
import 'package:retail_app_flutter/models/distributor_master.dart';
import 'package:retail_app_flutter/models/engineer_master.dart';
import 'package:retail_app_flutter/providers/attendance_model_provider.dart';
import 'package:retail_app_flutter/providers/dealer_master_provider.dart';
import 'package:retail_app_flutter/providers/distributor_master_provider.dart';
import 'package:retail_app_flutter/providers/engineer_master_provider.dart';
import '../../constants/global_variables.dart';
import '../../constants/utils.dart';
import '../../models/employee.dart';
import '../../providers/user_provider.dart';

class AttendanceServices{

  void fetchAttendanceData({
    required BuildContext context,
    required VoidCallback setState


  }) async {

    try {
      final Employee emp = Provider
          .of<EmployeeProvider>(context, listen: false)
          .employee;

      http.Response res = await http.get(
          Uri.parse('$uri/v1/api/get-attendance'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': emp.jwt_token
          });

      HttpErroHandeling(
          response: res,
          context: context,
          onSuccess: () {
            print(res.body);
            Provider.of<AttendanceModelProvider>(context, listen: false)
                .setAttendance(res.body);
            setState.call();
          }
      );
    }catch(e){
      print("Error $e");
      showSnackBar(context, e.toString());
    }
  }

  Future<void> login({
    required BuildContext context,
    required VoidCallback onSuccess
})async{

    try {
      Map data = {
        "login_location": "HFJJ+8M New Town, West Bengal, India",
        "login_latitude": 22.5808863,
        "login_longitude": 88.4817728
      };
      String jsonBody = jsonEncode(data);
      final Employee emp = Provider
          .of<EmployeeProvider>(context, listen: false)
          .employee;
      var attendanceModelProvider = Provider.of<AttendanceModelProvider>(context, listen: false);

      http.Response res = await http.post(
          Uri.parse('$uri/v1/api/submit-login-data'),
          body: jsonBody,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': emp.jwt_token
          });

      HttpErroHandeling(
          response: res,
          context: context,
          onSuccess: () {
            print(res.body);
            String date = (jsonDecode(res.body)['date']);
            attendanceModelProvider.addNewLoginDate(date);
            onSuccess.call();
          }
      );
    }catch(e){
      print("Error $e");
      showSnackBar(context, e.toString());
    }

  }

  Future<void> logout({
    required BuildContext context,
    required VoidCallback onSuccess
  })async{

    try {
      Map data = {
        "logout_location": "HFJJ+8M New Town, West Bengal, India",
        "logout_latitude": 22.5808863,
        "logout_longitude": 88.4817728,
        "endKM": 420,
        "endOdometer": "https://c.ndtvimg.com/2021-10/nn6emufo_ms-dhoni-ipl_650x400_07_October_21.jpg?im=FeatureCrop,algorithm=dnn,width=806,height=605"
      };
      String jsonBody = jsonEncode(data);
      final Employee emp = Provider
          .of<EmployeeProvider>(context, listen: false)
          .employee;
      var attendanceModelProvider = Provider.of<AttendanceModelProvider>(context, listen: false);

      http.Response res = await http.post(
          Uri.parse('$uri/v1/api/submit-logout-data'),
          body: jsonBody,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': emp.jwt_token
          });

      HttpErroHandeling(
          response: res,
          context: context,
          onSuccess: () {
            print(res.body);
            // attendanceModelProvider.addNewLoginDate(date);
            onSuccess.call();
          }
      );
    }catch(e){
      print("Error $e");
      showSnackBar(context, e.toString());
    }

  }

  Future<void> submitLoginOdometer({
    required BuildContext context,
    required VoidCallback onSuccess,
    required int vehicleType,
    required int startKM,
    required String startOdometer
  })async{

    try {
      Map data = {

        "vehicle": vehicleType,
        "startKM": startKM,
        "startOdometer": startOdometer
      };
      String jsonBody = jsonEncode(data);
      final Employee emp = Provider
          .of<EmployeeProvider>(context, listen: false)
          .employee;
      var attendanceModelProvider = Provider.of<AttendanceModelProvider>(context, listen: false);

      http.Response res = await http.post(
          Uri.parse('$uri/v1/api/submit-login-odometer-data'),
          body: jsonBody,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': emp.jwt_token
          });

      HttpErroHandeling(
          response: res,
          context: context,
          onSuccess: () {
            print(res.body);
            // attendanceModelProvider.addNewLoginDate(date);
            onSuccess.call();
          }
      );
    }catch(e){
      print("Error $e");
      showSnackBar(context, e.toString());
    }
  }

  Future<void> fetchDealerData({
    required BuildContext context,
    required VoidCallback onSuccess,
  })async{

    try {

      final Employee emp = Provider
          .of<EmployeeProvider>(context, listen: false)
          .employee;
      var dealer_master_provider = Provider.of<DealerMasterProvider>(context, listen: false);
      Map data = {
        'account_type_id': 1,
      };

      String jsonBody = jsonEncode(data);


      http.Response res = await http.post(
          Uri.parse('$uri/v1/api/fetch-tagged-accounts'),
          body: jsonBody,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': emp.jwt_token
          });

      HttpErroHandeling(
          response: res,
          context: context,
          onSuccess: () {
            // print('#debug===> '+jsonDecode(res.body)[1]['account_name']);

            dealer_master_provider.dealer_master = [];

            for (int i = 0; i < jsonDecode(res.body).length; i++) {

              dealer_master_provider.fetchFullList(DealerMaster.fromJson(jsonEncode(jsonDecode(res.body)[i])));
            }
            onSuccess.call();
          }
      );
    }catch(e){
      print("Error $e");
      showSnackBar(context, e.toString());
    }
  }

  Future<void> fetchDistributorData({
    required BuildContext context,
    required VoidCallback onSuccess,
  })async{

    try {

      final Employee emp = Provider
          .of<EmployeeProvider>(context, listen: false)
          .employee;
      var distributor_master_provider = Provider.of<DistributorMasterProvider>(context, listen: false);
      Map data = {
        'account_type_id': 7,
      };

      String jsonBody = jsonEncode(data);


      http.Response res = await http.post(
          Uri.parse('$uri/v1/api/fetch-tagged-accounts'),
          body: jsonBody,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': emp.jwt_token
          });

      HttpErroHandeling(
          response: res,
          context: context,
          onSuccess: () {
            // print('#debug===> '+jsonDecode(res.body)[0]['account_name']);

            distributor_master_provider.distributor_master = [];

            for (int i = 0; i < jsonDecode(res.body).length; i++) {

              distributor_master_provider.fetchFullList(DistributorMaster.fromJson(jsonEncode(jsonDecode(res.body)[i])));
            }
            onSuccess.call();
          }
      );
    }catch(e){
      print("Error $e");
      showSnackBar(context, e.toString());
    }
  }

  Future<void> fetchEngineerData({
    required BuildContext context,
    required VoidCallback onSuccess,
  })async{

    try {

      final Employee emp = Provider
          .of<EmployeeProvider>(context, listen: false)
          .employee;
      var engineer_master_provider = Provider.of<EngineerMasterProvider>(context, listen: false);
      Map data = {
        'account_type_id': 6,
      };

      String jsonBody = jsonEncode(data);


      http.Response res = await http.post(
          Uri.parse('$uri/v1/api/fetch-tagged-accounts'),
          body: jsonBody,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': emp.jwt_token
          });

      HttpErroHandeling(
          response: res,
          context: context,
          onSuccess: () {
            // print('#debug===> '+jsonDecode(res.body)[0]['account_name']);

            engineer_master_provider.engineer_master = [];

            for (int i = 0; i < jsonDecode(res.body).length; i++) {

              engineer_master_provider.fetchFullList(EngineerMaster.fromJson(jsonEncode(jsonDecode(res.body)[i])));
            }
            onSuccess.call();
          }
      );
    }catch(e){
      print("Error $e");
      showSnackBar(context, e.toString());
    }
  }

  Future<void> updateEmployeeData({
    required BuildContext context,
    required VoidCallback onSuccess,
  })async{

    try {

      final Employee emp = Provider
          .of<EmployeeProvider>(context, listen: false)
          .employee;
      var employee_provider = Provider.of<EmployeeProvider>(context, listen: false);


      http.Response res = await http.get(
          Uri.parse('$uri/v1/api/update-emp-data'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': emp.jwt_token
          });

      HttpErroHandeling(
          response: res,
          context: context,
          onSuccess: () {

            employee_provider.setUser(res.body);
            onSuccess.call();
          }
      );
    }catch(e){
      print("Error $e");
      showSnackBar(context, e.toString());
    }
  }
}