import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:retail_app_flutter/accounts/screens/target_vs_achievement_screen.dart';
import 'package:retail_app_flutter/accounts/widgets/account_summary_widget.dart';
import 'package:retail_app_flutter/accounts/widgets/dealer_info_card.dart';
import 'package:retail_app_flutter/constants/assets_constants.dart';
import 'package:retail_app_flutter/constants/custom_button_two.dart';
import 'package:retail_app_flutter/constants/custom_dropdown.dart';
import 'package:retail_app_flutter/constants/custom_search_field.dart';
import 'package:retail_app_flutter/constants/global_variables.dart';
import 'package:retail_app_flutter/constants/my_colors.dart';
import 'package:retail_app_flutter/constants/my_fonts.dart';
import 'package:retail_app_flutter/models/dealer_master.dart';
import 'package:retail_app_flutter/models/distributor_master.dart';
import 'package:retail_app_flutter/models/engineer_master.dart';
import 'package:retail_app_flutter/providers/dealer_master_provider.dart';
import 'package:retail_app_flutter/providers/distributor_master_provider.dart';
import 'package:retail_app_flutter/providers/engineer_master_provider.dart';

import '../../constants/custom_app_bar.dart';
import '../../constants/custom_elevated_button.dart';
import '../../models/employee.dart';
import '../../providers/user_provider.dart';
import '../widgets/account_info_card.dart';

class AccountList extends StatefulWidget {
  static const String routeName = '/accounts-list';
  final int account_type_id;
  final String account_type;
  const AccountList({super.key, required this.account_type_id, required this.account_type});

  @override
  State<AccountList> createState() => _AccountListState();
}

class _AccountListState extends State<AccountList> {

  List<DealerMaster> _dealer_master = [];
  List<DistributorMaster> _distributor_master = [];
  List<EngineerMaster> _engineer_master = [];
  int activeCount = 0;
  int inactiveCount = 0;
  int prospectiveCount = 0;
  int surveyCount = 0;
  bool searchEnabled = false;
  TextEditingController _searchController = TextEditingController();
  String defaultDistrictDropdownValue = '';

  @override
  void dispose() {

    super.dispose();
    searchEnabled = false;
  }

  @override
  void initState() {
    super.initState();
    _dealer_master = Provider
        .of<DealerMasterProvider>(context, listen: false)
        .dealer_master;
    _distributor_master = Provider
        .of<DistributorMasterProvider>(context, listen: false)
        .distributor_master;

    _engineer_master = Provider
        .of<EngineerMasterProvider>(context, listen: false)
        .engineer_master;

    if (widget.account_type_id == 1) {

      for (int i = 0; i < _dealer_master.length; i++) {
        if (_dealer_master[i].account_status == 'Active SSIL') {
          activeCount += 1;
        } else if (_dealer_master[i].account_status == 'Inactive') {
          inactiveCount += 1;
        } else if (_dealer_master[i].account_status == 'Prospective') {
          prospectiveCount += 1;
        } else if (_dealer_master[i].account_status == 'Survey') {
          surveyCount += 1;
        }
      }
    } else if(widget.account_type_id==7){

      for (int i = 0; i < _distributor_master.length; i++) {
        if (_distributor_master[i].account_status == 'Active SSIL') {
          activeCount += 1;
        } else if (_distributor_master[i].account_status == 'Inactive') {
          inactiveCount += 1;
        } else if (_distributor_master[i].account_status == 'Prospective') {
          prospectiveCount += 1;
        } else if (_distributor_master[i].account_status == 'Survey') {
          surveyCount += 1;
        }
      }
    } else if(widget.account_type_id==6){

      for (int i = 0; i < _engineer_master.length; i++) {
        if (_engineer_master[i].account_status == 'Active SSIL') {
          activeCount += 1;
        } else if (_engineer_master[i].account_status == 'Inactive') {
          inactiveCount += 1;
        } else if (_engineer_master[i].account_status == 'Prospective') {
          prospectiveCount += 1;
        } else if (_engineer_master[i].account_status == 'Survey') {
          surveyCount += 1;
        }
      }
    }
  }

  void _runFilter(String enteredKeyword) {
    if(widget.account_type_id==1) {
      _dealer_master = Provider
          .of<DealerMasterProvider>(context, listen: false)
          .dealer_master;
      if (enteredKeyword.isEmpty) {
        // if the search field is empty or only contains white-space, we'll display all users
        _dealer_master = _dealer_master;
      } else {
        _dealer_master = _dealer_master
            .where((i) =>
            i.account_name.toLowerCase().contains(enteredKeyword.toLowerCase()))
            .toList();
        // we use the toLowerCase() method to make it case-insensitive
      }
    } else if(widget.account_type_id==7){
      _distributor_master = Provider
          .of<DistributorMasterProvider>(context, listen: false)
          .distributor_master;
      if (enteredKeyword.isEmpty) {
        // if the search field is empty or only contains white-space, we'll display all users
        _distributor_master = _distributor_master;
      } else {
        _distributor_master = _distributor_master
            .where((i) =>
            i.account_name.toLowerCase().contains(enteredKeyword.toLowerCase()))
            .toList();
        // we use the toLowerCase() method to make it case-insensitive
      }
    }
  }

