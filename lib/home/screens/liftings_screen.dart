import 'package:flutter/material.dart';

import '../../constants/my_colors.dart';

class LiftingsScreen extends StatefulWidget {
  const LiftingsScreen({super.key});

  @override
  State<LiftingsScreen> createState() => _LiftingsScreenState();
}

class _LiftingsScreenState extends State<LiftingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.boneWhite,
      body: Center(
        child: Text(
          'Liftings'
        ),
      ),
    );
  }
}
