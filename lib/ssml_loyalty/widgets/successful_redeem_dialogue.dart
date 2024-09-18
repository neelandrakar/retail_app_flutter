import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:retail_app_flutter/constants/custom_button.dart';
import 'package:retail_app_flutter/constants/global_variables.dart';
import 'package:retail_app_flutter/constants/my_colors.dart';
import 'package:retail_app_flutter/home/screens/home_screen.dart';

import '../../constants/my_fonts.dart';


class SuccessfulRedeemDialogue extends StatefulWidget {
  final String header_text;
  final String msg;
  const SuccessfulRedeemDialogue({
    super.key,
    required this.header_text,
    required this.msg
  });

  @override
  State<SuccessfulRedeemDialogue> createState() => _SuccessfulRedeemDialogueState();
}

class _SuccessfulRedeemDialogueState extends State<SuccessfulRedeemDialogue> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: MyColors.loyaltyRed,
              shape: BoxShape.circle,
            ),
            child: Icon(
              gift_redemption_status == 1 ? Icons.check : Icons.error_outline,
              color: Colors.white,
              size: 40,
            ),
          ),
          SizedBox(height: 20),
          Text(
            widget.header_text,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: MyFonts.poppins,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            widget.msg,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                fontFamily: MyFonts.poppins
            ),
            textAlign: TextAlign.center,
          ),
          if(gift_redemption_status==2)
          SizedBox(height: 20),
          if(gift_redemption_status==2)
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: Text(
              'Your Points: $gift_redemption_api_my_points',
              maxLines: 1,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: MyFonts.poppins,
                overflow: TextOverflow.ellipsis
              ),
            ),
          ),
          if(gift_redemption_status==2)
            Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: Text(
              'Required Points: $gift_redemption_api_points_needed',
              maxLines: 1,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: MyFonts.poppins,
                  overflow: TextOverflow.ellipsis
              ),
            ),
          ),
          SizedBox(height: 20),
          CustomButton(
              onClick: (){
                Navigator.pop(context);
              },
              buttonText: gift_redemption_status==1 ? "View Voucher List" : "Try again",
              borderRadius: 50, 
              buttonTextSize: 14,
              fontWeight: FontWeight.w600,
              buttonColor: MyColors.loyaltyRed,
              textColor: MyColors.boneWhite,
              height: 50,
              width: double.infinity,
          ),
          SizedBox(height: 10),
          CustomButton(
            onClick: (){
              Navigator.pop(context);
              Navigator.pushNamed(context, HomeScreen.routeName);
            },
            buttonText: "Go to Home",
            borderRadius: 50,
            buttonTextSize: 14,
            fontWeight: FontWeight.w600,
            buttonColor: MyColors.loyaltyRedLowOpacity.withOpacity(0.6),
            textColor: MyColors.boneWhite,
            height: 50,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}
