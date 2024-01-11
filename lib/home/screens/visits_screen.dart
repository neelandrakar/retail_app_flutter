import 'package:flutter/material.dart';

import '../../constants/my_colors.dart';

class VisitsScreen extends StatefulWidget {
  const VisitsScreen({super.key});

  @override
  State<VisitsScreen> createState() => _VisitsScreenState();
}

class _VisitsScreenState extends State<VisitsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.boneWhite,
      body: Center(
        child: Text('Visits'),
      ),
    );
  }
}
