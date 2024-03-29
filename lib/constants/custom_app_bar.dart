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
  const CustomAppBar({
    super.key,
    required this.module_name,
    required this.emp_name,
    this.show_back_button = true,
    this.bottom,
    this.leading,
    this.actions,
    this.body_behind_appbar = false
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: MyColors.appBarColor,
      centerTitle: true,
      leading: GestureDetector(
          child: leading,
        onTap: (){
          Scaffold.of(context).openDrawer();
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
                color: MyColors.boneWhite,
                fontSize: 16,
                fontWeight: FontWeight.w500
            ),
          ),
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
