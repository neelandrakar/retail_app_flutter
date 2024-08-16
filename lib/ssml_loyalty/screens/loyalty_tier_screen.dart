import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:retail_app_flutter/constants/assets_constants.dart';
import 'package:retail_app_flutter/constants/global_variables.dart';
import 'package:retail_app_flutter/ssml_loyalty/widgets/points_widget.dart';
import 'package:retail_app_flutter/ssml_loyalty/widgets/tier_widget.dart';
import '../../constants/custom_app_bar.dart';
import '../../constants/my_colors.dart';
import '../../constants/utils.dart';
import '../../models/loyalty_points_model.dart';
import '../../providers/ssml_loyalty_provider.dart';
import '../services/ssml_loyalty_services.dart';

class LoyaltyTierScreen extends StatefulWidget {
  const LoyaltyTierScreen({super.key});

  @override
  State<LoyaltyTierScreen> createState() => _LoyaltyTierScreenState();
}

class _LoyaltyTierScreenState extends State<LoyaltyTierScreen> {
  String pageName = 'Loyalty Tier';
  ScrollController _scrollController = ScrollController();
  int tierWidgetWidth = 140;
  int currTier = 0;

  SSMLLoyaltyServices ssmlLoyaltyServices = SSMLLoyaltyServices();
  late Future<void> _getActivityData;
  late LoyaltyPointsModel loyaltyPointsModel;

  fetchPendingData() async {
    await ssmlLoyaltyServices.getEmpSlab(
      context: context,
      slab_type: 2,
      onSuccess: () {
        setState(() {
          loyaltyPointsModel = Provider
              .of<SSMLLoyaltyProvider>(context, listen: false)
              .loyaltyPointsModel;
          isSchemeFullyLoaded = true;
          print('all set');
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    print('hii');
    _getActivityData = fetchPendingData();
  }

  void _scrollToIndex(int index, int itemWidth) {
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    double centerOffset = (screenWidth / 2) - (itemWidth / 2);
    double offset = (index * itemWidth) - centerOffset;

    _scrollController.animateTo(
      offset,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    isSchemeFullyLoaded = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.ashColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: CustomAppBar(
          module_name: pageName,
          emp_name: getEmployeeName(context),
          leading: Icon(Icons.menu_outlined, color: MyColors.actionsButtonColor,
              size: 20),
        ),
      ),
      body: FutureBuilder(
        future: _getActivityData,
        builder: (context, snapshot) {
            if (!isSchemeFullyLoaded) {
              return Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: MyColors.appBarColor,
                  size: 30,
                ),
              );
            } else {
              return Container(
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  children: [
                    // Your widgets here...
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage(
                            AssetsConstants.blue_background_img),
                          fit: BoxFit.cover,
                        ),
                      ),
                      height: 300,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: ListView.builder(
                            itemCount: loyaltyPointsModel.loyalty_tiers.length,
                            scrollDirection: Axis.horizontal,
                            controller: _scrollController,
                            itemBuilder: (context, index){

                              String tier_img = AssetsConstants.no_data;

                              if(loyaltyPointsModel.loyalty_tiers[index].tier_id==1){
                                tier_img = AssetsConstants.bronze_badge;
                              } else if(loyaltyPointsModel.loyalty_tiers[index].tier_id==2){
                                tier_img = AssetsConstants.silver_badge;
                              }
                              else if(loyaltyPointsModel.loyalty_tiers[index].tier_id==3){
                                tier_img = AssetsConstants.gold_badge;
                              }
                              else if(loyaltyPointsModel.loyalty_tiers[index].tier_id==4){
                                tier_img = AssetsConstants.diamond_badge;
                              }
                              else if(loyaltyPointsModel.loyalty_tiers[index].tier_id==5){
                                tier_img = AssetsConstants.platinum_badge;
                              }


                              for(int i=0; i<loyaltyPointsModel.loyalty_tiers.length; i++){

                                if(loyaltyPointsModel.loyalty_tiers[i].is_current==2){
                                  currTier = (loyaltyPointsModel.loyalty_tiers[i].tier_id) - 1;
                                }
                              }

                              // print('Current tier is $currTier');

                              _scrollToIndex(currTier, tierWidgetWidth);


                              return TierWidget(
                                tier_name: loyaltyPointsModel.loyalty_tiers[index].tier_name,
                                tier_id: loyaltyPointsModel.loyalty_tiers[index].tier_id,
                                min_points: loyaltyPointsModel.loyalty_tiers[index].min_points,
                                max_points: loyaltyPointsModel.loyalty_tiers[index].max_points,
                                tier_img: tier_img,
                                is_current: loyaltyPointsModel.loyalty_tiers[index].is_current,
                                till_next_tier: loyaltyPointsModel.loyalty_tiers[index].till_next_tier,
                                total_points: loyaltyPointsModel.total_points,
                                widgetWidth: tierWidgetWidth,
                              );
                            }
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Your widgets here...
                          PointsWidget(
                              box_text: 'Your Points',
                              total_points: loyaltyPointsModel.total_points.toString()
                          ),
                          PointsWidget(
                              box_text: 'Pending Points',
                              total_points: loyaltyPointsModel.total_pending.toString()
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }
          }
      ),
    );
  }
}