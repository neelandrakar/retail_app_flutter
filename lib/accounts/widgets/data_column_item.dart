import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants/my_colors.dart';

class DataColumnItem extends StatelessWidget {
  final String column_name;
  final int max_line;
  final bool? is_last;
  final bool? is_first;
  final Color column_color;
  final bool? isDataRow;
  const DataColumnItem({
    super.key,
    required this.column_name,
    required this.max_line,
    this.is_last = false,
    required this.column_color,
    this.is_first = false,
    this.isDataRow = false
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: is_first! ? Radius.circular(10) : Radius.zero,
          bottomLeft: is_first! ? Radius.circular(10) : Radius.zero,
          topRight: is_last! ? Radius.circular(10) : Radius.zero,
          bottomRight: is_last! ? Radius.circular(10) : Radius.zero,
        ),
        color: column_color
      ),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Visibility(
              visible: is_first==true,
              child: SizedBox(width: 10,)
          ),
          Text(
            column_name,
            maxLines: max_line,
          ),
          Visibility(
              visible: is_last == false,
              child: VerticalDivider(thickness: 0,color: isDataRow! ? MyColors.deepBlueColor : MyColors.boneWhite)),
          Visibility(
              visible: is_last==true,
              child: SizedBox(width: 10,)
          )
        ],
      ),
    );
  }
}
