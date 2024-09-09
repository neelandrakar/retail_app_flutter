import 'package:flutter/material.dart';
import 'package:retail_app_flutter/account_map/screens/account_map_screen.dart';
import 'package:retail_app_flutter/accounts/screens/account_list.dart';
import 'package:retail_app_flutter/accounts/screens/accounts_screen.dart';
import 'package:retail_app_flutter/accounts/screens/create_account_screen.dart';
import 'package:retail_app_flutter/accounts/screens/target_vs_achievement_screen.dart';
import 'package:retail_app_flutter/attendance/screens/attendance_screen.dart';
import 'package:retail_app_flutter/attendance/screens/submit_odometer_screen.dart';
import 'package:retail_app_flutter/change_password/screens/change_password_screen.dart';
import 'package:retail_app_flutter/constants/camera_screen.dart';
import 'package:retail_app_flutter/constants/global_variables.dart';
import 'package:retail_app_flutter/home/screens/home_screen.dart';
import 'package:retail_app_flutter/home/screens/visits_screen.dart';
import 'package:retail_app_flutter/models/merchant_model.dart';
import 'package:retail_app_flutter/pending_data/screens/pending_data.dart';
import 'package:retail_app_flutter/ssml_loyalty/screens/gift_redemption_screen.dart';
import 'package:retail_app_flutter/ssml_loyalty/screens/loyalty_bottom_bar.dart';
import 'package:retail_app_flutter/ssml_loyalty/screens/merchant_detail_screen.dart';
import 'package:retail_app_flutter/visit_plan/screens/confirm_location_screen.dart';
import 'package:retail_app_flutter/visit_plan/screens/submit_remarks_screen.dart';
import 'package:retail_app_flutter/visit_plan/screens/visit_plan_screen.dart';

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

    case AccountList.routeName:
      AccountList accountList = routeSettings.arguments as AccountList;
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => AccountList(
            account_type_id: accountList.account_type_id,
            account_type: accountList.account_type)
      );

    case CreateAccountScreen.routeName:
      String account_type = routeSettings.arguments as String;
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => CreateAccountScreen(account_type: account_type)
      );

    case ConfirmLocationScreen.routeName:
      List<dynamic> args = routeSettings.arguments as List;
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => ConfirmLocationScreen(funKey: args[1], account_name: args[0], account_obj_id: args[2],)
      );

    case CameraScreen.routeName:
      List<dynamic> args = routeSettings.arguments as List;
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => CameraScreen(functionalityKey: args[0], account_name: args[1], account_obj_id: args[2])
      );

    case PendingDataScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => PendingDataScreen()
      );

    case ChangePasswordScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => ChangePasswordScreen()
      );

    case AccountMap.routeName:
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => AccountMap()
      );

    case GIftRedemptionScreen.routeName:
      MerchantModel merchant = routeSettings.arguments as MerchantModel;
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => GIftRedemptionScreen(
            merchant: merchant,
          )
      );

    case MerchantDetailScreen.routeName:
      MerchantModel merchant = routeSettings.arguments as MerchantModel;
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => MerchantDetailScreen(
            merchant: merchant
          )
      );

    case LoyaltyBottomBar.routeName:
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => LoyaltyBottomBar()
      );

    case TargetVsAchievementScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => TargetVsAchievementScreen()
      );

    case VisitPlanScreen.routeName:
      List<dynamic> args = routeSettings.arguments as List;

      if(args.length>1) {
        return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) =>
                VisitPlanScreen(showAccDialogue: args[0], dealer: args[1], direct: args[2], funKey: args[3],)
        );
      } else{
        return MaterialPageRoute(
              settings: routeSettings,
              builder: (_) =>
              VisitPlanScreen(showAccDialogue: args[0]));
  }

    case SubmitRemarksScreen.routeName:
      List<dynamic> args = routeSettings.arguments as List;
      int account_type_id = args[0] as int;

      if(account_type_id==1) {
        return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) =>
                SubmitRemarksScreen(account_type_id: account_type_id,
                    location_type: args[1], dealer: args[2])
        );
      } else{
        return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(
                child: Text("Page not found 404!"),
              ),
            ));
      }

    default:
      return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text("Page not found 404!"),
            ),
          ));
  }
}