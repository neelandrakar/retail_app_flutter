import 'package:flutter/material.dart';

class HomeMenuRadioButton extends StatefulWidget {
  final String bar_name;
  const HomeMenuRadioButton({super.key, required this.bar_name});

  @override
  State<HomeMenuRadioButton> createState() => _HomeMenuRadioButtonState();
}

class _HomeMenuRadioButtonState extends State<HomeMenuRadioButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 80,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20)
        ),
        alignment: Alignment.center,
        child: Text(
          widget.bar_name,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 12
          ),
        ),
    );
  }
}
