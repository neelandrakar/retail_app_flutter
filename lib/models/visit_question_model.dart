// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'action_plan_questions.dart';
import 'discussion_question_model.dart';

class VisitQuestionModel {
  bool show_business_survey;
  bool show_dealer_counter_potential;
  bool show_sub_dealer_count;
  List<String> purpose_of_visit;
  bool show_gift_hand_over;
  List<DiscussionQuestionModel> discussion_questions;
  List<ActionPlanQuestionModel> action_plan_questions;

  VisitQuestionModel(
      {
      required this.show_business_survey,
      required this.show_dealer_counter_potential,
      required this.show_sub_dealer_count,
      required this.purpose_of_visit,
      required this.show_gift_hand_over,
      required this.discussion_questions,
      required this.action_plan_questions
      });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'show_business_survey': show_business_survey,
      'show_dealer_counter_potential': show_dealer_counter_potential,
      'show_sub_dealer_count': show_sub_dealer_count,
      'purpose_of_visit': purpose_of_visit,
      'show_gift_hand_over': show_gift_hand_over,
      'discussion_questions': discussion_questions.map((x) => x.toMap()).toList(),
      'action_plan_questions': action_plan_questions.map((x) => x.toMap()).toList(),
    };
  }

  factory VisitQuestionModel.fromMap(Map<String, dynamic> map) {
    return VisitQuestionModel(
      show_business_survey:  map['show_business_survey'] as bool,
      show_dealer_counter_potential: map['show_dealer_counter_potential'] as bool,
      show_sub_dealer_count: map['show_sub_dealer_count'] as bool,
      show_gift_hand_over: map['show_gift_hand_over'] as bool,
      purpose_of_visit: List<String>.from((map['purpose_of_visit'] as List).map((url) => url.toString())),
      discussion_questions: List<DiscussionQuestionModel>.from(
          map['discussions']?.map((x) => DiscussionQuestionModel.fromMap(x))),
      action_plan_questions: List<ActionPlanQuestionModel>.from(
          map['action_plan']?.map((x) => ActionPlanQuestionModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory VisitQuestionModel.fromJson(String source) => VisitQuestionModel.fromMap(json.decode(source));
}
