import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LogoutAlert extends StatelessWidget {
  const LogoutAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "You've successfully logged out",
        style: TextStyle(
            fontSize: 18
        ),),
      //content: const Text('AlertDialog description'),
      actions: <Widget>[
        Center(
          child: TextButton(
            onPressed: () {
              if (Platform.isAndroid) {
                SystemNavigator.pop();
              } else if (Platform.isIOS) {
                exit(0);
              }
            },
            child: const Text('OK'),
          ),
        ),

      ],
    );
  }
}
