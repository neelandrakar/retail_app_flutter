import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:retail_app_flutter/constants/assets_constants.dart';
import 'package:retail_app_flutter/constants/global_variables.dart';
import 'package:retail_app_flutter/constants/my_colors.dart';
import 'package:retail_app_flutter/constants/utils.dart';
import 'package:retail_app_flutter/providers/dashboard_menu_provider.dart';

import '../../models/dashboard_menu.dart';
import '../../models/employee.dart';
import '../../providers/user_provider.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {

  List<DashboardMenu> sideBarMenu = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var allMenus = Provider.of<DashboardMenuProvider>(context, listen: false).dashboardMenus;

    for(int i=0; i<allMenus.length; i++){
      if(allMenus[i].menu_type==2){
        sideBarMenu.add(allMenus[i]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    Employee emp = Provider.of<EmployeeProvider>(context, listen: false).employee;


    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            height: double.infinity,
            width: 288,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: MyColors.appBarColor,
              borderRadius: BorderRadius.circular(25)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 288,
                  height: 120,
                  decoration: BoxDecoration(
                    //image: DecorationImage(image: AssetImage(AssetsConstants.side_bar_profile_box), scale: 1),
                    // color: Colors.red
                  ),
                  child:
                      Stack(
                            children: [
                              Positioned(
                                top: 0,
                                right: 1,
                                child: GestureDetector(
                                  onTap: (){
                                    print('close');
                                    Navigator.pop(context);
                                  },
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text('Close',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              color: MyColors.actionsButtonColor,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400
                                          ),
                                        ),
                                        SizedBox(width: 2),
                                        Image.asset(AssetsConstants.side_bar_back_button, height: 20,width: 20,)
        
                                      ],
                                    ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Row(
                                  children: [
        
                                    Stack(
                                      children: [
                                        Container(
                                          width: 55,
                                          height: 55,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: MyColors.actionsButtonColor
                                          ),
                                          padding: EdgeInsets.all(1),
                                          child: CircleAvatar(
                                            foregroundImage: getProfilePic(context),
                                          ),
                                        ),
                                        Positioned(
                                            right: 0,
                                            bottom: 0,
                                            child: Image.asset(AssetsConstants.side_bar_cam, height: 20,width: 20)
                                        )
                                      ],
                                    ),
                                    SizedBox(width: 10),
                                    Container(
                                      width: 160,
                                      height: 50,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(emp.emp_name,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontFamily: 'Poppins',
                                                color: MyColors.boneWhite,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500
                                            ),
                                          ),
                                          Text(
                                            getDesignation(context),
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontFamily: 'Poppins',
                                                color: MyColors.actionsButtonColor,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w400
                                            ),
                                          ),
                                          Text(
                                            'v1.0.0',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontFamily: 'Poppins',
                                                color: MyColors.actionsButtonColor,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w400
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                      )
                ),
                Divider(
                  height: 0,
                  thickness: 0.5,
                  color: MyColors.actionsButtonColor,
                ),
                Expanded(
                    child: ListView.builder(
                        itemCount: 3,
                        itemBuilder: (context,index){
                          print('hello ${sideBarMenu.length}');
                          return Text('Hola $index', style: TextStyle(color: MyColors.boneWhite),);
                        }
                    )
                )
              ],
            ),
          ),
      ),
    );
  }
}
