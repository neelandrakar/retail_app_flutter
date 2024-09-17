import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:retail_app_flutter/constants/my_colors.dart';


class SuccessfulRedeemDialogue extends StatefulWidget {
  const SuccessfulRedeemDialogue({super.key});

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
              Icons.check,
              color: Colors.white,
              size: 40,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Yaay! Your E-Voucher is Ready!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            'Time to treat yourself! Flash this E-Voucher at the store and redeem your reward.',
            style: TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            child: Text('View E-Voucher'),
            style: ElevatedButton.styleFrom(
              backgroundColor: MyColors.loyaltyRed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              minimumSize: Size(double.infinity, 50),
            ),
            onPressed: () {
              // Add logic to view E-Voucher
              Navigator.of(context).pop();
            },
          ),
          SizedBox(height: 10),
          TextButton(
            child: Text('Go to Home'),
            style: TextButton.styleFrom(
              foregroundColor: MyColors.loyaltyRed,
              backgroundColor: MyColors.loyaltyRed.withOpacity(0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              minimumSize: Size(double.infinity, 50),
            ),
            onPressed: () {
              // Add logic to go to home
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
