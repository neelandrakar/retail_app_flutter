import 'package:flutter/material.dart';

import '../../constants/my_colors.dart';

class AccountSummaryWidget extends StatefulWidget {
  final String account_status;
  final int account_count;
  final Color account_count_color;
  final bool isLast;
  const AccountSummaryWidget({
    super.key,
    required this.account_status,
    required this.account_count,
    required this.account_count_color,
    this.isLast = false
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
                  color: MyColors.fadedBlack,
                  fontSize: 11
              ),
            ),
            SizedBox(height: 4),
            Text(
              widget.account_count.toString(),
              style: TextStyle(
                  color: widget.account_count_color,
                  fontSize: 14,
                  fontWeight: FontWeight.w500
              ),
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
