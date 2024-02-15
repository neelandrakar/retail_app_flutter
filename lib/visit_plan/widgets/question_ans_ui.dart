import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/custom_elevated_button.dart';
import '../../constants/global_variables.dart';
import '../../constants/my_colors.dart';
import '../../constants/my_fonts.dart';
import '../../models/visit_question_model.dart';
import '../../providers/visit_questions_provider.dart';

class QuestionAnsUI extends StatefulWidget {
  final String ans_a_question;
  final int question_index;
  final VoidCallback onClick;
  final int ans_type;
  const QuestionAnsUI({super.key, required this.ans_a_question, required this.question_index, required this.onClick, required this.ans_type});

  @override
  State<QuestionAnsUI> createState() => _QuestionAnsUIState();
}

class _QuestionAnsUIState extends State<QuestionAnsUI> {
  String ans = 'NA';
  late VisitQuestionModel visit_questions;

  getAnsType<Widget>(){
    if(widget.ans_type==1){
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Radio(
                activeColor: MyColors.appBarColor,
                value: QuestionAnswerType.Yes,
                groupValue: questionAnswerType,
                onChanged: (QuestionAnswerType? val) {
                  print(val.toString());
                  setState(() {
                    questionAnswerType = val!;
                    ans = 'YES';
                  });
                },
              ),
              const Text(
                'Yes',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: MyColors.blackColor,
                    fontSize: 14,
                    fontFamily: MyFonts.poppins,
                    fontWeight: FontWeight.w400),
              )
            ],
          ),
          Row(
            children: [
              Radio(
                activeColor: MyColors.appBarColor,
                value: QuestionAnswerType.No,
                groupValue: questionAnswerType,
                onChanged: (QuestionAnswerType? val) {
                  print(val.toString());
                  setState(() {
                    questionAnswerType = val!;
                    ans = 'No';
                  });
                },
              ),
              const Text(
                'No',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: MyColors.blackColor,
                    fontSize: 14,
                    fontFamily: MyFonts.poppins,
                    fontWeight: FontWeight.w400),
              )
            ],
          )
        ],
      );
    } else {
      return Container();
    }
  }

  @override
  void initState() {
    super.initState();

    visit_questions = Provider.of<VisitQuestionsProvider>(context, listen: false).visitQuestionsModel;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          widget.ans_a_question,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: MyColors.appBarColor,
              fontSize: 16,
              fontFamily: MyFonts.poppins,
              fontWeight: FontWeight.w500),
        ),
        getAnsType(),

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
          onClick: (){
            setState(() {
              if(widget.ans_type==1){
                if(questionAnswerType ==  QuestionAnswerType.Yes){
                  visit_questions.discussion_questions[widget.question_index].answer_status = 'Yes';
                } else{
                  visit_questions.discussion_questions[widget.question_index].answer_status = 'No';
                }
              }
              questionAnswerType = QuestionAnswerType.No;
            });
            widget.onClick.call();
          },
        )
      ],
    );
  }
}
