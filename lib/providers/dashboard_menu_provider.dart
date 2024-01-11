import 'package:flutter/cupertino.dart';
import 'package:retail_app_flutter/models/dashboard_menu.dart';

class DashboardMenuProvider extends ChangeNotifier{

  List<DashboardMenu> dashboardMenus = [];


  void addDashboardMenu(DashboardMenu dashboardMenu){
    dashboardMenus.add(dashboardMenu);
    notifyListeners();
  }

  void removeDashboardMenu(DashboardMenu dashboardMenu){
    dashboardMenus.remove(dashboardMenu);
    notifyListeners();
  }

}