  void _runFilterWithDistrict(String enteredKeyword) {
    if(widget.account_type_id==1) {
      _dealer_master = Provider
          .of<DealerMasterProvider>(context, listen: false)
          .dealer_master;
      if (enteredKeyword.isEmpty) {
        // if the search field is empty or only contains white-space, we'll display all users
        _dealer_master = _dealer_master;
      } else {
        _dealer_master = _dealer_master
            .where((i) =>
            i.district_names[0].toLowerCase().contains(
                enteredKeyword.toLowerCase()))
            .toList();
        setState(() {});
        // we use the any method here, which returns true if at least one element in the list satisfies the condition
      }
    }else if(widget.account_type_id==7){
      _distributor_master = Provider
          .of<DistributorMasterProvider>(context, listen: false)
          .distributor_master;
      if (enteredKeyword.isEmpty) {
        // if the search field is empty or only contains white-space, we'll display all users
        _distributor_master = _distributor_master;
      } else {
        _distributor_master = _distributor_master
            .where((i) =>
            i.district_names[0].toLowerCase().contains(
                enteredKeyword.toLowerCase()))
            .toList();
        setState(() {});
        // we use the any method here, which returns true if at least one element in the list satisfies the condition
      }
    }
    }

    void _runFilterWithAccountStatus(String enteredKeyword) {
    if(widget.account_type_id==1) {
      _dealer_master = Provider
          .of<DealerMasterProvider>(context, listen: false)
          .dealer_master;
      if (enteredKeyword.isEmpty) {
        // if the search field is empty or only contains white-space, we'll display all users
        _dealer_master = _dealer_master;
      } else {
        _dealer_master = _dealer_master
            .where((i) =>
            i.account_status.toLowerCase().contains(
                enteredKeyword.toLowerCase()))
            .toList();
        setState(() {});
        // we use the any method here, which returns true if at least one element in the list satisfies the condition
      }
    } else if(widget.account_type_id==7){
      _distributor_master = Provider.of<DistributorMasterProvider>(context, listen: false).distributor_master;
      if (enteredKeyword.isEmpty) {
        // if the search field is empty or only contains white-space, we'll display all users
        _distributor_master = _distributor_master;
      } else {
        _distributor_master = _distributor_master
            .where((i) =>
            i.account_status.toLowerCase().contains(enteredKeyword.toLowerCase()))
            .toList();
        setState(() {});
        // we use the any method here, which returns true if at least one element in the list satisfies the condition
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    Employee emp = Provider.of<EmployeeProvider>(context, listen: false).employee;
    int totalCount = activeCount+inactiveCount+prospectiveCount+surveyCount;

    return Scaffold(
      backgroundColor: MyColors.appBarColor,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: CustomAppBar(
            module_name: '${widget.account_type} Accounts',
            emp_name: emp.emp_name,
            actions: [
              GestureDetector(
                onTap: (){
                  print('open rule');
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info,
                      color: MyColors.actionsButtonColor,
                      size: 18,),
                    Text('Rules',
                      style: TextStyle(
                        color: MyColors.actionsButtonColor,
                        fontFamily: MyFonts.poppins,
                        fontSize: 10
                      )
                    )
                  ],
                ),
              ),
              SizedBox(width: 10,)
            ],
          )),
      body: Column(
        children: [
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AssetsConstants.account_summary_purple_box, width: 18,height: 18,),
              SizedBox(width: 6),
              Text(
                "Total ${widget.account_type}'s Summary",
                style: TextStyle(
                  color: MyColors.boneWhite,
                  fontFamily: MyFonts.poppins,
                  fontWeight: FontWeight.w500
                ),
              )
            ],
          ),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              decoration: BoxDecoration(
                color: MyColors.boneWhite,
                borderRadius: BorderRadius.circular(10)
              ),
              height: 60,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AccountSummaryWidget(
                      account_status: 'Active SSIL',
                      account_count: activeCount,
                      account_count_color: MyColors.greenColor
                  ),
                  AccountSummaryWidget(
                      account_status: 'Inactive',
                      account_count: inactiveCount,
                      account_count_color: MyColors.redColor
                  ),
                  AccountSummaryWidget(
                      account_status: 'Prospective',
                      account_count: prospectiveCount,
                      account_count_color: MyColors.blueColor
                  ),
                  AccountSummaryWidget(
                      account_status: 'Survey',
                      account_count: surveyCount,
                      account_count_color: MyColors.orangeColor
                  ),
                  AccountSummaryWidget(
                      account_status: 'Total',
                      account_count: totalCount,
                      account_count_color: MyColors.blackColor,
                      isLast: true,
                  )
                ],
              )
            ),
          ),
          if(widget.account_type_id==1)
          SizedBox(height: 15,),
          if(widget.account_type_id==1)
            Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: CustomElevatedButton(
                buttonText: 'View Target v/s Achievement',
                textSize: 14,
                buttonColor: MyColors.purpleColor,
                buttonTextColor: MyColors.boneWhite,
                height: 40,
                onClick: (){
                  print('view target');
                  Navigator.pushNamed(context, TargetVsAchievementScreen.routeName);
                }
            ),
          ),
          SizedBox(height: 25,),
          Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  ),
                  color: MyColors.boneWhite
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 3,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 130.0),
                      child: Divider(
                        color: MyColors.ashColor,
                        thickness: 3,
                      ),
                    ),
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomDropdown(
                            dropdownItems: emp.state_names.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            dropdownIcon: Icon(Icons.arrow_drop_down),
                            height: 35,
                            width: 100,
                            hintText: 'State',
                            hintTextWeight: FontWeight.w400,
                            hintTextSize: 10,
                            hintTextColor: MyColors.fadedBlack,
                            boxColor: MyColors.ashColor,
                            onSelect: print,
                          ),
                          CustomDropdown(
                            dropdownItems: emp.district_names.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            dropdownIcon: Icon(Icons.arrow_drop_down),
                            height: 35,
                            width: 100,
                            hintText: 'District',
                            hintTextWeight: FontWeight.w400,
                            hintTextSize: 10,
                            hintTextColor: MyColors.fadedBlack,
                            boxColor: MyColors.ashColor,
                            onSelect: (value){

                              _runFilterWithDistrict(value);
                            },

                          ),
                          CustomDropdown(
                            dropdownItems: account_status.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            dropdownIcon: Icon(Icons.arrow_drop_down),
                            height: 35,
                            width: 100,
                            hintText: 'Status',
                            hintTextWeight: FontWeight.w400,
                            hintTextSize: 10,
                            hintTextColor: MyColors.fadedBlack,
                            boxColor: MyColors.ashColor,
                            onSelect: (value){
                              _runFilterWithAccountStatus(value);
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:20.0),
                      child: Row(
                        children: [
                          CustomSearchField(
                                  height: 45,
                                  width: 220,
                                  controller: _searchController,
                                  hintText: 'Search by name/mobile no.',
                                  searchFieldColor: MyColors.ashColor,
                                  hintTextWeight: FontWeight.w400,
                                  hintTextSize: 13,
                                  hintTextColor: MyColors.fadedBlack,
                                  maxLength: 30,
                                  textColor: MyColors.blackColor,
                                  textInputType: TextInputType.text,
                              ),
                          SizedBox(width: 10,),
                          CustomButtonTwo(
                              height: 45,
                              width: 80,
                              buttonColor: MyColors.deepBlueColor,
                              borderRadius: 30,
                              button_text: 'Search',
                              text_color: MyColors.boneWhite,
                              button_text_size: 13,
                              onClick: (){
                                _runFilter(_searchController.text);

                                setState(() {});
                              }
                          )

                        ],
                      ),
                    ),
                    if(widget.account_type_id!=1)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10,),
                            Text(
                              'Tagged ${widget.account_type} Accounts:',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  color: MyColors.blackColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  fontFamily: MyFonts.poppins),
                            ),                          ],
                        ),
                      ),
                    if(widget.account_type_id==1)
                    DealerCard(),
                    if(widget.account_type_id==7)
                      AccountCard(widget.account_type_id),
                    if(widget.account_type_id==6)
                      AccountCard(widget.account_type_id),
                  ],
                ),
              )
          )
        ],
      ),
    );
  }

  Expanded DealerCard() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0).copyWith(top: 20),
        child: _dealer_master.isNotEmpty ? ListView.separated(
          itemCount: _dealer_master.length,
          itemBuilder: (context, index) {
            return DealerInfoCard(
                dealerMaster: _dealer_master[index]
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(height: 20);
          },
        ) : Center(
          child: Text(
              'No ${widget.account_type} found'
          ),
        ),
      ),
    );
  }


  Widget AccountCard(int _account_type) {

    if(_account_type==7) {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0).copyWith(
              top: 10),
          child: _distributor_master.isNotEmpty ? ListView.separated(
            itemCount: _distributor_master.length,
            itemBuilder: (context, index) {
              return AccountInfoCard(
                distributor_master: _distributor_master[index],
                account_type_id: _account_type,
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(height: 20);
            },
          ) : Center(
            child: Text(
                'No ${widget.account_type} found'
            ),
          ),
        ),
      );
    } else if(_account_type==6){
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0).copyWith(
              top: 10),
          child: _engineer_master.isNotEmpty ? ListView.separated(
            itemCount: _engineer_master.length,
            itemBuilder: (context, index) {
              return AccountInfoCard(
                engineer_master: _engineer_master[index],
                account_type_id: _account_type,
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(height: 20);
            },
          ) : Center(
            child: Text(
                'No ${widget.account_type} found'
            ),
          ),
        ),
      );
    } else {
      return Text('404 Not Found');
    }
  }
}

