import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retail_app_flutter/accounts/services/account_services.dart';
import 'package:retail_app_flutter/constants/custom_app_bar.dart';
import 'package:retail_app_flutter/constants/custom_text_formfield.dart';
import 'package:retail_app_flutter/constants/my_colors.dart';
import 'package:retail_app_flutter/constants/my_fonts.dart';
import 'package:retail_app_flutter/models/distributor_master.dart';
import 'package:retail_app_flutter/providers/distributor_master_provider.dart';
import '../../constants/custom_dropdown.dart';
import '../../models/employee.dart';
import '../../providers/user_provider.dart';

class CreateAccountScreen extends StatefulWidget {
  static const String routeName = '/create-account-screen';
  final String account_type;
  const CreateAccountScreen({super.key, required this.account_type});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {

  TextEditingController _accountNameController = TextEditingController();
  TextEditingController _mobileNumberController = TextEditingController();
  TextEditingController _contactPersonNameController = TextEditingController();
  TextEditingController _emailAddressController = TextEditingController();
  TextEditingController _subDealerCountController = TextEditingController();
  TextEditingController _counterPotential = TextEditingController();
  List<DistributorMaster> _distributor_master = [];
  List<DropdownMenuItem> distributorList = [];
  List<DropdownMenuItem> zoneList = [];
  List<DropdownMenuItem> stateList = [];
  List<DropdownMenuItem> districtList = [];
  List<DropdownMenuItem> blockList = [];
  List<Map<String, dynamic>> fetchedBlocks = [];
  final AccountServices accountServices = AccountServices();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _distributor_master = Provider
        .of<DistributorMasterProvider>(context, listen: false)
        .distributor_master;
    Employee emp = Provider.of<EmployeeProvider>(context, listen: false).employee;

    zoneList.add(DropdownMenuItem(value: emp.zone_id,child: Text(emp.zone_name)));

    for(int i=0; i<emp.state_id.length; i++){
      stateList.add(DropdownMenuItem(value: emp.state_id[i],child: Text(emp.state_names[i])));
    }

    for(int i=0; i<emp.district_id.length; i++){
      districtList.add(DropdownMenuItem(
          value: emp.district_id[i],
          child: Text(emp.district_names[i])));
    }

    for(int i=0; i<_distributor_master.length; i++){
      distributorList.add(DropdownMenuItem(value: _distributor_master[i].account_id, child: Text(_distributor_master[i].account_name)));
    }
  }

  void fetchBlocks(int district_id) async {
    fetchedBlocks = await accountServices.fetchBlocks(context: context, district_id: district_id,
        onSuccess: (){
      setState(() {});
    });

    for(int i=0; i<fetchedBlocks.length; i++){
      blockList.add(DropdownMenuItem(value: fetchedBlocks[i]['block_id'],child: Text(fetchedBlocks[i]['block_name'])));
    }


  }


