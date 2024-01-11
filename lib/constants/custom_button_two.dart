import 'package:flutter/material.dart';

class CustomButtonTwo extends StatefulWidget {
  final double height;
  final double width;
  final double borderRadius;
  final Color buttonColor;
  final Color text_color;
  final String button_text;
  final double button_text_size;
  final VoidCallback onClick;
  const CustomButtonTwo({
    super.key,
    required this.height,
    required this.width,
    required this.buttonColor,
    required this.borderRadius,
    required this.button_text,
    required this.text_color,
    required this.button_text_size,
    required this.onClick
  });

  @override
  State<CustomButtonTwo> createState() => _CustomButtonTwoState();
}

class _CustomButtonTwoState extends State<CustomButtonTwo> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        widget.onClick.call();
      },
      child: Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          color: widget.buttonColor,
          borderRadius: BorderRadius.circular(widget.borderRadius)
        ),
        child: Center(
          child: Text(
            widget.button_text,
            style: TextStyle(
              color: widget.text_color,
              fontFamily: 'Poppins',
              fontSize: widget.button_text_size
            ),
          ),
        ),
      ),
    );
  }
}
