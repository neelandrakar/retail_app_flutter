import 'package:flutter/material.dart';

import '../../constants/custom_elevated_button.dart';
import '../../constants/my_colors.dart';
import '../../constants/my_fonts.dart';

class PendingDataItem extends StatefulWidget {
  final String item_name;
  final Color item_color;
  final String item_count;
  final String button_text;
  final bool is_menu;
  final VoidCallback onClick;
  const PendingDataItem({
    super.key,
    required this.item_name,
    required this.item_color,
    required this.item_count,
    required this.button_text,
    required this.is_menu,
    required this.onClick
  });

  @override
  State<PendingDataItem> createState() => _PendingDataItemState();
}

class _PendingDataItemState extends State<PendingDataItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          color: widget.is_menu ? MyColors.pendingDataBlue : MyColors.boneWhite,
          borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        children: [
          Container(
            width: 200,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                widget.item_name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: widget.is_menu ? MyColors.boneWhite : MyColors.appBarColor,
                    fontSize: 13,
                    fontFamily: MyFonts.poppins,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Container(
            // color: Colors.red,
            width: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    widget.item_count,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: widget.is_menu ? MyColors.boneWhite : MyColors.appBarColor,
                        fontSize: 13,
                        fontFamily: MyFonts.poppins,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                CustomElevatedButton(
                    buttonText: widget.button_text,
                    textSize: 13,
                    isDisabled: widget.item_count==0.toString() ? true : false ,
                    //buttonIcon: Icons.refresh_outlined,
                    //iconSize: 10,
                    buttonColor: widget.is_menu ? MyColors.appBarColor : MyColors.blueColor,
                    buttonTextColor: widget.is_menu ? MyColors.boneWhite : MyColors.boneWhite,
                    height: 36,
                    width: 77,
                    onClick: (){

                      widget.onClick.call();


                    }
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
