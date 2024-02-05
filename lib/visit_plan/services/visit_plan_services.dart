import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:retail_app_flutter/models/dealer_master.dart';
import 'package:retail_app_flutter/providers/dealer_master_provider.dart';
import '../../constants/global_variables.dart';
import '../../constants/http_error_handeling.dart';
import '../../constants/utils.dart';
import '../../models/employee.dart';
import '../../providers/user_provider.dart';

class VisitPlanServices{

  Future<void> setAccountLocation({
    required BuildContext context,
    required String account_obj_id,
    required double new_lat,
    required double new_lon,
    required int address_type,
    required XFile? image,
    required void Function(DealerMaster) onSuccess
})async {

    try{
      print('hello');

      final Employee emp = Provider.of<EmployeeProvider>(context, listen: false).employee;
      DealerMasterProvider dealerMasterProvider = Provider.of<DealerMasterProvider>(context, listen: false);
      final cloudinary = CloudinaryPublic('dhfiapa0x', 'giscyuqg');
      String imageUrl = '';

        CloudinaryResponse resCloudinary = await cloudinary.uploadFile(
            CloudinaryFile.fromFile(image!.path, folder: 'Account Counter Image'));

      imageUrl = resCloudinary.secureUrl;
      print(imageUrl);

      Map data = {
          'account_obj_id': account_obj_id,
          'new_lat': new_lat,
          'new_lon': new_lon,
          'address_type': address_type,
          'location_image': imageUrl
        };

      String jsonBody = jsonEncode(data);

      http.Response res = await http.post(
          Uri.parse('$uri/v1/api/account-location-update'),
          body: jsonBody,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': emp.jwt_token
          });

      HttpErroHandeling(
          response: res,
          context: context,
          onSuccess: () {

            int acc_type_id = jsonDecode(res.body)['account_type_id'];
            // double home_lat = jsonDecode(res.body)['latitude'];
            // double home_lon = jsonDecode(res.body)['longitude'];
            // String home_img = jsonDecode(res.body)['home_location_img'];
            // double office_lat = jsonDecode(res.body)['office_latitude'];
            // double office_lon = jsonDecode(res.body)['office_longitude'];
            // String office_img = jsonDecode(res.body)['office_location_img'];

            print('x');
            DealerMaster dealer = DealerMaster.fromJson(res.body);
            print('y');

            if(acc_type_id==1){
              print('hola');
              dealerMasterProvider.updateSingleDealer(dealer);
            }
            onSuccess(dealer);
          }
      );
    } catch (e) {
      showSnackBar(context, e.toString());
      print(e.toString());
    }

  }
}