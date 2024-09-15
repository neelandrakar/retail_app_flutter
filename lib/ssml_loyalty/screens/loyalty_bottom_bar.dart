import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:retail_app_flutter/constants/my_colors.dart';
import 'package:retail_app_flutter/ssml_loyalty/screens/merchants_screen.dart';

import '../../constants/assets_constants.dart';
import '../../constants/custom_app_bar.dart';
import '../../constants/global_variables.dart';
import '../../constants/utils.dart';
import '../../sidemenu/screens/side_menu.dart';
import '../widgets/bottom_nav_bar_pages.dart';
import 'activity_scheme_screen.dart';
import 'loyalty_tier_screen.dart';

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

  Widget _getBody(int index) {
    switch (index) {
      case 0:
        return LoyaltyTierScreen();
      case 1:
        return MerchantsScreen();
      case 3:
        return ActivitySchemeScreen();
      default:
        return Container();
    }
  }

  void onPageChange(int index) {
    if (index == 3 && !isSchemeFullyLoaded) {

      showSnackBar(context, 'Let tier data load first');
    } else {
    setState(() {
      _page = index;
    });
    print('page is changed to $index');
  }}




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
        body: _getBody(_page),

        bottomNavigationBar: CupertinoTabBar(
          backgroundColor: MyColors.offWhiteColor,
          activeColor: MyColors.redColor,
          currentIndex: _page,
          onTap: onPageChange,
          border: Border(
              top: BorderSide(
                  color: MyColors.offWhiteColor
              )
          ),

          items: [
            BottomNavigationBarItem(
                label: 'Tier',
                icon: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Image.asset(
                    AssetsConstants.tier_logo,
                    color: _page==0 ? MyColors.redColor : MyColors.appBarColor
                  ),
                )),
            BottomNavigationBarItem(
                label: 'Merchants',
                icon: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Image.asset(
                      AssetsConstants.merchant_icon,
                      color: _page==1 ? MyColors.redColor : MyColors.appBarColor
                  ),
                )),
            BottomNavigationBarItem(
                label: 'My Vouchers',
                icon: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Image.asset(
                      AssetsConstants.my_voucher_icon,
                      color: _page==2 ? MyColors.redColor : MyColors.appBarColor
                  ),
                )),
            BottomNavigationBarItem(
                label: 'Activity',
                icon: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Image.asset(
                      AssetsConstants.activity,
                      color: _page==3 ? MyColors.redColor : MyColors.appBarColor
                  ),
                )),
          ],
        )
    );
  }
}
