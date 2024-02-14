import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:retail_app_flutter/constants/my_colors.dart';
import 'package:retail_app_flutter/visit_plan/widgets/discussion_action_plan_dialogue.dart';

import '../../constants/my_fonts.dart';

class DiscussionActionPlanBox extends StatefulWidget {
  final String boxText;
  final String boxIcon;
  const DiscussionActionPlanBox({super.key, required this.boxText, required this.boxIcon});

  @override
  State<DiscussionActionPlanBox> createState() => _DiscussionActionPlanBoxState();
}

class _DiscussionActionPlanBoxState extends State<DiscussionActionPlanBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64.3,
      width: 140,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: MyColors.lightBlueColor,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.boxText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: MyColors.blackColor,
                    fontSize: 14,
                    fontFamily: MyFonts.poppins,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 2),
              GestureDetector(
                onTap: (){
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext con){
                        return DiscussionActionPlanDialogue(
                          boxName: widget.boxText,
                        );
                      });
                },
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Add Topic',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: MyColors.blueColor,
                          fontSize: 12,
                          fontFamily: MyFonts.poppins,
                          fontWeight: FontWeight.w500),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: 8,
                      color: MyColors.blueColor
                    )
                  ],
                ),
              )
            ],
          ),
          Image.asset(widget.boxIcon, height: 25, width: 25)
        ],
      ),
    );
  }
}
