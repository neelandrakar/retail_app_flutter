import 'package:flutter/material.dart';

import 'my_colors.dart';

class CustomAppBar extends StatelessWidget {
  final String module_name;
  final String emp_name;
  final bool show_back_button;
  final Widget? leading;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final bool? body_behind_appbar;
  final bool? show_emp_name;
  final Color? appBarColor;
  final Color? titleTextColor;
  final Color? leadingIconColor;
  const CustomAppBar({
    super.key,
    required this.module_name,
    required this.emp_name,
    this.show_back_button = true,
    this.bottom,
    this.leading,
    this.actions,
    this.body_behind_appbar = false,
    this.show_emp_name = true,
    this.appBarColor = MyColors.appBarColor,
    this.titleTextColor = MyColors.boneWhite,
    this.leadingIconColor = MyColors.actionsButtonColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: appBarColor,
      centerTitle: true,
      leading: GestureDetector(
          child: leading,
        onTap: (){
          show_emp_name! ? Scaffold.of(context).openDrawer() : Navigator.pop(context);
          print('Open drawer');
        },
      ),
      foregroundColor: MyColors.boneWhite,
      actions: actions,
      automaticallyImplyLeading: show_back_button,
      excludeHeaderSemantics: body_behind_appbar!,
      title: Column(
        children: [
          Text(module_name,
            style: TextStyle(
                fontFamily: 'Poppins',
                color: titleTextColor,
                fontSize: 16,
                fontWeight: FontWeight.w500
            ),
          ),
          if(show_emp_name==true)
          Text(emp_name,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontFamily: 'Poppins',
                color: MyColors.actionsButtonColor,
                fontSize: 11,
                fontWeight: FontWeight.w400
            ),
          ),
        ],
      ),
      bottom: bottom,
    );
  }
}
