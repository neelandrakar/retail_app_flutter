import 'package:flutter/material.dart';

class SimpleTextField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final double height;
  final double width;
  final int? maxLines;
  final TextInputType? textInputType;
  final TextEditingController controller;
  final Function(String) onChanged;

  SimpleTextField({
    required this.labelText,
    required this.hintText,
    required this.height,
    required this.width,
    required this.controller,
    required this.onChanged,
    this.textInputType = TextInputType.text,
    this.maxLines = 1
  });

  @override
  _SimpleTextFieldState createState() => _SimpleTextFieldState();
}

class _SimpleTextFieldState extends State<SimpleTextField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: _isFocused ? Colors.grey[200] : Colors.white,
        border: Border.all(
          color: _isFocused ? Colors.grey.shade400 : Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: TextField(
        keyboardType: widget.textInputType,
        onChanged: widget.onChanged,
        maxLines: widget.maxLines,
        textAlign: TextAlign.start,
        controller: widget.controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            gapPadding: 0
          ),
          labelText: widget.labelText,
          hintText: widget.hintText,
        ),
      ),
    );
  }
}