import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:retail_app_flutter/constants/custom_app_bar.dart';
import 'package:retail_app_flutter/constants/my_colors.dart';
import 'package:retail_app_flutter/constants/odometer_text_field.dart';
import 'package:retail_app_flutter/home/screens/liftings_screen.dart';
import 'package:retail_app_flutter/home/screens/menu_screen.dart';
import 'package:retail_app_flutter/home/screens/visits_screen.dart';
import 'package:retail_app_flutter/home/services/home_services.dart';
import 'package:retail_app_flutter/home/widgets/home_menu_radio_button.dart';
import 'package:retail_app_flutter/models/dashboard_menu.dart';

import '../../models/employee.dart';
import '../../providers/user_provider.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home-one';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedBar = 1;




  @override
  Widget build(BuildContext context) {


    Employee emp = Provider.of<EmployeeProvider>(context, listen: false).employee;
    TextEditingController _wildCardSearch = TextEditingController();

    void setBarType(int barIndex){

      selectedBar = barIndex;
      setState(() {});
      print(selectedBar);
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
          backgroundColor: MyColors.boneWhite,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(190),
            child: CustomAppBar(
              module_name: 'Dashboard',
              emp_name: emp.emp_name,
              show_back_button: false,
              actions: [
                Icon(Icons.live_help_outlined, color: MyColors.actionsButtonColor,size: 18,),
                SizedBox(width: 10,),
                Icon(Icons.notifications, color: MyColors.actionsButtonColor,size: 18,),
                SizedBox(width: 10,),
              ],
              leading: Icon(Icons.menu_outlined, color: MyColors.actionsButtonColor,size: 20,),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(100),
                child: Container(
                  color: MyColors.boneWhite,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      OdometerTextField(controller: _wildCardSearch, hintText: 'Search anything'),
                      SizedBox(height: 20,),

                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: MyColors.topNavigationBarUnselected,

                        ),
                        child: TabBar(

                          indicator: BoxDecoration(
                            color: MyColors.topNavigationBarSelected,
                            borderRadius: BorderRadius.circular(20)
                          ),
                          labelColor: MyColors.appBarColor,
                          // unselectedLabelColor: MyColors.topNavigationBarSelected,
                          tabs: [
                            HomeMenuRadioButton(
                              bar_name: "Menus",
                            ),
                            HomeMenuRadioButton(
                              bar_name: "Visits",
                            ),
                            HomeMenuRadioButton(
                              bar_name: "Liftings",
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ),

          body: TabBarView(
            children: [
              MenuScreen(),
              VisitsScreen(),
              LiftingsScreen(),
            ],
          ),
      ),
    );
  }
}
