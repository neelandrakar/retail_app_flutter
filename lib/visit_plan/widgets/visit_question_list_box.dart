import 'package:flutter/material.dart';

import '../../constants/my_colors.dart';
import '../../constants/my_fonts.dart';

class VisitQuestionListBox extends StatefulWidget {
  final String question_name;
  const VisitQuestionListBox({super.key, required this.question_name});

  @override
  State<VisitQuestionListBox> createState() => _VisitQuestionListBoxState();
}

class _VisitQuestionListBoxState extends State<VisitQuestionListBox> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 180,
          child: Text(
            widget.question_name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: MyColors.blackColor,
                fontSize: 12,
                fontFamily: MyFonts.poppins,
                fontWeight: FontWeight.w400),
          ),
        ),
        Container(
          width: 50,
          height: 25,
          decoration: BoxDecoration(
            color: MyColors.lightBlueColor,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: MyColors.blueColor.withOpacity(0.5))
          ),
        )
      ],
    );
  }
}
