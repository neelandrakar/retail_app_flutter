import 'package:flutter/material.dart';
import 'package:retail_app_flutter/constants/assets_constants.dart';
import 'package:retail_app_flutter/constants/my_colors.dart';
import 'package:retail_app_flutter/constants/my_fonts.dart';

class PrimaryAccountBox extends StatefulWidget {
  final int index;
  final String box_name;
  final String box_subtitle;
  final VoidCallback onClick;
  const PrimaryAccountBox({super.key, required this.index, required this.box_name, required this.box_subtitle, required this.onClick});

  @override
  State<PrimaryAccountBox> createState() => _PrimaryAccountBoxState();
}

class _PrimaryAccountBoxState extends State<PrimaryAccountBox> {

  String boxImage = '';
  String boxIcon = '';
  @override
  Widget build(BuildContext context) {

    if(widget.index==0){
      boxImage = AssetsConstants.dealer_menu_background;
      boxIcon = AssetsConstants.dealer_menu_icon;
    } else if(widget.index==1){
      boxImage = AssetsConstants.distributor_menu_background;
      boxIcon = AssetsConstants.distributor_menu_icon;
    } else if(widget.index==2){
      boxImage = AssetsConstants.subdealer_menu_background;
      boxIcon = AssetsConstants.subdealer_menu_icon;
    }

    return Container(
      height: 130,
      width: 105,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(boxImage), fit: BoxFit.fill),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(boxIcon, fit: BoxFit.fill,height: 40, width: 50,),
                  SizedBox(height: 5,),
                  Text(widget.box_name,
                    style: TextStyle(
                      color: MyColors.boneWhite,
                      fontFamily: MyFonts.poppins,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  Text(widget.box_subtitle,
                    style: TextStyle(
                        color: MyColors.ivoryWhite,
                        fontFamily: MyFonts.poppins,
                        fontWeight: FontWeight.w100,
                        fontSize: 10,
                    ),
                  )
                ],
              )
          

    );
  }
}
