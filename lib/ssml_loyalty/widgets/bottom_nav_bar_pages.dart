import 'package:flutter/material.dart';
import 'package:retail_app_flutter/ssml_loyalty/screens/activity_scheme_screen.dart';
import 'package:retail_app_flutter/ssml_loyalty/screens/loyalty_tier_screen.dart';

class BottomNavBarPages{

  static List<Widget> allWidgets = [

    LoyaltyTierScreen(),
    ActivitySchemeScreen(),
  ];
}