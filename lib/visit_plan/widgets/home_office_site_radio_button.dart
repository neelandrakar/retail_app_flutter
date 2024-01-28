import 'package:flutter/material.dart';
import 'package:retail_app_flutter/constants/global_variables.dart';
import 'package:retail_app_flutter/constants/my_colors.dart';

import '../../constants/my_fonts.dart';

class HomeOfficeSite extends StatefulWidget {

  final VoidCallback onRadioChange;
  const HomeOfficeSite({super.key, required this.onRadioChange});

  @override
  State<HomeOfficeSite> createState() => _HomeOfficeSiteState();
}

class _HomeOfficeSiteState extends State<HomeOfficeSite> {

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Radio(
              activeColor: MyColors.appBarColor,
              value: VisitLocationType.Home,
              groupValue: visitLocationType,
              onChanged: (VisitLocationType? val) {
                print(val.toString());
                setState(() {
                  visitLocationType = val!;
                  widget.onRadioChange.call();
                });
              },
            ),
            Text(
              'Home',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                color: MyColors.blackColor,
                fontWeight: FontWeight.w500,
                fontSize: 13,
                fontFamily: MyFonts.poppins,
              ),
            )
          ],
        ),
        Column(
          children: [
            Radio(
              activeColor: MyColors.appBarColor,
              value: VisitLocationType.Office,
              groupValue: visitLocationType,
              onChanged: (VisitLocationType? val) {
                print(val.toString());
                setState(() {
                  visitLocationType = val!;
                  widget.onRadioChange.call();
                });
              },
            ),
            Text(
              'Office',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                color: MyColors.blackColor,
                fontWeight: FontWeight.w500,
                fontSize: 13,
                fontFamily: MyFonts.poppins,
              ),
            )
          ],
        ),
        Column(
          children: [
            Radio(
              activeColor: MyColors.appBarColor,
              value: VisitLocationType.Site,
              groupValue: visitLocationType,
              onChanged: (VisitLocationType? val) {
                print(val.toString());
                setState(() {
                  visitLocationType = val!;
                  widget.onRadioChange.call();
                });
              },
            ),
            Text(
              'Site',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                color: MyColors.blackColor,
                fontWeight: FontWeight.w500,
                fontSize: 13,
                fontFamily: MyFonts.poppins,
              ),
            )
          ],
        )

      ],
    );
  }
}
