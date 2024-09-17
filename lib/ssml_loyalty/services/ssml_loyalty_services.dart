import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:retail_app_flutter/models/gift_category_model.dart';
import 'package:retail_app_flutter/models/loyalty_points_model.dart';
import 'package:retail_app_flutter/models/loyalty_tier.dart';
import 'package:retail_app_flutter/providers/gift_category_provider.dart';
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
            loyaltyPointsModel = LoyaltyPointsModel.fromJson(res.body);
            print(res.body);

            onSuccess.call();

          }
      );


    }catch(e){
      print(e.toString());
      showSnackBar(context, e.toString());
    }
  }

  Future<void> getMerchantsData({
    required BuildContext context,
    required VoidCallback onSuccess
  }) async {

    try{

      final Employee emp = Provider.of<EmployeeProvider>(context, listen: false).employee;
      var gift_category_provider = Provider.of<GiftCategoryProvider>(context, listen: false);

      http.Response res = await http.post(
          Uri.parse('$uri/v1/api/show-merchants'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': emp.jwt_token
          });

      HttpErroHandeling(
          response: res,
          context: context,
          onSuccess: () {

            // print("RES: ${jsonDecode(res.body)['message']}");
            print("RES: ${jsonDecode(res.body)['message'].length}");

            int gift_category_length = jsonDecode(res.body)['message'].length;
            var messageArray = jsonDecode(res.body)['message'];
            gift_category_provider.gift_categories = [];

            for (var message in messageArray) {
              gift_category_provider.getGiftCategoryData(GiftCategoryModel.fromJson(jsonEncode(message)), context);
            }
            onSuccess.call();

          }
      );



    }catch(e){
      print(e.toString());
      showSnackBar(context, e.toString());
    }

  }

  Future<void> redeemACoupon({
    required BuildContext context,
    required VoidCallback onSuccess,
    required String coupon_id,
  }) async {
    try {
      final Employee emp = Provider.of<EmployeeProvider>(context, listen: false).employee;
      var gift_category_provider = Provider.of<GiftCategoryProvider>(context, listen: false);
      Map<String, dynamic> resData = {};

      Map data = {
        'coupon_id': coupon_id,
      };

      String jsonBody = jsonEncode(data);

      http.Response res = await http.post(
        Uri.parse('$uri/v1/api/redeem-a-coupon'),
        body: jsonBody,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': emp.jwt_token
        },
      );

      HttpErroHandeling(
        response: res,
        context: context,
        onSuccess: () {
          resData = jsonDecode(res.body);
          String ss = resData["message"][0]["header_text"];
          print(ss);

          if(resData["status"]==1){
            gift_redemption_header_text = resData["message"][0]["header_text"];
            gift_redemption_msg = resData["message"][1]["msg"];
          } else if(resData["status"]==2){
            gift_redemption_header_text = resData["message"][0]["header_text"];
          }
          onSuccess.call();
        },
      );


    } catch (e) {
      print(e.toString());
      showSnackBar(context, e.toString());
    }
  }
}