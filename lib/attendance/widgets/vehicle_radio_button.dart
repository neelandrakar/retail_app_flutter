import 'package:flutter/material.dart';

class VehicleRadioButton extends StatefulWidget {
  final String image;
  final int index;
  final VoidCallback onClick;
  const VehicleRadioButton({super.key, required this.index, required this.image, required this.onClick});

  @override
  State<VehicleRadioButton> createState() => _VehicleRadioButtonState();
}

class _VehicleRadioButtonState extends State<VehicleRadioButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onClick,
      child: Container(
        width: 90,
        height: 45,
        child: Image.asset(widget.image),
      ),
    );
  }
}
