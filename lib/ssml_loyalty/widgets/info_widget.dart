import 'package:flutter/material.dart';

import '../../constants/my_fonts.dart';

class InfoWidget extends StatefulWidget {
  final String about_us;
  const InfoWidget({super.key, required this.about_us});

  @override
  State<InfoWidget> createState() => _InfoWidgetState();
}  

class _InfoWidgetState extends State<InfoWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: Text(
            widget.about_us,
            style: TextStyle(
                fontFamily: MyFonts.poppins,
                fontSize: 14
            ),
          ),
        ),
      ),
    );
  }
}
