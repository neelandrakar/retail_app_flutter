import 'package:flutter/material.dart';
import 'package:retail_app_flutter/sidemenu/screens/activity_screen.dart';
import 'package:retail_app_flutter/sidemenu/screens/loyalty_tier_screen.dart';

class BottomNavBarPages{

  static List<Widget> allWidgets = [

    LoyaltyTierScreen(),
    ActivitySchemeScreen(),
  ];
}