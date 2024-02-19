import 'package:flutter/cupertino.dart';
import 'package:retail_app_flutter/models/action_plan_questions.dart';
import 'package:retail_app_flutter/models/discussion_question_model.dart';
import 'package:retail_app_flutter/models/visit_question_model.dart';

class VisitQuestionsProvider extends ChangeNotifier{

  VisitQuestionModel visitQuestionsModel = VisitQuestionModel(
      show_business_survey: false,
      show_dealer_counter_potential: false,
      show_sub_dealer_count: false,
      purpose_of_visit: [],
      follow_up_persons: [],
      show_gift_hand_over: false,
      discussion_questions: [],
      action_plan_questions: [],
  );


  void setVisitQuestion(String visitQuestionSet){
    visitQuestionsModel = VisitQuestionModel.fromJson(visitQuestionSet);
    notifyListeners();
  }
}