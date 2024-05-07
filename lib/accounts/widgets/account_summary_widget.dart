import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:retail_app_flutter/constants/my_fonts.dart';

import '../../constants/my_colors.dart';

class AccountSummaryWidget extends StatefulWidget {
  final String account_status;
  final int account_count;
  final Color account_count_color;
  final bool isLast;
  final bool? isTargetBox;
  final int? min_acc;
  const AccountSummaryWidget({
    super.key,
    required this.account_status,
    required this.account_count,
    required this.account_count_color,
    this.isLast = false,
    this.isTargetBox = false,
    this.min_acc = 0
  });

  @override
  State<AccountSummaryWidget> createState() => _AccountSummaryWidgetState();
}

class _AccountSummaryWidgetState extends State<AccountSummaryWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.account_status,
              style: TextStyle(
                  color: MyColors.blackColor.withOpacity(0.8),
                  fontSize: 11,
                  fontFamily: MyFonts.poppins
              ),
            ),
            Visibility(
              visible: widget.isTargetBox == true,
              child: Text(
                'Minimum ${widget.min_acc} a/c',
                style: TextStyle(
                    color: MyColors.fadedBlack,
                    fontSize: 8 ,
                    fontFamily: MyFonts.poppins
                ),
              ),
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Text(
                  widget.account_count.toString(),
                  style: TextStyle(
                      color: widget.account_count_color,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    fontFamily: MyFonts.poppins
                  ),
                ),
                Visibility(
                    visible: widget.isTargetBox == true,
                    child: SizedBox(width: 3)),
                Visibility(
                    visible: widget.isTargetBox == true,
                    child: Icon(
                        widget.min_acc!>widget.account_count ? Icons.highlight_remove_outlined : Icons.check_circle_rounded,
                        color: widget.min_acc!>widget.account_count ? MyColors.redColor : MyColors.greenColor,
                         size: 10
                    ))
              ],
            )
          ],
        ),
        if(!widget.isLast)
        SizedBox(width: 5,),
        if(!widget.isLast)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: VerticalDivider(thickness: 0,color: MyColors.fadedBlack,),
          )
      ],
    );
  }
}
