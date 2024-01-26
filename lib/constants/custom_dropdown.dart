import 'package:flutter/material.dart';
import 'package:retail_app_flutter/constants/my_colors.dart';
import 'my_fonts.dart';

class CustomDropdown extends StatefulWidget {
  final List<DropdownMenuItem> dropdownItems;
  late dynamic defaultValue;
  final Icon dropdownIcon;
  final double height;
  final double width;
  final String hintText;
  final Color hintTextColor;
  final FontWeight hintTextWeight;
  final double hintTextSize;
  final Color boxColor;
  final bool? isDisabled;
  final String? disabledText;
  final Function(dynamic param) onSelect;
  CustomDropdown({
    super.key,
    required this.dropdownItems,
    this.defaultValue,
    required this.dropdownIcon,
    required this.height,
    required this.width,
    required this.boxColor,
    required this.hintText,
    required this.hintTextColor,
    required this.hintTextWeight,
    required this.hintTextSize,
    required this.onSelect,
    this.isDisabled = false,
    this.disabledText
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.width,
        height: widget.height,
        padding: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: widget.boxColor
        ),
        child: DropdownButton(
          dropdownColor: MyColors.boneWhite,
          isExpanded: true,
          borderRadius: BorderRadius.circular(10),
          elevation: 4,
          disabledHint: Text(
            '${widget.disabledText}',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
                color: widget.hintTextColor,
                fontFamily: MyFonts.poppins,
                fontSize: widget.hintTextSize,
                fontWeight: widget.hintTextWeight
            ),
          ),
          style: TextStyle(
              color: Colors.black,
              fontFamily: MyFonts.poppins,
              fontSize: widget.hintTextSize,
              fontWeight: widget.hintTextWeight,
              overflow: TextOverflow.ellipsis
          ),

            hint: Text(
                'Select ${widget.hintText}',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,

              style: TextStyle(
                  color: widget.hintTextColor,
                  fontFamily: MyFonts.poppins,
                  fontSize: widget.hintTextSize,
                  fontWeight: widget.hintTextWeight
              ),
            ),
            icon: widget.dropdownIcon,
            value: widget.defaultValue,
            items: widget.dropdownItems,
            onChanged: widget.isDisabled==false ?
                (dynamic newValue) async {
                  widget.onSelect(newValue);
                  widget.defaultValue = newValue;
                  setState(() {
                    print('new value: ${widget.defaultValue}');
                  });
                } : null
        ),
      );
  }
}
