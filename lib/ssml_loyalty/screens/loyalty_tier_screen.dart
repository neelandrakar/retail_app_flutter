import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:retail_app_flutter/constants/assets_constants.dart';
import 'package:retail_app_flutter/constants/global_variables.dart';
import 'package:retail_app_flutter/ssml_loyalty/widgets/tier_widget.dart';
import '../../constants/custom_app_bar.dart';
import '../../constants/my_colors.dart';
import '../../constants/utils.dart';

class LoyaltyTierScreen extends StatefulWidget {
  const LoyaltyTierScreen({super.key});

  @override
  State<LoyaltyTierScreen> createState() => _LoyaltyTierScreenState();
}

class _LoyaltyTierScreenState extends State<LoyaltyTierScreen> {
  String pageName = 'Loyalty Tier';
  ScrollController _scrollController = ScrollController();
  int tierWidgetWidth = 120;
  int currTier = 0;

  void _scrollToIndex(int index, int itemWidth) {
    double screenWidth = MediaQuery.of(context).size.width;
    double centerOffset = (screenWidth / 2) - (itemWidth / 2);
    double offset = (index * itemWidth) - centerOffset;

    _scrollController.animateTo(
      offset,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: CustomAppBar(
          module_name: pageName,
          emp_name: getEmployeeName(context),
          leading: Icon(Icons.menu_outlined, color: MyColors.actionsButtonColor, size: 20,),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,

        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage(AssetsConstants.blue_background_img) ,fit: BoxFit.cover,
                ),
              ),
              height: 350,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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

                        print('Current tier is $currTier');

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
                        );
                      }
                  ),
              ),
              ),
          ],
        ),
      ),
    );
  }
}
