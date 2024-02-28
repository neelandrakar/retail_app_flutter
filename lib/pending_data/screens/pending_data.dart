import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:retail_app_flutter/constants/global_variables.dart';
import 'package:retail_app_flutter/constants/utils.dart';
import 'package:retail_app_flutter/models/pending_data_model.dart';
import 'package:retail_app_flutter/models/submitted_visit_model.dart';
import 'package:retail_app_flutter/pending_data/widgets/pending_data_item.dart';
import 'package:retail_app_flutter/sidemenu/screens/side_menu.dart';
import 'package:retail_app_flutter/visit_plan/services/visit_plan_services.dart';

import '../../constants/custom_app_bar.dart';
import '../../constants/custom_elevated_button.dart';
import '../../constants/my_colors.dart';
import '../../constants/my_fonts.dart';
import '../../constants/saved_location_sp.dart';


class PendingDataScreen extends StatefulWidget {
  static const String routeName = '/pending-data-screen';
  const PendingDataScreen({super.key});

  @override
  State<PendingDataScreen> createState() => _PendingDataScreenState();
}

class _PendingDataScreenState extends State<PendingDataScreen> {
  int side_menu_item_no = 3;
  final VisitPlanServices visitPlanServices = VisitPlanServices();

  fetchPendingData() async {

    allPendingData = await SavedLocationSP.getPendingData();
    print('data is fetched');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchPendingData(), // Simulate a delay
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingAnimationWidget.staggeredDotsWave(color: MyColors.greenColor, size: 18); // Show loading indicator while waiting
        } else {
          return Scaffold(
            backgroundColor: MyColors.ashColor,
            drawer: Drawer(
              backgroundColor: MyColors.appBarColor,
              child: SideMenu(
                side_menu_item_no: side_menu_item_no,
              ),
              width: 280,
            ),
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: CustomAppBar(
                module_name: 'Pending Data',
                emp_name: getEmployeeName(context),
                leading: Icon(Icons.menu_outlined, color: MyColors.actionsButtonColor, size: 20,),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0).copyWith(top: 30),
              child: Column(
                children: [
                  PendingDataItem(
                      item_name: 'Pending Data',
                      item_color: MyColors.pendingDataBlue,
                      item_count: 'Nos',
                      button_text: 'Refresh',
                      is_menu: true,
                      onClick: (){
                        setState(() {});
                      },
                  ),
                  SizedBox(height: 10),
                  PendingDataItem(
                      item_name: 'Pending Visits',
                      item_color: MyColors.pendingDataBlue,
                      item_count: allPendingData.stored_visits.length.toString(),
                      button_text: 'Send',
                      is_menu: false,
                      onClick: () async {

                        List<SubmittedVisitModel> storedVisits = allPendingData.stored_visits;
                        print('total length ${storedVisits.length}');
                        for(int i=0; i<storedVisits.length; i++){
                          SubmittedVisitModel singleVisit = storedVisits[i];
                          visitPlanServices.submitVisitRemarks(
                              context: context,
                              accountObjectId: singleVisit.account_obj_id,
                              checkIn: singleVisit.check_in_time,
                              checkOut: singleVisit.check_out_time,
                              purposeOfVisit: singleVisit.purpose_of_visit,
                              hasHandedOverGift: singleVisit.has_handed_over_gift,
                              image: singleVisit.visit_image,
                              counterPotential: singleVisit.counter_potential,
                              subDealerCount: singleVisit.sub_dealer_count,
                              businessSurvey: singleVisit.business_survey,
                              discussionDetails: singleVisit.discussion_details,
                              actionPlanDetails: singleVisit.action_plan_details,
                              issueDetails: singleVisit.issue_details,
                              followUpPerson: singleVisit.follow_up_person,
                              rating: singleVisit.rating,
                              onSuccess: () async{
                                if (i == storedVisits.length-1) {
                                  print('Visit no $i is sent to server');
                                  print('Visit data has been successfully sent to server');
                                  showSnackBar(context, "Visit data has been successfully sent to server");
                                  allPendingData.stored_visits.clear();
                                  await SavedLocationSP.clearStoredVisits();
                                  setState(() {});
                                }
                              }
                          );
                        }
                      },
                  ),
                  SizedBox(height: 2),
                  PendingDataItem(
                      item_name: 'Pending Branding',
                      item_color: MyColors.pendingDataBlue,
                      item_count: 0.toString(),
                      button_text: 'Send',
                      is_menu: false,
                      onClick: (){
                        print('To send pending branding data');
                      },
                  ),
                  //Text(allPendingData.stored_visits[0].discussion_details)
                ],
              ),
            )
          );
        }
      },
    );
  }
}
