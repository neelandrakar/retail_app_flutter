import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:retail_app_flutter/models/loyalty_tier.dart';
import 'package:retail_app_flutter/providers/ssml_loyalty_provider.dart';
import '../../constants/global_variables.dart';
import '../../constants/http_error_handeling.dart';
import '../../constants/utils.dart';
import '../../models/employee.dart';
import '../../providers/user_provider.dart';

class SSMLLoyaltyServices{

  Future<void> getEmpSlab({
    required BuildContext context,
    required int slab_type,
    required VoidCallback onSuccess
}) async {
    try{

      final Employee emp = Provider.of<EmployeeProvider>(context, listen: false).employee;
      var ssml_loyalty_provider = Provider.of<SSMLLoyaltyProvider>(context, listen: false);

      Map data = {
        "slab_type": slab_type
      };

      String jsonBody = jsonEncode(data);

      http.Response res = await http.post(
          Uri.parse('$uri/v1/api/get-emp-slab'),
          body: jsonBody,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': emp.jwt_token
          });

      HttpErroHandeling(
          response: res,
          context: context,
          onSuccess: () {

            ssml_loyalty_provider.getPointsData(res.body, context);

            print('xxxxxxxx: ${ssml_loyalty_provider.loyaltyPointsModel.invoice_wise_points!.length}');
            print(res.body);

            onSuccess.call();

          }
      );


    }catch(e){
      print(e.toString());
      showSnackBar(context, e.toString());
    }
  }
}