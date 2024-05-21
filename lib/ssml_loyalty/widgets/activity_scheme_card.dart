import 'package:flutter/material.dart';
import 'package:retail_app_flutter/providers/ssml_loyalty_provider.dart';

class ActivitySchemeCard extends StatefulWidget {
  const ActivitySchemeCard({super.key});

  @override
  State<ActivitySchemeCard> createState() => _ActivitySchemeCardState();
}

class _ActivitySchemeCardState extends State<ActivitySchemeCard> {


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [

          Text('dataX', style: TextStyle(color: Colors.black),)
        ],
      ),
    );
  }
}
