import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:retail_app_flutter/models/dashboard_menu.dart';
import 'package:retail_app_flutter/providers/dashboard_menu_provider.dart';

import '../../constants/global_variables.dart';
import '../../constants/http_error_handeling.dart';
import '../../constants/utils.dart';
import '../../models/employee.dart';
import '../../providers/attendance_model_provider.dart';
import '../../providers/user_provider.dart';

class HomeServices{

  Future<void> fetchDashboardMenus({
    required BuildContext context,
    required VoidCallback onSuccess
}) async{

   try{
     final Employee emp = Provider
         .of<EmployeeProvider>(context, listen: false)
         .employee;
     var allDashboardMenuProvider = Provider.of<DashboardMenuProvider>(context, listen: false);

     http.Response res = await http.get(
         Uri.parse('$uri/v1/api/fetch-dashboard-menus'),
         headers: <String, String>{
           'Content-Type': 'application/json; charset=UTF-8',
           'x-auth-token': emp.jwt_token
         });

     HttpErroHandeling(
         response: res,
         context: context,
         onSuccess: () {
           print(res.body);
           if(allDashboardMenuProvider.dashboardMenus.length<jsonDecode(res.body).length){

             for (int i = 0; i < jsonDecode(res.body).length; i++) {
             
               allDashboardMenuProvider.addDashboardMenu(DashboardMenu.fromJson(jsonEncode(jsonDecode(res.body)[i])));
             }

           }
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