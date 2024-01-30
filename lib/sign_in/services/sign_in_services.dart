import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:retail_app_flutter/attendance/screens/attendance_screen.dart';
import 'package:retail_app_flutter/constants/global_variables.dart';
import 'package:retail_app_flutter/constants/http_error_handeling.dart';
import 'package:retail_app_flutter/constants/utils.dart';
import 'package:retail_app_flutter/home/screens/home_screen.dart';
import 'package:retail_app_flutter/models/employee.dart';
import 'package:retail_app_flutter/providers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInServices{

  void signIn({

    required BuildContext context,
    required String username,
    required String password
}) async{

    try{

      Map data = {
        'username': username,
        'password': password
      };


      String jsonBody = jsonEncode(data);
      print(data);

      http.Response res = await http.post(Uri.parse('$uri/v1/api/signin'),
        body: jsonBody,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });

      HttpErroHandeling(
          response: res,
          context: context,
          onSuccess: () async {
            print(jsonEncode(jsonDecode(res.body)));

            Provider.of<EmployeeProvider>(context, listen: false).setUser(
                res.body);
            Employee emp = Provider
                .of<EmployeeProvider>(context, listen: false)
                .employee;

            final signInSP = await SharedPreferences.getInstance();
            await signInSP.setString(
                'x-auth-token', utf8.decode(res.bodyBytes));

            Navigator.pushNamed(context, AttendanceScreen.routeName);
          }
      );

    }catch(e){
      print("Error $e");
      showSnackBar(context, e.toString());
    }
  }

  Future<void> getUserData(
      BuildContext context
      ) async {

    try{

      final _signInSP = await SharedPreferences.getInstance();
      String? savedEmp = _signInSP.getString('x-auth-token');
      if (savedEmp != null) {
        var tokenRes = await http
            .post(Uri.parse('$uri/v1/api/checkToken'),

            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'x-auth-token': jsonDecode(savedEmp)['jwt_token']
            });

        bool alreadyLoggedIn = jsonDecode(tokenRes.body);
        if (alreadyLoggedIn) {
          Provider.of<EmployeeProvider>(context, listen: false).setUser(
              savedEmp);
          print(
              'Saved employee name: ${jsonDecode(savedEmp)['emp_name']}');

        }
      }

    }catch (e) {
      print(e);
      showSnackBar(context, e.toString());
    }

  }
}