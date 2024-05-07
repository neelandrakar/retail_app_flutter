import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:retail_app_flutter/accounts/services/account_services.dart';
import 'package:retail_app_flutter/accounts/widgets/data_column_item.dart';
import 'package:retail_app_flutter/constants/custom_elevated_button.dart';
import 'package:retail_app_flutter/models/dealer_target_achievement_model.dart';
import 'package:retail_app_flutter/providers/dealer_target_achievement_provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../constants/assets_constants.dart';
import '../../constants/custom_app_bar.dart';
import '../../constants/custom_button_two.dart';
import '../../constants/custom_dropdown.dart';
import '../../constants/custom_search_field.dart';
import '../../constants/global_variables.dart';
import '../../constants/my_colors.dart';
import '../../constants/my_fonts.dart';
import '../../constants/utils.dart';
import '../../models/employee.dart';
import '../../providers/user_provider.dart';
import '../widgets/account_summary_widget.dart';
import '../widgets/dealer_target_data_grid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class TargetVsAchievementScreen extends StatefulWidget {
  static const String routeName = '/target-vs-achievement';
  const TargetVsAchievementScreen({super.key});

  @override
  State<TargetVsAchievementScreen> createState() => _TargetVsAchievementScreenState();
}

class _TargetVsAchievementScreenState extends State<TargetVsAchievementScreen> {

  final AccountServices accountServices = AccountServices();
  bool fullyLoaded = false;
  late Future<void> _getDealersTarget;
  late DealerTargetAchievementModel dealerTargetAchievement;
  int active_dealer_targetted = 0;
  int inactive_dealer_targetted = 0;
  int prospective_dealer_targetted = 0;
  int active_billed = 0;
  int inactive_billed = 0;
  int prospective_billed = 0;
  int survey_billed = 0;
  int total_billed = 0;
  late Employee emp;
  TextEditingController _searchController = TextEditingController();
  bool editing_mode = false;
  late DealerTargetDataSource dealerTargetDataSource;


  void changeToEditingMode(){

    setState(() {
      if(editing_mode){
        editing_mode = false;
      } else{
        editing_mode = true;
      }
    });
  }

  void _runFilter(String enteredKeyword, VoidCallback onSuccess) {

      dealerTargetAchievement = Provider.of<DealerTargetAchievementProvider>(context, listen: false).dealerTargetAchievementModel;

      if (enteredKeyword.isEmpty) {
        // if the search field is empty or only contains white-space, we'll display all users
        dealerTargetAchievement = dealerTargetAchievement;
      } else {
        dealerTargetAchievement.target_data
            .where((i) =>
            i.dealer_name.toLowerCase().contains(enteredKeyword.toLowerCase()))
            .toList();

        // we use the toLowerCase() method to make it case-insensitive
      }

      onSuccess.call();
  }

