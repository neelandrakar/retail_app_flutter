import 'package:flutter/material.dart';
import 'package:retail_app_flutter/accounts/screens/accounts_screen.dart';
import 'package:retail_app_flutter/attendance/screens/attendance_screen.dart';
import 'package:retail_app_flutter/attendance/screens/submit_odometer_screen.dart';
import 'package:retail_app_flutter/home/screens/home_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings){

  switch(routeSettings.name){

    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HomeScreen()
      );

    case AttendanceScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const AttendanceScreen()
      );

    case SubmitOdometerScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const SubmitOdometerScreen()
      );

    case Accounts.routeName:
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const Accounts()
      );

    default:
      return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text("Page not found 404!"),
            ),
          ));
  }
}