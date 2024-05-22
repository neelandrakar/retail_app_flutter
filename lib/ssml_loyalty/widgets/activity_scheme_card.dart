import 'package:flutter/material.dart';
import 'package:retail_app_flutter/constants/assets_constants.dart';
import 'package:retail_app_flutter/constants/my_colors.dart';
import 'package:retail_app_flutter/providers/ssml_loyalty_provider.dart';

class ActivitySchemeCard extends StatefulWidget {
  final int point_type;
  final String dealer_name;
  final String invoice_no;
  final DateTime date;
  const ActivitySchemeCard({
    super.key,
    required this.point_type,
    required this.dealer_name,
    required this.invoice_no,
    required this.date
  });

  @override
  State<ActivitySchemeCard> createState() => _ActivitySchemeCardState();
}

class _ActivitySchemeCardState extends State<ActivitySchemeCard> {

  String icon_type = AssetsConstants.no_profile_pic;
  String getIconType(){
    if(widget.point_type==1){
      icon_type =  AssetsConstants.sale_icon;
    }

    return icon_type;
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: MyColors.boneWhite,
        border: Border(
          bottom: BorderSide(
            color: MyColors.black12
          )
        )
      ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: MyColors.boneWhite,
                  shape: BoxShape.circle,
                  border: Border.all(color: MyColors.black12)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.asset(getIconType()),
                ),

              ),
              SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.invoice_no,
                    style: TextStyle(
                        color: MyColors.appBarColor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    widget.dealer_name,
                    style: TextStyle(
                        color: MyColors.fadedAppbarColor,
                        fontSize: 10,
                        fontWeight: FontWeight.normal
                    ),
                  ),
                  Text(
                    widget.date.toString(),
                    style: TextStyle(
                        color: MyColors.fadedBlack,
                        fontSize: 10,
                        fontWeight: FontWeight.normal
                    ),
                  )
                ],
              )
            ],
          ),
        ),
    );
  }
}
