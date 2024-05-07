import 'package:flutter/material.dart';
import 'package:retail_app_flutter/constants/my_colors.dart';
import 'package:retail_app_flutter/constants/my_fonts.dart';

class MenuCard extends StatefulWidget {
  final String menu_icon;
  final String menu_name;
  final VoidCallback onClick;
  const MenuCard({super.key, required this.menu_icon, required this.menu_name, required this.onClick});

  @override
  State<MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<MenuCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onClick,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(widget.menu_icon, height: 100, width: 100,),
          SizedBox(height: 5,),
          Text(
            widget.menu_name,
            style: TextStyle(
              color: MyColors.appBarColor,
              fontFamily: MyFonts.poppins,
              fontWeight: FontWeight.w500,
              fontSize: 16
            ),
          )

        ],
      ),
    );
  }
}
