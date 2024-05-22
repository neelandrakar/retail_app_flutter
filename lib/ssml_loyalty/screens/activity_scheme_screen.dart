import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:retail_app_flutter/models/loyalty_points_model.dart';
import 'package:retail_app_flutter/providers/ssml_loyalty_provider.dart';
import 'package:retail_app_flutter/ssml_loyalty/services/ssml_loyalty_services.dart';
import 'package:retail_app_flutter/ssml_loyalty/widgets/activity_scheme_card.dart';
import '../../constants/custom_app_bar.dart';
import '../../constants/global_variables.dart';
import '../../constants/my_colors.dart';
import '../../constants/utils.dart';

class ActivitySchemeScreen extends StatefulWidget {
  const ActivitySchemeScreen({super.key});

  @override
  State<ActivitySchemeScreen> createState() => _ActivitySchemeScreenState();
}

class _ActivitySchemeScreenState extends State<ActivitySchemeScreen> {
  String pageName = 'Activity';
  SSMLLoyaltyServices ssmlLoyaltyServices = SSMLLoyaltyServices();
  late Future<void> _getActivityData;


  fetchPendingData() async {

    ssmlLoyaltyServices.getEmpSlab(
        context: context,
        slab_type: 2,
        onSuccess: () {
          setState(() {
            loyaltyPointsModel = Provider.of<SSMLLoyaltyProvider>(context, listen: false).loyaltyPointsModel;
            print('actiiiiiii: ' + loyaltyPointsModel.invoice_wise_points!.length.toString());
          });
    });
    print('data is fetched!');
  }

  @override
  void initState() {
    super.initState();
    print('hii');
    _getActivityData = fetchPendingData();
  }

  @override
  Widget build(BuildContext context) {



    return FutureBuilder(
      future: _getActivityData, // Simulate a delay
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                  color: MyColors.appBarColor,
                  size: 30
              ));        
        } else {
          return Scaffold(
              backgroundColor: MyColors.boneWhite,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(56),
                child: CustomAppBar(
                  module_name: 'Pending Data',
                  emp_name: getEmployeeName(context),
                  leading: Icon(Icons.menu_outlined, color: MyColors.actionsButtonColor, size: 20,),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // SizedBox(height: 10),
                    Expanded(
                      child: ListView.separated(
                          itemCount: loyaltyPointsModel.invoice_wise_points!.length,
                          itemBuilder: (context, index){
                            return ActivitySchemeCard(
                              point_type: loyaltyPointsModel.invoice_wise_points![index].point_type,
                              dealer_name: loyaltyPointsModel.invoice_wise_points![index].dealer_name,
                              invoice_no: loyaltyPointsModel.invoice_wise_points![index].invoice_no,
                              date: loyaltyPointsModel.invoice_wise_points![index].date,
                            );
                          }, separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(height: 0);
                      },),
                    ),
                  ],
                ),
              )

          );
        }
      },
    );
  }
}
