import 'package:flutter/material.dart';

import '../../constants/my_colors.dart';
import '../../constants/my_fonts.dart';

class LocationMarker extends StatelessWidget {
  final String visit_account_name;
  final Color? icon_color;
  final VoidCallback? onClick;
  const LocationMarker({
    super.key,
    required this.visit_account_name,
    this.icon_color=Colors.red,
    this.onClick
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Column(
        children: [
          Container(
            width: 100,
            height: 30,
            padding: EdgeInsets.all(2),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: MyColors.boneWhite,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(
                    1.0,
                    1.0,
                  ),
                  blurRadius: 3.0,
                  spreadRadius: 1.0,
                ), //BoxShadow
              ],
            ),
            child: Text(
              visit_account_name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: MyColors.appBarColor,
                  fontSize: 10,
                  fontFamily: MyFonts.poppins,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Icon(
            Icons.location_on,
            color: icon_color,
            size: 30,
          ),
        ],
      ),
    );
  }
}
