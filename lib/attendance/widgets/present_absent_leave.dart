import 'package:flutter/material.dart';
import 'package:retail_app_flutter/constants/my_colors.dart';

class PresentAbsentLeave extends StatefulWidget {
  final Color textColor;
  final bool isLast;
  final String text;
  final int value;
  const PresentAbsentLeave({super.key, required this.textColor, this.isLast=false, required this.text, required this.value});

  @override
  State<PresentAbsentLeave> createState() => _PresentAbsentLeaveState();
}

class _PresentAbsentLeaveState extends State<PresentAbsentLeave> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: Row(
         children: [
           Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Text(widget.value.toString(),
               style: TextStyle(
                 fontWeight: FontWeight.bold,
                 fontSize: 13,
                 color: Colors.black,
                 // fontFamily: 'Poppins'
               ),),
               // SizedBox(height: 3,),
               Text(widget.text,
               style: TextStyle(
                 fontWeight: FontWeight.bold,
                 fontSize: 12,
                 color: widget.textColor,
                 // fontFamily: 'Poppins'
               ),)
             ],
           ),
           if(!widget.isLast)
           VerticalDivider(
             thickness: 0.3,
             color: Colors.black,
           )

         ],
      ),
    );
  }
}
