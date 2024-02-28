// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:camera/camera.dart';

class SubmittedVisitModel {
  final String account_obj_id;
  final DateTime check_in_time;
  final DateTime check_out_time;
  final String purpose_of_visit;
  final bool has_handed_over_gift;
  final XFile? visit_image;
  final int counter_potential;
  final int sub_dealer_count;
  final String business_survey;
  final String discussion_details;
  final String action_plan_details;
  final String issue_details;
  final String follow_up_person;
  final double rating;
  final bool? is_sent;
  SubmittedVisitModel({
    required this.account_obj_id,
    required this.check_in_time,
    required this.check_out_time,
    required this.purpose_of_visit,
    required this.has_handed_over_gift,
    required this.visit_image,
    required this.counter_potential,
    required this.sub_dealer_count,
    required this.business_survey,
    required this.discussion_details,
    required this.action_plan_details,
    required this.issue_details,
    required this.follow_up_person,
    required this.rating,
    this.is_sent
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'account_obj_id': account_obj_id,
      'check_in_time': check_in_time.millisecondsSinceEpoch,
      'check_out_time': check_out_time.millisecondsSinceEpoch,
      'purpose_of_visit': purpose_of_visit,
      'has_handed_over_gift': has_handed_over_gift,
      'visit_image': visit_image?.path,
      'counter_potential': counter_potential,
      'sub_dealer_count': sub_dealer_count,
      'business_survey': business_survey,
      'discussion_details': discussion_details,
      'action_plan_details': action_plan_details,
      'issue_details': issue_details,
      'follow_up_person': follow_up_person,
      'rating': rating,
      'is_sent': is_sent
    };
  }

  factory SubmittedVisitModel.fromMap(Map<String, dynamic> map) {
    return SubmittedVisitModel(
      account_obj_id: map['account_obj_id'] as String,
      check_in_time:
          DateTime.fromMillisecondsSinceEpoch(map['check_in_time'] as int),
      check_out_time:
          DateTime.fromMillisecondsSinceEpoch(map['check_out_time'] as int),
      purpose_of_visit: map['purpose_of_visit'] as String,
      has_handed_over_gift: map['has_handed_over_gift'] as bool,
      visit_image: XFile(map['visit_image'] as String), // Change this line
      counter_potential: map['counter_potential'] as int,
      sub_dealer_count: map['sub_dealer_count'] as int,
      business_survey: map['business_survey'] as String,
      discussion_details: map['discussion_details'] as String,
      action_plan_details: map['action_plan_details'] as String,
      issue_details: map['issue_details'] as String,
      follow_up_person: map['follow_up_person'] as String,
      rating: map['rating'] as double,
      is_sent: false,
    );
  }

  String toJson() => json.encode(toMap());

  factory SubmittedVisitModel.fromJson(String source) =>
      SubmittedVisitModel.fromMap(json.decode(source));
}
