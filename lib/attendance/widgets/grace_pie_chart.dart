import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class GracePieChart extends StatefulWidget {
  final double total;
  final double remaining;
  const GracePieChart({super.key, required this.total, required this.remaining});

  @override
  State<GracePieChart> createState() => _GracePieChartState();
}

class _GracePieChartState extends State<GracePieChart> {



  @override
  Widget build(BuildContext context) {

    final dataMap = <String, double>{
      "Total": widget.total,
      "Remaining": widget.remaining,
    };

    return PieChart(
        dataMap: dataMap,
        chartRadius: 30,
      chartLegendSpacing: 1,
      chartValuesOptions: ChartValuesOptions(
        showChartValues: false
      ),
      legendOptions: LegendOptions(
        showLegends: false,
        ),
      );
  }
}
