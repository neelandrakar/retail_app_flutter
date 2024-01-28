import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:retail_app_flutter/constants/assets_constants.dart';
import 'package:retail_app_flutter/constants/my_colors.dart';
import 'package:retail_app_flutter/models/dealer_master.dart';
import 'package:retail_app_flutter/visit_plan/screens/visit_plan_screen.dart';

import '../../constants/my_fonts.dart';

class VisitCallDoalogue extends StatefulWidget {
  final DealerMaster dealerMaster;
  const VisitCallDoalogue({
    super.key,
    required this.dealerMaster
  });

  @override
  State<VisitCallDoalogue> createState() => _VisitCallDoalogueState();
}

class _VisitCallDoalogueState extends State<VisitCallDoalogue> {
  @override
  Widget build(BuildContext context) {

    List<String> accNameList = widget.dealerMaster.account_name.split(" ");
    String accName = accNameList[0];
    double acc_lat = double.parse(widget.dealerMaster.latitude);
    double acc_lon = double.parse(widget.dealerMaster.longitude);


    return Dialog(
      child: Container(
        height: 200,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: MyColors.boneWhite,
          borderRadius: BorderRadius.circular(20)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: (){

                Navigator.pushNamed(
                    context, VisitPlanScreen.routeName,
                    arguments: [false, widget.dealerMaster]
                );
              },
              child: Container(
                height: 35,
                decoration: BoxDecoration(
                  color: MyColors.ashColor,
                  borderRadius: BorderRadius.circular(20)
                ),
                padding: EdgeInsets.all(5),
                child: Row(
                  children: [
                    Image.asset(AssetsConstants.location, height: 20,width: 20, color: MyColors.appBarColor),
                    SizedBox(width: 5),
                    const Text(
                      'Submit Visit Remarks',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        color: MyColors.fadedBlack,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        fontFamily: MyFonts.poppins,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 5,),
            Container(
              height: 35,
              decoration: BoxDecoration(
                  color: MyColors.ashColor,
                  borderRadius: BorderRadius.circular(20)
              ),
              padding: EdgeInsets.all(5),
              child: Row(
                children: [
                  Icon(Icons.call, size: 20, color: MyColors.appBarColor,),
                  SizedBox(width: 5),
                  const Text(
                    'Submit Call Remarks',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      color: MyColors.fadedBlack,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      fontFamily: MyFonts.poppins,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            Container(
              height: 35,
              decoration: BoxDecoration(
                  color: MyColors.ashColor,
                  borderRadius: BorderRadius.circular(20)
              ),
              padding: EdgeInsets.all(5),
              child: Row(
                children: [
                  Icon(Icons.call, size: 20, color: MyColors.appBarColor,),
                  SizedBox(width: 5),
                  Text(
                    'Call ${accName}',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      color: MyColors.fadedBlack,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      fontFamily: MyFonts.poppins,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
