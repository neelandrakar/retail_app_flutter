import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class SuccessfulRedeemDialogue extends StatefulWidget {
  const SuccessfulRedeemDialogue({super.key});

  @override
  State<SuccessfulRedeemDialogue> createState() => _SuccessfulRedeemDialogueState();
}

class _SuccessfulRedeemDialogueState extends State<SuccessfulRedeemDialogue> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "You've redeemed!",
        style: TextStyle(
            fontSize: 18
        ),),
      //content: const Text('AlertDialog description'),
      actions: <Widget>[
        Center(
          child: TextButton(
            onPressed: () {

              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ),

      ],
    );
  }
}
