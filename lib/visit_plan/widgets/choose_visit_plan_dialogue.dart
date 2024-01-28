import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retail_app_flutter/constants/custom_dropdown.dart';
import 'package:retail_app_flutter/constants/custom_dropdown_two.dart';
import 'package:retail_app_flutter/constants/global_variables.dart';
import 'package:retail_app_flutter/constants/my_colors.dart';

import '../../models/dealer_master.dart';
import '../../models/distributor_master.dart';
import '../../models/employee.dart';
import '../../models/engineer_master.dart';
import '../../providers/distributor_master_provider.dart';
import '../../providers/user_provider.dart';

class ChooseVisitPlanAccountsDialogue extends StatefulWidget {
  const ChooseVisitPlanAccountsDialogue({super.key});

  @override
  State<ChooseVisitPlanAccountsDialogue> createState() => _ChooseVisitPlanAccountsDialogueState();
}

class _ChooseVisitPlanAccountsDialogueState extends State<ChooseVisitPlanAccountsDialogue> {

  List<DealerMaster> _dealer_master = [];
  List<DistributorMaster> _distributor_master = [];
  List<EngineerMaster> _engineer_master = [];
  List<DropdownMenuItem<int>> stateList = [];
  List<DropdownMenuItem> districtList = [];
  List<DropdownMenuItem> accountTypeList = [];
  bool isStateSelected = false;
  bool isDistrictSelected = false;
  bool isAccountTypeSelected = false;
  int selectedState = 0;
  int selectedDistrict = 0;
  int selectedAccountType = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _distributor_master = Provider
        .of<DistributorMasterProvider>(context, listen: false)
        .distributor_master;
    Employee emp = Provider.of<EmployeeProvider>(context, listen: false).employee;

    for(int i=0; i<emp.state_id.length; i++){
      stateList.add(DropdownMenuItem(
          value: emp.state_id[i],
          child: Text(emp.state_names[i])));
    }

    // for(int i=0; i<emp.district_id.length; i++){
    //   districtList.add(DropdownMenuItem(
    //       value: emp.district_id[i],
    //       child: Text(emp.district_names[i])));
    // }
    //
    // for(int i=0; i<account_type.length; i++){
    //   accountTypeList.add(DropdownMenuItem(
    //       value: account_type[i]['account_type_id'],
    //       child: Text(account_type[i]['account_type'])));
    // }
  }

  onStateChanged(dynamic value) {
    //dont change second dropdown if 1st item didnt change
    if(value>0){
      setState(() {
        selectedState = value;
      });
    }
  }

  final List<String> audiMake = [
    'A3',
    'A4',
  ];
  final List<String> bmwMake = [
    '1 Series',
    '2 Series',
  ];

  String? selectedCardModel;
  String? selectedMake;

  late Map<String, List<String>> dataset = {
    'Audi': audiMake,
    'BMW': bmwMake,
  };

  onCarModelChanged(String? value) {
    //dont change second dropdown if 1st item didnt change
    if (value != selectedCardModel) selectedMake = null;
    setState(() {
      selectedCardModel = value;
    });
  }

  @override
  Widget build(BuildContext context) {

    Employee emp = Provider.of<EmployeeProvider>(context, listen: false).employee;

    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Dialog(
        alignment: Alignment.topCenter,
        child: Container(
          height: 400,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: MyColors.boneWhite
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              CustomDropdown(
                  dropdownItems: stateList,
                  dropdownIcon: Icon(Icons.arrow_drop_down),
                  height: 35,
                  width: 250,
                  isDisabled: selectedState==0 ? false : false,
                  disabledText: 'Select State',
                  boxColor: MyColors.ashColor,
                  hintText: 'State',
                  hintTextColor: MyColors.fadedBlack,
                  hintTextWeight: FontWeight.w500,
                  hintTextSize: 15,
                  onSelect: (value){
                    print(value);

                  }
              ),
              SizedBox(height: 10),
              CustomDropdown(
                  dropdownItems: districtList,
                  dropdownIcon: Icon(Icons.arrow_drop_down),
                  height: 35,
                  width: 250,
                  isDisabled: selectedState==0 ? false : false,
                  disabledText: 'Select District',
                  boxColor: MyColors.ashColor,
                  hintText: 'District',
                  hintTextColor: MyColors.fadedBlack,
                  hintTextWeight: FontWeight.w500,
                  hintTextSize: 15,
                  onSelect: (value){
                    print(value);
                    selectedDistrict=value;

                  }
              ),
              SizedBox(height: 10),
              CustomDropdown(
                  dropdownItems: accountTypeList,
                  dropdownIcon: Icon(Icons.arrow_drop_down),
                  height: 35,
                  width: 250,
                  isDisabled: selectedDistrict==0 ? false : false,
                  disabledText: 'Select Account Type',
                  boxColor: MyColors.ashColor,
                  hintText: 'Account Type',
                  hintTextColor: MyColors.fadedBlack,
                  hintTextWeight: FontWeight.w500,
                  hintTextSize: 15,
                  onSelect: print
              ),

            ],
          ),
        ),
      ),
    );
  }
}
