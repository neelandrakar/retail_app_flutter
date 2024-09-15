import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retail_app_flutter/constants/assets_constants.dart';
import 'package:retail_app_flutter/constants/my_colors.dart';
import 'package:retail_app_flutter/constants/my_fonts.dart';
import 'package:retail_app_flutter/constants/utils.dart';
import 'package:retail_app_flutter/providers/ssml_loyalty_provider.dart';

class AppBarPointBalance extends StatefulWidget {
  const AppBarPointBalance({super.key});

  @override
  State<AppBarPointBalance> createState() => _AppBarPointBalanceState();
}

class _AppBarPointBalanceState extends State<AppBarPointBalance> {

  @override
  Widget build(BuildContext context) {


    return Container(
      height: 25,
      width: 70,
      decoration: BoxDecoration(
        color: MyColors.appBarColor,
        borderRadius: BorderRadius.circular(10)
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(AssetsConstants.point_balance_token, height: 15,width: 15),
          SizedBox(width: 4),
          Text(
            getTotalPoints(context).toInt().toString(),
            style: TextStyle(
              color: MyColors.boneWhite,
              fontFamily: MyFonts.poppins,
              fontSize: 14
            ),
          )
        ],
      ),
    );
  }
}
