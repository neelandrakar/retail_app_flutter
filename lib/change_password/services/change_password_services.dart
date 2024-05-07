import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../constants/global_variables.dart';
import '../../constants/http_error_handeling.dart';
import '../../constants/utils.dart';
import '../../models/employee.dart';
import '../../providers/user_provider.dart';

class ChangePasswordServices{

  Future<void> changePassword({
    required BuildContext context,
    required VoidCallback onSuccess,
    required String old_password,
    required String new_password
  }) async{

    try{
      final Employee emp = Provider
          .of<EmployeeProvider>(context, listen: false)
          .employee;

      Map data = {
        "old_password": old_password,
        "new_password": new_password
      };

      String jsonBody = jsonEncode(data);

      http.Response res = await http.post(
          Uri.parse('$uri/v1/api/change-password'),
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
            showSnackBar(context, jsonDecode(res.body)['msg']);

            onSuccess.call();
          }
      );

    }catch(e){
      print("Error $e");
      showSnackBar(context, e.toString());
    }

    // return allDashboardMenus;
  }
}