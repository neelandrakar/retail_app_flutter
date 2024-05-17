import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:retail_app_flutter/constants/my_colors.dart';

import '../../constants/custom_app_bar.dart';
import '../../constants/utils.dart';
import '../../sidemenu/screens/side_menu.dart';

class LoyaltyBottomBar extends StatefulWidget {
  static const String routeName = '/loyalty-bottom-bar';
  const LoyaltyBottomBar({super.key});

  @override
  State<LoyaltyBottomBar> createState() => _LoyaltyBottomBarState();
}

class _LoyaltyBottomBarState extends State<LoyaltyBottomBar> {

  int side_menu_item_no = 3;
  int _page = 0;
  String pageName = 'Loyalty Program';
  void onPageChange(int index){

    setState(() {
      _page = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.boneWhite,
        drawer: Drawer(
          backgroundColor: MyColors.appBarColor,
          child: SideMenu(
            side_menu_item_no: side_menu_item_no,
          ),
          width: 280,
        ),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: CustomAppBar(
            module_name: pageName,
            emp_name: getEmployeeName(context),
            leading: Icon(Icons.menu_outlined, color: MyColors.actionsButtonColor, size: 20,),
          ),
        ),
        bottomNavigationBar: CupertinoTabBar(
          backgroundColor: MyColors.appBarColor,
          currentIndex: _page,
          onTap: onPageChange,
          border: Border(
              top: BorderSide(
                  color: Colors.pink
              )
          ),

          items: [
            BottomNavigationBarItem(icon: Icon(Icons.ac_unit, color: Colors.red,)),
            BottomNavigationBarItem(icon: Icon(Icons.account_balance, color: Colors.green,)),
          ],

        )
    );
  }
}
