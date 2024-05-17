import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:retail_app_flutter/constants/my_colors.dart';

import '../../constants/assets_constants.dart';
import '../../constants/custom_app_bar.dart';
import '../../constants/utils.dart';
import '../../sidemenu/screens/side_menu.dart';
import '../../sidemenu/widgets/bottom_nav_bar_pages.dart';

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
    print('page is changed to $index');
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
          width: 281,
        ),
        body: IndexedStack(
            index: _page,
            children: BottomNavBarPages.allWidgets

        ),
        bottomNavigationBar: CupertinoTabBar(
          backgroundColor: MyColors.appBarColor,
          currentIndex: _page,
          onTap: onPageChange,
          border: Border(
              top: BorderSide(
                  color: MyColors.appBarColor
              )
          ),

          items: [
            BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Image.asset(
                    AssetsConstants.tier_logo,
                    color: _page==0 ? MyColors.greenColor : MyColors.boneWhite
                  ),
                )),
            BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Image.asset(
                      AssetsConstants.activity,
                      color: _page==1 ? MyColors.greenColor : MyColors.boneWhite
                  ),
                )),
          ],

        )
    );
  }
}