  @override
  Widget build(BuildContext context) {

    Employee emp = Provider.of<EmployeeProvider>(context, listen: false).employee;



    return DefaultTabController(
      length: 3,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: CustomAppBar(
              module_name: 'Create ${widget.account_type} Account',
              emp_name: emp.emp_name,
            ),
        ),
        backgroundColor: MyColors.boneWhite,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Key Information:',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: MyFonts.poppins,
                      color: MyColors.blackColor
                  ),
                ),
                SizedBox(height: 10,),
          
                      CustomTextFormField(
                          height: 50,
                          width: 340,
                          controller: _accountNameController,
                          hintText: 'Name',
                          textFieldColor: MyColors.ashColor,
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontFamily: MyFonts.poppins,
                              color: MyColors.fadedBlack
                          ),
                          enteredTextStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontFamily: MyFonts.poppins,
                              color: MyColors.blackColor
                          ),
                          prefixIcon: Icon(Icons.person, color: MyColors.fadedBlack,size: 15,)
                      ),
                SizedBox(height: 10),
                CustomTextFormField(
                    height: 50,
                    width: 340,
                    keyBoardType: TextInputType.number,
                    controller: _mobileNumberController,
                    hintText: 'Mobile No.',
                    textFieldColor: MyColors.ashColor,
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontFamily: MyFonts.poppins,
                        color: MyColors.fadedBlack
                    ),
                    enteredTextStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontFamily: MyFonts.poppins,
                        color: MyColors.blackColor
                    ),
                    prefixIcon: Icon(Icons.phone, color: MyColors.fadedBlack,size: 15,)
                ),
                SizedBox(height: 10),
                CustomDropdown(
                  dropdownItems: distributorList,
                  dropdownIcon: Icon(Icons.arrow_drop_down),
                  height: 50,
                  width: 340,
                  hintText: 'Distributor',
                  hintTextWeight: FontWeight.w400,
                  hintTextSize: 15,
                  hintTextColor: MyColors.fadedBlack,
                  boxColor: MyColors.ashColor,
                  onSelect: (value){
                    print(value.toString());
                  },
                ),
                SizedBox(height: 10),
                CustomTextFormField(
                    height: 50,
                    width: 340,
                    controller: _contactPersonNameController,
                    hintText: 'Contact Person Name',
                    textFieldColor: MyColors.ashColor,
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontFamily: MyFonts.poppins,
                        color: MyColors.fadedBlack
                    ),
                    enteredTextStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontFamily: MyFonts.poppins,
                        color: MyColors.blackColor
                    ),
                    prefixIcon: Icon(Icons.person, color: MyColors.fadedBlack,size: 15,)
                ),
                SizedBox(height: 10),
                CustomTextFormField(
                    height: 50,
                    width: 340,
                    controller: _emailAddressController,
                    hintText: 'Email Id',
                    textFieldColor: MyColors.ashColor,
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontFamily: MyFonts.poppins,
                        color: MyColors.fadedBlack
                    ),
                    enteredTextStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontFamily: MyFonts.poppins,
                        color: MyColors.blackColor
                    ),
                    prefixIcon: Icon(Icons.email_rounded, color: MyColors.fadedBlack,size: 15,)
                ),
                SizedBox(height: 10),
                CustomTextFormField(
                    height: 50,
                    width: 340,
                    keyBoardType: TextInputType.number,
                    controller: _subDealerCountController,
                    hintText: 'Sub Dealer Count',
                    textFieldColor: MyColors.ashColor,
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontFamily: MyFonts.poppins,
                        color: MyColors.fadedBlack
                    ),
                    enteredTextStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontFamily: MyFonts.poppins,
                        color: MyColors.blackColor
                    ),
                    prefixIcon: Icon(Icons.people_alt, color: MyColors.fadedBlack,size: 15,)
                ),
                SizedBox(height: 10,),
                Text('KYC Details:',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: MyFonts.poppins,
                      color: MyColors.blackColor
                  ),
                ),
                SizedBox(height: 10,),
                CustomTextFormField(
                    height: 50,
                    width: 340,
                    keyBoardType: TextInputType.number,
                    controller: _counterPotential,
                    hintText: 'Counter Potential',
                    textFieldColor: MyColors.ashColor,
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontFamily: MyFonts.poppins,
                        color: MyColors.fadedBlack
                    ),
                    enteredTextStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontFamily: MyFonts.poppins,
                        color: MyColors.blackColor
                    ),
                    prefixIcon: Icon(Icons.add_chart_rounded, color: MyColors.fadedBlack,size: 15,)
                ),
                SizedBox(height: 10,),
                Text('Address Details:',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: MyFonts.poppins,
                      color: MyColors.blackColor
                  ),
                ),
                SizedBox(height: 10,),
                CustomDropdown(
                  dropdownItems: zoneList,
                  dropdownIcon: Icon(Icons.arrow_drop_down),
                  height: 50,
                  width: 340,
                  isDisabled: true,
                  disabledText: emp.zone_name,
                  hintText: 'Zone',
                  hintTextWeight: FontWeight.w400,
                  hintTextSize: 15,
                  hintTextColor: MyColors.fadedBlack,
                  boxColor: MyColors.ashColor,
                  onSelect: (value){
                    print(value.toString());
                  },
                ),
                SizedBox(height: 10,),
                CustomDropdown(
                  dropdownItems: stateList,
                  dropdownIcon: Icon(Icons.arrow_drop_down),
                  height: 50,
                  width: 340,
                  isDisabled: emp.state_id.length==1 ? true : false,
                  disabledText: emp.state_names[0],
                  hintText: 'State',
                  hintTextWeight: FontWeight.w400,
                  hintTextSize: 15,
                  hintTextColor: MyColors.fadedBlack,
                  boxColor: MyColors.ashColor,
                  onSelect: (value){
                    print(value.toString());
                  },
                ),
                SizedBox(height: 10),
                CustomDropdown(
                  dropdownItems: districtList,
                  dropdownIcon: const Icon(Icons.arrow_drop_down),
                  height: 50,
                  width: 340,
                  isDisabled: emp.district_id.length==1 ? true : false,
                  disabledText: emp.district_names[0],
                  hintText: 'District',
                  hintTextWeight: FontWeight.w400,
                  hintTextSize: 15,
                  hintTextColor: MyColors.fadedBlack,
                  boxColor: MyColors.ashColor,
                  onSelect: (value){
                    print(value.toString());
                    fetchBlocks(value);
                  },
                ),
                const SizedBox(height: 10,),
                CustomDropdown(
                  dropdownItems: blockList,
                  dropdownIcon: const Icon(Icons.arrow_drop_down),
                  height: 50,
                  width: 340,
                  hintText: 'Block',
                  hintTextWeight: FontWeight.w400,
                  hintTextSize: 15,
                  hintTextColor: MyColors.fadedBlack,
                  boxColor: MyColors.ashColor,
                  onSelect: (value){
                    print(value.toString());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
