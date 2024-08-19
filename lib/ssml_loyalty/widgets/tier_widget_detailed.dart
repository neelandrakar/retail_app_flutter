import 'package:flutter/material.dart';
import 'package:retail_app_flutter/constants/my_colors.dart';

import '../../constants/my_fonts.dart';

class TierWidgetDetailed extends StatefulWidget {
  const TierWidgetDetailed({super.key, required this.tier_name, required this.tier_details, required this.tier_img, required this.onClick, required this.is_first, required this.is_last});
  final String tier_name;
  final String tier_details;
  final String tier_img;
  final VoidCallback onClick;
  final bool is_first;
  final bool is_last;

  @override
  State<TierWidgetDetailed> createState() => _TierWidgetDetailedState();
}

class _TierWidgetDetailedState extends State<TierWidgetDetailed> {

  String xyz = "";


  @override
  Widget build(BuildContext context) {

    if(widget.is_first){
      xyz = "First";
    } else if(widget.is_last){
      xyz = "Last";
    } else{
      xyz = "middle";
    }

    return Container(
      width: double.infinity,
      height: 80,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
              widget.is_first ? 10 : 0
          ),
          topRight: Radius.circular(
              widget.is_first ? 10 : 0
          ),
          bottomRight: Radius.circular(
              widget.is_last ? 10 : 0
          ),
          bottomLeft: Radius.circular(
              widget.is_last ? 10 : 0
          ),
        ),
        border: Border.all(color: Colors.black12),
        color: MyColors.boneWhite
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.network(widget.tier_img, width: 50, height: 50),
              SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.tier_name,
                    maxLines: 1,
                    style: TextStyle(
                        color: MyColors.blackColor,
                        fontSize: 15,
                        fontFamily: MyFonts.poppins,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis
                    ),
                  ),
                  Container(
                    width: 170,
                    child: Text(
                      'Unlock Silver! Enjoy early access to all your deal before...',
                      maxLines: 1,
                      style: TextStyle(
                          color: MyColors.fadedBlack,
                          fontSize: 11,
                          fontFamily: MyFonts.poppins,
                          fontWeight: FontWeight.normal,
                          overflow: TextOverflow.ellipsis
                      ),
                    ),
                  ),
                ],
              ),

            ],
          ),
          IconButton(
              icon: Icon(Icons.arrow_forward_ios_outlined),
            iconSize: 18,
            onPressed: (){
                print(widget.tier_name);
            },
          )
        ],
      ),
    );
  }
}
