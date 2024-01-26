import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../constants/global_variables.dart';
import '../../constants/http_error_handeling.dart';
import '../../constants/utils.dart';
import '../../models/employee.dart';
import '../../providers/user_provider.dart';

class AccountServices{

  Future<List<Map<String,dynamic>>> fetchBlocks({

    required BuildContext context,
    required int district_id,
    required VoidCallback onSuccess,
})async {

    List<Map<String, dynamic>> fetchedBlocks = [];

    try{

      final Employee emp = Provider.of<EmployeeProvider>(context, listen: false).employee;
      Map data = {
        'district_id': district_id,
      };

      String jsonBody = jsonEncode(data);

      http.Response res = await http.post(
          Uri.parse('$uri/v1/api/fetch-blocks'),
          body: jsonBody,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': emp.jwt_token
          });

      HttpErroHandeling(
          response: res,
          context: context,
          onSuccess: () {

            fetchedBlocks = [];
            for (int i = 0; i < jsonDecode(res.body).length; i++) {

              fetchedBlocks.add(jsonDecode(res.body)[i]);
            }

            print(fetchedBlocks.length);

            onSuccess.call();
          }
      );



    }catch(e){
      print(e.toString());
      showSnackBar(context, e.toString());
    }
    return fetchedBlocks;
  }

}