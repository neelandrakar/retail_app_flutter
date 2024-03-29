import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retail_app_flutter/constants/global_variables.dart';
import 'package:retail_app_flutter/constants/my_colors.dart';
import 'package:retail_app_flutter/models/visit_question_model.dart';
import 'package:retail_app_flutter/providers/visit_questions_provider.dart';
import 'package:retail_app_flutter/visit_plan/widgets/question_ans_ui.dart';
import 'package:retail_app_flutter/visit_plan/widgets/visit_question_list_box.dart';
import '../../constants/custom_elevated_button.dart';
import '../../constants/my_fonts.dart';

class DiscussionActionPlanDialogue extends StatefulWidget {
  final String boxName;
  final VoidCallback onSuccess;
  const DiscussionActionPlanDialogue({Key? key, required this.boxName, required this.onSuccess}) : super(key: key);

  @override
  State<DiscussionActionPlanDialogue> createState() => _DiscussionActionPlanDialogueState();
}

class _DiscussionActionPlanDialogueState extends State<DiscussionActionPlanDialogue> {
  int boxType = 0;
  late VisitQuestionModel visit_questions;
  bool is_questions = true;
  String ans_a_question = 'NA';
  int ans_type = 0;
  int question_index = 0;
  String ans = 'NA';
  bool canPop = false;

  @override
  void initState() {
    super.initState();
    if(widget.boxName == 'Discussed On') {
      boxType = 1;
    } else if(widget.boxName == 'Action Plan') {
      boxType = 2;
    }
    visit_questions = Provider.of<VisitQuestionsProvider>(context, listen: false).visitQuestionsModel;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(

      canPop: false,

      child: Dialog(
        child: Container(
          width: double.infinity,
          height: 300,
          decoration: BoxDecoration(
              color: MyColors.boneWhite,
              borderRadius: BorderRadius.circular(10)
          ),
          padding: EdgeInsets.all(20),
          child: is_questions ? Column(
            children: [
              Text(
                '${widget.boxName} Details',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: MyColors.appBarColor,
                    fontSize: 16,
                    fontFamily: MyFonts.poppins,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                'You need to submit all * marked questions',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: MyColors.fadedBlack,
                    fontSize: 12,
                    fontFamily: MyFonts.poppins,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 10),
              Expanded(
                child: boxType == 1 ? ListView.separated(
                  itemCount: visit_questions.discussion_questions.length,
                  itemBuilder: (context, index){
                    return VisitQuestionListBox(
                      question_name: visit_questions.discussion_questions[index].question,
                      ans_status: visit_questions.discussion_questions[index].answer_status,
                      is_mandatory: visit_questions.discussion_questions[index].is_mandatory,
                      onClick: (){
                        print(visit_questions.discussion_questions[index].answer_status);
                        setState(() {
                          is_questions = false;
                          question_index = index;
                          ans_a_question = visit_questions.discussion_questions[index].question;
                          ans_type = visit_questions.discussion_questions[index].answer_type;
                        });
                      },
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(height: 5);
                  },
                ) : ListView.separated(
                  itemCount: visit_questions.action_plan_questions.length,
                  itemBuilder: (context, index){
                    return VisitQuestionListBox(
                      question_name: visit_questions.action_plan_questions[index].question,
                      ans_status: visit_questions.action_plan_questions[index].answer_status,
                      is_mandatory: visit_questions.action_plan_questions[index].is_mandatory,
                      onClick: (){
                        print(visit_questions.action_plan_questions[index].question);
                        setState(() {
                          is_questions = false;
                          question_index = index;
                          ans_a_question = visit_questions.action_plan_questions[index].question;
                          ans_type = visit_questions.action_plan_questions[index].answer_type;
                        });
                      },
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(height: 5);
                  },
                ),
              ),
              SizedBox(height: 18),
              CustomElevatedButton(
                buttonText: 'Close & Save',
                buttonIcon: Icons.save,
                buttonColor: MyColors.appBarColor,
                buttonTextColor: Colors.white,
                buttonIconColor: MyColors.greenColor,
                width: 100,
                height: 35,
                iconSize: 15,
                textSize: 10,
                onClick: () {
                    canPop = true;
                    if(boxType==1){
                    for(int i=0; i<visit_questions.discussion_questions.length; i++){
                      var singleQuestion = visit_questions.discussion_questions[i];
                      if(singleQuestion.is_mandatory==1 && singleQuestion.answer_status=='Add'){
                        canPop = false;
                      }
                    }
                    if(canPop){
                      discussion_submitted = true;
                      discussionData = {};
                      for(int i=0; i<visit_questions.discussion_questions.length; i++) {
                        if (visit_questions.discussion_questions[i]
                            .answer_status != 'Add') {
                          discussionData[visit_questions.discussion_questions[i].question] =
                              visit_questions.discussion_questions[i].answer_status;
                        } else {
                          discussionData[visit_questions.discussion_questions[i]
                              .question] = 'NA';
                        }
                      }
                      print(jsonEncode(discussionData));
                    }
                    } else if(boxType==2){
                      for(int i=0; i<visit_questions.action_plan_questions.length; i++){
                        var singleQuestion = visit_questions.action_plan_questions[i];
                        if(singleQuestion.is_mandatory==1 && singleQuestion.answer_status=='Add'){
                          canPop = false;
                        }
                      }
                      if(canPop){
                        actionPlanData = {};
                        action_plan_submitted = true;
                        for(int i=0; i<visit_questions.action_plan_questions.length; i++){
                          if (visit_questions.action_plan_questions[i]
                              .answer_status != 'Add') {
                            actionPlanData[visit_questions.action_plan_questions[i]
                                .question] = visit_questions
                                .action_plan_questions[i].answer_status;
                          } else {
                            actionPlanData[visit_questions.action_plan_questions[i]
                                .question] = 'NA';
                          }                        }
                      }
                    }
                    if(canPop) {
                      Navigator.pop(context);
                      widget.onSuccess.call();
                    }
                    },
              ),
            ],
          ) : QuestionAnsUI(
              ans_a_question: ans_a_question,
              question_index: question_index,
              question_type: boxType,
              ans_type: ans_type,
              onClick: (){
                setState(() {
                  is_questions = true;
                });
              }
          )
        ),
      ),
    );
  }
}