  fetchDealersTarget(VoidCallback onSuccess) async {

    await accountServices.fetchDealerTarget(context: context, onSuccess: (){
      print('target is fetched!!!!');
      setState(() {
        fullyLoaded = true;
        dealerTargetAchievement = Provider.of<DealerTargetAchievementProvider>(context, listen: false).dealerTargetAchievementModel;

        //Setting threshold value
        for(int i=0; i<dealerTargetAchievement.target_data.length; i++){
          if(dealerTargetAchievement.target_data[i].initial_status=='Active SSIL'){
            active_dealer_targetted++;
          } else if(dealerTargetAchievement.target_data[i].initial_status=='Inactive'){
            inactive_dealer_targetted++;
          } else if
            (dealerTargetAchievement.target_data[i].initial_status=='Prospective' || dealerTargetAchievement.target_data[i].initial_status=='Survey'){
              prospective_dealer_targetted++;
            }
        }

        //Setting account billed value
        for(int i=0; i<dealerTargetAchievement.target_data.length; i++) {
          if (dealerTargetAchievement.target_data[i].cm_achievement > 0) {
            if (dealerTargetAchievement.target_data[i].initial_status ==
                'Active SSIL') {
              active_billed++;
            } else if (dealerTargetAchievement.target_data[i].initial_status ==
                'Inactive') {
              inactive_billed++;
            } else if
            (dealerTargetAchievement.target_data[i].initial_status ==
                'Prospective') {
              prospective_billed++;
            }
            else if
            (dealerTargetAchievement.target_data[i].initial_status ==
                'Survey') {
              survey_billed++;
            }
          }
        }

        total_billed = active_billed+inactive_billed+prospective_billed+survey_billed;

      });
    });
    onSuccess.call();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      _getDealersTarget = fetchDealersTarget((){
      dealerTargetDataSource = DealerTargetDataSource(dealerTargets: dealerTargetAchievement.target_data);
      emp = Provider.of<EmployeeProvider>(context, listen: false).employee;
    });
  }




  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getDealersTarget,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!fullyLoaded) {
          return Container(
            color: MyColors.boneWhite,
            child: Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                    color: MyColors.appBarColor, size: 30)),
          ); // Placeholder for when data is loading
        } else {
          return Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: MyColors.appBarColor,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(56),
                child: CustomAppBar(
                  module_name: 'Target v/s Achievement',
                  emp_name: getEmployeeName(context),
                  leading: Icon(Icons.menu_outlined, color: MyColors.actionsButtonColor, size: 20,),
                ),
              ),
              body: Column(
                children: [
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomElevatedButton(
                        buttonText: 'Add new dealer',
                        buttonColor: MyColors.fadedAppbarColor,
                        buttonTextColor: MyColors.actionsButtonColor,
                        height: 40,
                        width: 100,
                        onClick: (){},
                      ),
                      CustomElevatedButton(
                        buttonText: 'Edit below targets',
                        buttonColor: MyColors.fadedAppbarColor,
                        buttonTextColor: MyColors.actionsButtonColor,
                        height: 40,
                        width: 100,
                        onClick: (){
                          changeToEditingMode();
                          DealerTargetDataSource(dealerTargets: []).enableEditingMode();
                        },
                      )
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(AssetsConstants.account_summary_purple_box, width: 18,height: 18,),
                      SizedBox(width: 6),
                      Text(
                        "Target Criteria for ASM",
                        style: TextStyle(
                            color: MyColors.boneWhite,
                            fontFamily: MyFonts.poppins,
                            fontWeight: FontWeight.w500
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
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
                              account_count: active_dealer_targetted,
                              account_count_color: MyColors.greenColor,
                              isTargetBox: true,
                              min_acc: dealerTargetAchievement.min_target_for_active,
                            ),
                            AccountSummaryWidget(
                              account_status: 'Inactive',
                              account_count: inactive_dealer_targetted,
                              account_count_color: MyColors.redColor,
                              isTargetBox: true,
                              min_acc: dealerTargetAchievement.min_target_for_inactive,
                            ),
                            AccountSummaryWidget(
                              account_status: 'Prospective',
                              account_count: prospective_dealer_targetted,
                              account_count_color: MyColors.blueColor,
                              isTargetBox: true,
                              min_acc: dealerTargetAchievement.min_target_for_prospective,
                            ),
                            AccountSummaryWidget(
                              account_status: 'Total',
                              account_count: active_dealer_targetted+inactive_dealer_targetted+prospective_dealer_targetted,
                              account_count_color: MyColors.blackColor,
                              isLast: true,
                              isTargetBox: true,
                              min_acc: dealerTargetAchievement.min_target_for_active+dealerTargetAchievement.min_target_for_inactive+dealerTargetAchievement.min_target_for_prospective,
                            )
                          ],
                        )
                    ),
                  ),
                  SizedBox(height: 25,),
                  Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal:20.0),
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
                                padding: const EdgeInsets.symmetric(horizontal: 110.0),
                                child: Divider(
                                  color: MyColors.ashColor,
                                  thickness: 3,
                                ),
                              ),
                              SizedBox(height: 10,),
                              Row(
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
                        
                                        print(value);
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
                                        print(value);
                                      },
                                    ),
                                  ],
                              ),
                              SizedBox(height: 5,),
                              Row(
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
                        
                                          _runFilter(
                                            _searchController.text,
                                              (){
                                              setState(() {
                        
                                              });
                                              }
                                          );
                        
                                        }
                                    )
                                  ],
                              ),
                              SizedBox(height: 20),
                              Text(
                                "Accounts Billed",
                                maxLines: 1,
                                style: TextStyle(
                                    color: MyColors.appBarColor,
                                    fontSize: 15,
                                    fontFamily: MyFonts.poppins,
                                    fontWeight: FontWeight.w500
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                  decoration: BoxDecoration(
                                      color: MyColors.ivoryWhite,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black12,
                                          offset: Offset(
                                            1.0,
                                            1.0,
                                          ),
                                          blurRadius: 3.0,
                                          spreadRadius: 1.0,
                                        ), //BoxShadow
                                      ],
                                  ),
                                  height: 60,
                                  width: double.infinity,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      AccountSummaryWidget(
                                          account_status: 'Active SSIL',
                                          account_count: active_billed,
                                          account_count_color: MyColors.greenColor
                                      ),
                                      AccountSummaryWidget(
                                          account_status: 'Inactive',
                                          account_count: inactive_billed,
                                          account_count_color: MyColors.redColor
                                      ),
                                      AccountSummaryWidget(
                                          account_status: 'Prospective',
                                          account_count: prospective_billed,
                                          account_count_color: MyColors.blueColor
                                      ),
                                      AccountSummaryWidget(
                                          account_status: 'Survey',
                                          account_count: survey_billed,
                                          account_count_color: MyColors.orangeColor
                                      ),
                                      AccountSummaryWidget(
                                        account_status: 'Total',
                                        account_count: total_billed,
                                        account_count_color: MyColors.blackColor,
                                        isLast: true,
                                      )
                                    ],
                                  )
                              ),
                              SizedBox(height: 10),
                              SfDataGridTheme(
                                data: SfDataGridThemeData(
                                    headerColor: MyColors.deepBlueColor,
                                ),
                                child: SfDataGrid(
                                  source: dealerTargetDataSource,
                                    // columnWidthMode: ColumnWidthMode.fill,
                                    gridLinesVisibility: GridLinesVisibility.both,
                                    headerRowHeight: 60,
                                    headerGridLinesVisibility: GridLinesVisibility.both,
                                    columns: <GridColumn>[
                                        DataGridItem('name', 'Name'),
                                        DataGridItem('current_status', 'Current\nStatus'),
                                        DataGridItem('initial_status', 'Initial\nStatus'),
                                        DataGridItem('primary_target', 'Target'),
                                        DataGridItem('cm_achievement', 'CM\nAchv'),
                                        DataGridItem('lm_achievement', 'LM\nAchv'),
                                      ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                  )
                ],
              )
          );
        }
      },
    );
  }


  GridColumn DataGridItem(String column_name, String val) {
    return GridColumn(
            autoFitPadding: EdgeInsets.all(5),
              columnWidthMode: ColumnWidthMode.fill,
              columnName: column_name,
              label: Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                  alignment: Alignment.center,
                  child: Text(
                    val,
                    overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: MyColors.boneWhite,
                          fontFamily: MyFonts.poppins,
                          fontSize: 12
                      )
                  )));
  }
}
