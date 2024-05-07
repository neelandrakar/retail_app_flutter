import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../constants/my_colors.dart';
import '../../constants/my_fonts.dart';

class VisitQuestionListBox extends StatefulWidget {
  final String question_name;
  final String ans_status;
  final int is_mandatory;
  final VoidCallback onClick;
  const VisitQuestionListBox({
    super.key,
    required this.question_name,
    required this.ans_status,
    required this.is_mandatory,
    required this.onClick
  });

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
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                color: MyColors.blackColor,
                fontSize: 12,
                fontFamily: MyFonts.poppins,
                fontWeight: FontWeight.w400,
              ),
              children: [
                TextSpan(
                  text: widget.question_name,
                ),
                if(widget.is_mandatory==1)
                TextSpan(
                  text: '*',
                  style: TextStyle(
                    color: Colors.red, // Change this to the desired color for the mandatory * sign
                  ),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: widget.onClick,
          child: Container(
            width: 50,
            height: 25,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: MyColors.lightBlueColor,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: MyColors.blueColor.withOpacity(0.5))
            ),
            child: widget.ans_status == 'Add' ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.ans_status,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: MyColors.blueColor,
                      fontSize: 12,
                      fontFamily: MyFonts.poppins,
                      fontWeight: FontWeight.w500),
                ),
                Icon(Icons.add, color: MyColors.blueColor, size: 12,)
              ],
            ) : TextScroll(
                  widget.ans_status,
                  mode: TextScrollMode.bouncing,
                  velocity: Velocity(pixelsPerSecond: Offset(30, 0)),
                  delayBefore: Duration(milliseconds: 1000),
                  numberOfReps: 5,
                  pauseBetween: Duration(milliseconds: 500),
                  textAlign: TextAlign.right,
                  selectable: false,
                  style: const TextStyle(
                  color: MyColors.blueColor,
                  fontSize: 12,
                  fontFamily: MyFonts.poppins,
                  fontWeight: FontWeight.w500),
            ),
          ),
        )
      ],
    );
  }
}
