import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:retail_app_flutter/models/action_plan_questions.dart';
import 'package:retail_app_flutter/models/dealer_master.dart';
import 'package:retail_app_flutter/models/discussion_question_model.dart';
import 'package:retail_app_flutter/models/visit_question_model.dart';
import 'package:retail_app_flutter/providers/dealer_master_provider.dart';
import 'package:retail_app_flutter/providers/visit_questions_provider.dart';
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

  void fetchVisitQuestion({
    required BuildContext context,
    required String account_obj_id,
    required VoidCallback onSuccess
})async{

    try{

      final Employee emp = Provider.of<EmployeeProvider>(context, listen: false).employee;

      Map data = {
        'account_obj_id': account_obj_id,
      };

      String jsonBody = jsonEncode(data);
      var visit_question_provider = Provider.of<VisitQuestionsProvider>(context, listen: false);


      http.Response res = await http.post(
          Uri.parse('$uri/v1/api/fetch-visit-questions'),
          body: jsonBody,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': emp.jwt_token
          });

      HttpErroHandeling(
          response: res,
          context: context,
          onSuccess: (){

            Map<String, dynamic> parsedJson = jsonDecode(res.body);
            bool showBusinessSurvey = parsedJson['show_business_survey'] as bool;
            bool showDealerCounterPotential = parsedJson['show_dealer_counter_potential'] as bool;
            bool showGiftHadOver = parsedJson['show_gift_hand_over'] as bool;
            bool showSubDealerCount = parsedJson['show_sub_dealer_count'] as bool;
            List<String> purposeOfVisit = List<String>.from(
              (parsedJson['purpose_of_visit'] as List)
                  .map((url) => url.toString()),
            );

            List<DiscussionQuestionModel> discussionQuestions = List<DiscussionQuestionModel>.from(
                parsedJson['discussions']?.map((x) => DiscussionQuestionModel.fromMap(x)));
            List<ActionPlanQuestionModel> actionPlanQuestions = List<ActionPlanQuestionModel>.from(
                parsedJson['action_plan']?.map((x) => ActionPlanQuestionModel.fromMap(x)));


            visit_question_provider.visitQuestionsModel.action_plan_questions = [];
            visit_question_provider.visitQuestionsModel.discussion_questions = [];
            visit_question_provider.visitQuestionsModel.purpose_of_visit = [];
            visit_question_provider.visitQuestionsModel.show_business_survey = false;
            visit_question_provider.visitQuestionsModel.show_dealer_counter_potential = false;
            visit_question_provider.visitQuestionsModel.show_gift_hand_over = false;
            visit_question_provider.visitQuestionsModel.show_sub_dealer_count = false;


            visit_question_provider.setVisitQuestion(res.body);

            onSuccess.call();
          }
      );

    } catch (e) {
      showSnackBar(context, e.toString());
      print(e.toString());
    }
  }

  Future<void> submitVisitRemarks({
    required BuildContext context,
    required String accountObjectId,
    required DateTime checkIn,
    required DateTime checkOut,
    required String purposeOfVisit,
    required bool hasHandedOverGift,
    required XFile? image,
    required int counterPotential,
    required int subDealerCount,
    required String businessSurvey,
    required String discussionDetails,
    required String actionPlanDetails,
    required String issueDetails,
    required String followUpPerson,
    required double rating,
    required VoidCallback onSuccess
  })async {

    try{
      print('hello');

      final Employee emp = Provider.of<EmployeeProvider>(context, listen: false).employee;
      DealerMasterProvider dealerMasterProvider = Provider.of<DealerMasterProvider>(context, listen: false);
      final cloudinary = CloudinaryPublic('dhfiapa0x', 'giscyuqg');
      String imageUrl = '';

      CloudinaryResponse resCloudinary = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(image!.path, folder: 'Account Visit Remarks'));

      imageUrl = resCloudinary.secureUrl;
      print(imageUrl);

      Map data = {
        "account_obj_id": accountObjectId,
        "check_in_time": checkIn.toIso8601String(),
        "check_out_time": checkOut.toIso8601String(),
        "visit_call": 1,
        "selfie_image": imageUrl,
        "purpose_of_visit": purposeOfVisit,
        "gift_handed_over": hasHandedOverGift,
        "submitted_counter_potential": counterPotential,
        "submitted_sub_dealer_count": subDealerCount,
        "submitted_business_survey": businessSurvey,
        "discussion_details": jsonEncode(discussionData).toString(),
        "action_plan_details": jsonEncode(actionPlanData).toString(),
        "issue_details": issueDetails,
        "follow_up_person": followUpPerson,
        "rating": rating
      };

      String jsonBody = jsonEncode(data);

      http.Response res = await http.post(
          Uri.parse('$uri/v1/api/submit-visit-remarks'),
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


            onSuccess();
          }
      );
    } catch (e) {
      showSnackBar(context, e.toString());
      print(e.toString());
    }
  }
}