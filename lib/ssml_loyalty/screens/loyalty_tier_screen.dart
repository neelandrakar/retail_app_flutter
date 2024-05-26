import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:retail_app_flutter/constants/assets_constants.dart';
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
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(AssetsConstants.blue_background_img) ,fit: BoxFit.cover,
          ),
        ),
        child: ListView.builder(
            itemCount: 5,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index){
              return TierWidget();
            }
        ),
      ),
    );
  }
}
