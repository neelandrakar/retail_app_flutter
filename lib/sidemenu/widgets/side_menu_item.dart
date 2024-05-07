import 'package:flutter/material.dart';

import '../../constants/my_colors.dart';

class SideMenuItem extends StatefulWidget {
  final String menu_icon;
  final String menu_title;
  final Color menu_color;
  final Color icon_color;
  final Color text_color;
  final bool is_selected;
  final VoidCallback onClick;
  const SideMenuItem({super.key, required this.menu_icon, required this.menu_title, required this.menu_color, required this.icon_color, required this.text_color, required this.is_selected, required this.onClick});

  @override
  State<SideMenuItem> createState() => _SideMenuItemState();
}

class _SideMenuItemState extends State<SideMenuItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.is_selected ? 0 : 20).copyWith(top: 10),
      child: InkWell(
        onTap: widget.onClick,
        child: Row(
          children: [
            if(widget.is_selected)
            Container(
              height: 35,
              width: 5,
              decoration: BoxDecoration(
                color: MyColors.greenColor,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                )
              ),
            ),
            if(widget.is_selected)
              SizedBox(width: 15,),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: widget.is_selected ? MyColors.actionsButtonColor.withOpacity(0.2) : Colors.transparent,
              ),
              child: Row(
                children: [
                  Image.network(widget.menu_icon, width: 20,height: 20, color: widget.icon_color),
                  SizedBox(width: 10),
                  Container(
                    height: 20,
                    width: 194,
                    alignment: Alignment.centerLeft,
                    child: Text(widget.menu_title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          color: widget.text_color,
                          fontSize: 14,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                  )      ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
