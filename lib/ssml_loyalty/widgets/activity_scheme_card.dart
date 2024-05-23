import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:retail_app_flutter/constants/assets_constants.dart';
import 'package:retail_app_flutter/constants/global_variables.dart';
import 'package:retail_app_flutter/constants/my_colors.dart';
import 'package:retail_app_flutter/providers/ssml_loyalty_provider.dart';

class ActivitySchemeCard extends StatefulWidget {
  final int point_type;
  final String dealer_name;
  final String invoice_no;
  final DateTime date;
  final String string_date;
  final int earned_points;
  const ActivitySchemeCard({
    super.key,
    required this.point_type,
    required this.dealer_name,
    required this.invoice_no,
    required this.date,
    required this.string_date,
    required this.earned_points
  });

  @override
  State<ActivitySchemeCard> createState() => _ActivitySchemeCardState();
}

class _ActivitySchemeCardState extends State<ActivitySchemeCard> {

  String icon_type = AssetsConstants.no_profile_pic;
  String plus_minus_text = '';
  String getIconType(){
    if(widget.point_type==1){
      icon_type =  AssetsConstants.sale_icon;
    }

    return icon_type;
  }

  String getPlusMinus(){
    if(widget.earned_points>0){
      plus_minus_text = '+';
    } else if(widget.earned_points<0){
      plus_minus_text = '';
    }
    return plus_minus_text;
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: MyColors.boneWhite,
          borderRadius: BorderRadius.circular(10),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: MyColors.boneWhite,
                      shape: BoxShape.circle,
                      border: Border.all(color: MyColors.black12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset(getIconType()),
                    ),

                  ),
                  SizedBox(width: 12),
                  Container(
                    // color: Colors.red,
                    width: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.invoice_no,
                          maxLines: 1,
                          style: TextStyle(
                              color: MyColors.appBarColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis
                          ),
                        ),
                        Text(
                          widget.dealer_name,
                          maxLines: 1,
                          style: TextStyle(
                              color: MyColors.fadedAppbarColor,
                              fontSize: 11,
                              fontWeight: FontWeight.normal,
                              overflow: TextOverflow.ellipsis
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          widget.string_date,
                          maxLines: 1,
                          style: TextStyle(
                              color: MyColors.fadedBlack,
                              fontSize: 10,
                              fontWeight: FontWeight.normal,
                              overflow: TextOverflow.ellipsis
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Text(
                "${getPlusMinus()} ${widget.earned_points.toString()}",
                style: TextStyle(
                    color: widget.earned_points>0 ? MyColors.greenColor : Colors.red,
                    fontSize: 15,
                    fontWeight: FontWeight.bold
                ),
              )
            ],
          ),
        ),
    );
  }
}
