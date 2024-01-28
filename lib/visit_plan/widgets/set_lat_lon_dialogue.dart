import 'package:flutter/material.dart';
import 'package:retail_app_flutter/constants/assets_constants.dart';
import 'package:retail_app_flutter/constants/global_variables.dart';
import 'package:retail_app_flutter/constants/my_colors.dart';
import 'package:retail_app_flutter/models/dealer_master.dart';
import 'package:retail_app_flutter/visit_plan/widgets/home_office_site_radio_button.dart';

import '../../constants/my_fonts.dart';

class SetLatLonDialogue extends StatefulWidget {
  final DealerMaster dealer;
  const SetLatLonDialogue({super.key, required this.dealer});

  @override
  State<SetLatLonDialogue> createState() => _SetLatLonDialogueState();
}


class _SetLatLonDialogueState extends State<SetLatLonDialogue> {

  String accName = 'NA';
  String noLocationText = 'NA';


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    List<String> accNameList = widget.dealer.account_name.split(" ");
    accName = accNameList[0];
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    visitLocationType = VisitLocationType.Home;
  }


  @override
  Widget build(BuildContext context) {

    if(VisitLocationType==VisitLocationType.Home) {
      String noLocationText = 'Home location is yet to be plotted';
    } else if(VisitLocationType==VisitLocationType.Office) {
      String noLocationText = 'Office location is yet to be plotted';
    }

    String getLocationHeaderText(VisitLocationType visitLocType) {
      if (visitLocType == VisitLocationType.Home) {
        return "Home location isn't plotted";
      } else if (visitLocType == VisitLocationType.Office) {
        return "Office location isn't plotted";
      } else if (visitLocType == VisitLocationType.Site) {
        return 'Please choose a site';
      } else {
        return 'NA';
      }
    }

    String getLocationSmallText(VisitLocationType visitLocType) {
      if (visitLocType == VisitLocationType.Home) {
        return "Please click the button below to set Home location of $accName.";
      } else if (visitLocType == VisitLocationType.Office) {
        return "Please click the button below to set Office location of $accName.";
      } else if (visitLocType == VisitLocationType.Site) {
        return "Please choose a site from the dropdown.";
      } else {
        return 'NA';
      }
    }



    return Dialog(
      child: Container(
        height: 400,
        decoration: BoxDecoration(
          color: MyColors.boneWhite,
          borderRadius: BorderRadius.circular(20)
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(AssetsConstants.earth_pin, height: 100, width: 100,),
            SizedBox(height: 20),
            Text(
              getLocationHeaderText(visitLocationType),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                color: MyColors.blackColor,
                fontWeight: FontWeight.w600,
                fontSize: 17,
                fontFamily: MyFonts.poppins,
              ),
            ),
            SizedBox(height: 10),
            Text(
              getLocationSmallText(visitLocationType),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(
                color: MyColors.blackColor,
                fontWeight: FontWeight.w400,
                fontSize: 15,
                fontFamily: MyFonts.poppins,
              ),
            ),
            SizedBox(height: 10),
            HomeOfficeSite(onRadioChange: (){
              setState(() {
                print('hello');
                print(visitLocationType);
              });
            },)
          ],
        ),
      ),
    );
  }
}
