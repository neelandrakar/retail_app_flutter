import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:retail_app_flutter/accounts/screens/account_list.dart';
import 'package:retail_app_flutter/accounts/widgets/primary_account_box.dart';
import 'package:retail_app_flutter/accounts/widgets/secondary_account_box.dart';
import 'package:retail_app_flutter/constants/assets_constants.dart';
import 'package:retail_app_flutter/constants/custom_app_bar.dart';
import 'package:retail_app_flutter/constants/my_colors.dart';
import 'package:retail_app_flutter/constants/my_fonts.dart';

import '../../models/employee.dart';
import '../../providers/user_provider.dart';

class Accounts extends StatefulWidget {
  static const String routeName = '/accounts-screen';
  const Accounts({super.key});

  @override
  State<Accounts> createState() => _AccountsState();
}

class _AccountsState extends State<Accounts>{

  List<Map<String, String>> secondaryAccounts = [
    {
      "acc_title": "Engineer",
      "acc_subtitle": "Click here to see all tagged engineers.",
      "acc_image": AssetsConstants.engineer_menu_icon,
    },
    {
      "acc_title": "Mason",
      "acc_subtitle": "Click here to see all tagged masons.",
      "acc_image": AssetsConstants.mason_menu_icon,
    },
    {
      "acc_title": "Petty Contractor",
      "acc_subtitle": "Click here to see all tagged petty contractors.",
      "acc_image": AssetsConstants.petty_con_menu_icon,
    },
    {
      "acc_title": "IHB Owner",
      "acc_subtitle": "Click here to see all tagged IHB Owners.",
      "acc_image": AssetsConstants.ihb_owner_menu_icon,
    },
    {
      "acc_title": "Branches",
      "acc_subtitle": "Click here to see all branches.",
      "acc_image": AssetsConstants.distributor_menu_icon,
    },
  ];


  void navigateToAccountList(int account_type_id, String account_type){

    final arguments = AccountList(account_type_id: account_type_id, account_type: account_type,);

    Navigator.pushNamed(context, AccountList.routeName, arguments: arguments);
  }

  @override
  Widget build(BuildContext context) {



    Employee emp = Provider.of<EmployeeProvider>(context, listen: false).employee;

    return Scaffold(
      backgroundColor: MyColors.boneWhite,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: CustomAppBar(
            module_name: 'Accounts',
            emp_name: emp.emp_name,
            actions: [
              Icon(Icons.person_add_outlined, color: MyColors.actionsButtonColor,size: 18,),
              SizedBox(width: 10,)
            ],
          )),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 210,
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
            decoration: BoxDecoration(
              // color: MyColors.appBarColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Primary Accounts',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: MyFonts.poppins,
                    color: MyColors.blackColor
                  ),
                ),
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PrimaryAccountBox(
                        index: 0,
                        box_name: 'Dealer',
                        box_subtitle: 'Look at all the dealers tagged with you',
                        onClick: (){
                          print('dealer');
                          navigateToAccountList(1, 'Dealer');
                        },
                    ),
                    // SizedBox(width: 5,),
                    PrimaryAccountBox(
                        index: 1,
                        box_name: 'Distributor',
                        box_subtitle: 'Look at all the distributor tagged with you',
                        onClick: (){},
                    ),
                    // SizedBox(width: 5,),
                    PrimaryAccountBox(
                        index: 2,
                        box_name: 'Sub-Dealer',
                        box_subtitle: 'Look at all the subdealer tagged with you',
                        onClick: (){},

                    ),
                  ],
                ),
              ],
            ),
          ),
          // SizedBox(height: 20,),
          Divider(height: 2,color: MyColors.black12,thickness: 3,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10).copyWith(top: 20,bottom: 15),
            child: Text('Secondary Accounts',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: MyFonts.poppins,
                  color: MyColors.blackColor
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: ListView.separated(
                  itemCount: secondaryAccounts.length,
                  itemBuilder: (context, index) {

                    return SecondaryAccountBox(
                      box_image: secondaryAccounts[index]['acc_image'],
                      box_title: secondaryAccounts[index]['acc_title'],
                      box_subtitle: secondaryAccounts[index]['acc_subtitle'],
                    );
                  },
                separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(height: 10,);
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
