import 'package:flutter/material.dart';
import 'package:retail_app_flutter/attendance/widgets/grace_pie_chart.dart';

import '../../constants/my_colors.dart';

class GraceBox extends StatefulWidget {
  final double totalUsed;
  final double totalGrace;
  const GraceBox({
    super.key,
    required this.totalUsed,
    required this.totalGrace});

  @override
  State<GraceBox> createState() => _GraceBoxState();
}

class _GraceBoxState extends State<GraceBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 70,
      decoration: BoxDecoration(
          color: MyColors.graceBoxColor,
          borderRadius: BorderRadius.circular(10)
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 8,left: 8),
        child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Grace Balance',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      // fontFamily: 'Poppins'
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.totalUsed.toInt().toString()}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            '${widget.totalGrace.toInt()}min',
                            style: TextStyle(
                                fontSize: 10,
                                color: MyColors.appBarColor,
                                fontWeight: FontWeight.bold
                            ),
                          )
                        ],
                      ),
                      GracePieChart(
                        total: widget.totalGrace-widget.totalUsed,
                        remaining: widget.totalUsed,
                      )
                    ],
                  ),
                ],
              ),
      ));

  }
}
