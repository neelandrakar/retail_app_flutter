import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retail_app_flutter/accounts/screens/accounts_screen.dart';
import 'package:retail_app_flutter/constants/my_colors.dart';
import 'package:retail_app_flutter/home/widgets/menu_card.dart';

import '../../models/dashboard_menu.dart';
import '../../models/employee.dart';
import '../../providers/dashboard_menu_provider.dart';
import '../../providers/user_provider.dart';
import '../services/home_services.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {

  final HomeServices homeServices = HomeServices();
  // List<DashboardMenu> dashboardMenus = [];

  fetchAllDashboardMenus() async {

    homeServices.fetchDashboardMenus(
        context: context,
        onSuccess: (){
          print('success!');
          setState(() {});
        });

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchAllDashboardMenus();
    });

    //print(allFetchedTweets.toString());
  }

  void navigations(int index){

    if(index==0){
      Navigator.pushNamed(context, Accounts.routeName);
    } else if(index==1){
      print('Navigate to order screen');
    }

  }

  @override
  Widget build(BuildContext context) {

    var dashboardMenus = Provider.of<DashboardMenuProvider>(context, listen: false).dashboardMenus;


    return Scaffold(
      backgroundColor: MyColors.boneWhite,
      body: GridView.count(
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        crossAxisCount: 2,
        // Generate 100 widgets that display their index in the List.
        children: List.generate(dashboardMenus.length, (i) {
          return Column(
            children: [
              SizedBox(height: 10,),
              MenuCard(
                  menu_icon: dashboardMenus[i].menu_image,
                  menu_name: dashboardMenus[i].menu_title,
                  onClick: (){
                    navigations(i);
                  },
              ),
            ],
          );
        }),
      ),
    );
  }
}
