import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:retail_app_flutter/constants/my_colors.dart';
import 'package:retail_app_flutter/models/visit_question_model.dart';
import 'package:retail_app_flutter/providers/visit_questions_provider.dart';
import 'package:retail_app_flutter/visit_plan/widgets/visit_question_list_box.dart';

import '../../constants/custom_elevated_button.dart';
import '../../constants/my_fonts.dart';

class DiscussionActionPlanDialogue extends StatefulWidget {
  final String boxName;
  const DiscussionActionPlanDialogue({super.key, required this.boxName});

  @override
  State<DiscussionActionPlanDialogue> createState() => _DiscussionActionPlanDialogueState();
}

class _DiscussionActionPlanDialogueState extends State<DiscussionActionPlanDialogue> {
  int boxType = 0;
  late VisitQuestionModel visit_questions;
  bool is_questions = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.boxName=='Discussed On'){
      boxType=1;
    } else if(widget.boxName=='Action Plan'){
      boxType=2;
    }
    visit_questions = Provider.of<VisitQuestionsProvider>(context, listen: false).visitQuestionsModel;
  }

  @override
  Widget build(BuildContext context) {
    print('type: '+ boxType.toString());
    return Dialog(
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
              'You need to submit multiple questions',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: MyColors.fadedBlack,
                  fontSize: 12,
                  fontFamily: MyFonts.poppins,
                  fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 160,
              child: Expanded(
                child: boxType==1 ? ListView.separated(
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
                            });
                          },
                          );
                    }, separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(height: 5);
                },
                ) : ListView.separated(
                  itemCount: visit_questions.action_plan_questions.length,
                  itemBuilder: (context, index){
                    return VisitQuestionListBox(
                      question_name: visit_questions.discussion_questions[index].question,
                      ans_status: '',
                      is_mandatory: visit_questions.action_plan_questions[index].is_mandatory,
                      onClick: (){
                        print(visit_questions.action_plan_questions[index].question);
                      },

                    );
                  }, separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: 5);
                },
                ),
              ),
            ),
            SizedBox(height: 18),
            CustomElevatedButton(
              buttonText: 'Close & Save',
              buttonIcon: Icons.close,
              buttonColor: MyColors.appBarColor,
              buttonTextColor: Colors.white,
              buttonIconColor: MyColors.redColor,
              width: 100,
              height: 35,
              iconSize: 15,
              textSize: 10,
              onClick: () {
                Navigator.pop(context);
              },
            ),
          ],
        ) : Column(
          children: [

          ],
        ),
      ),
    );
  }
}
