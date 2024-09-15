import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retail_app_flutter/constants/assets_constants.dart';
import 'package:retail_app_flutter/constants/custom_button.dart';
import 'package:retail_app_flutter/constants/custom_button_two.dart';
import 'package:retail_app_flutter/constants/my_colors.dart';
import 'package:retail_app_flutter/constants/my_fonts.dart';
import 'package:retail_app_flutter/constants/utils.dart';
import 'package:retail_app_flutter/models/coupon_model.dart';
import 'package:retail_app_flutter/models/merchant_model.dart';
import 'package:retail_app_flutter/ssml_loyalty/screens/gift_redemption_screen.dart';

import '../../providers/ssml_loyalty_provider.dart';

class CouponCard extends StatefulWidget {
  final bool is_first;
  final bool is_last;
  final CouponModel coupon;
  final MerchantModel merchant;
  const CouponCard({
    super.key,
    this.is_first = false,
    this.is_last = false,
    required this.coupon,
    required this.merchant
  });

  @override
  State<CouponCard> createState() => _CouponCardState();
}

class _CouponCardState extends State<CouponCard> {

  Color bg_color = MyColors.ashColor;
  String button_text = 'Not eligible';
  Color button_color = MyColors.topNavigationBarSelected;
  Color button_text_color = MyColors.appBarColor;


  void navigateToGiftRedemptionPage(){
    Navigator.pushNamed(
        context,
        GIftRedemptionScreen.routeName,
        arguments: [widget.merchant, widget.coupon]
    );
  }

  @override
  Widget build(BuildContext context) {


    if(getTotalPoints(context)>=widget.coupon.coupon_value){
      button_text  = 'Redeem Code';
      button_color = MyColors.appBarColor;
      button_text_color = MyColors.boneWhite;

    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      margin: EdgeInsets.only(bottom: widget.is_last ? 15 : 0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(
                  widget.is_first ? 10 : 0),
              topRight: Radius.circular(
                  widget.is_first ? 10 : 0),
              bottomRight: Radius.circular(
                  widget.is_last ? 10 : 0),
              bottomLeft: Radius.circular(
                  widget.is_last ? 10 : 0)
          ),
        color: bg_color
      ),
      child: Container(
            width: double.infinity,
            height: 120,
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: bg_color,
                border: Border(
                  bottom: BorderSide(width: 0.5, color: MyColors.black12),
                ),
          ),
            child:
                Row(
                  children: [
                    Image.asset(AssetsConstants.coupon, width: 60, height: 60),
                    SizedBox(width: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: "Value: ₹",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: MyFonts.poppins,
                                    color: MyColors.appBarColor
                                ), // adjust the style as needed
                              ),
                              TextSpan(
                                text: "${widget.coupon.coupon_value}",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: MyFonts.poppins,
                                      fontWeight: FontWeight.bold,
                                      color: MyColors.appBarColor
                                  ),
                              ),
                              const TextSpan(
                                text: "/-",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: MyFonts.poppins,
                                    color: MyColors.appBarColor
                                ), // adjust the style as needed
                              )
                            ],
                          ),
                        ),
                        Text(
                          'Get a coupon worth ₹${widget.coupon.coupon_value}!',
                          style: TextStyle(
                            color: MyColors.appBarColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            fontFamily: MyFonts.poppins
                          ),
                        ),
                        CustomButton(

                            height: 35,
                            width: 155,
                            textColor: button_text_color,
                            buttonColor: button_color,
                            onClick: (){

                              if(getTotalPoints(context)>=widget.coupon.coupon_value){

                                navigateToGiftRedemptionPage();


                              }
                            },
                            buttonText: button_text,
                            buttonTextSize: 15,
                            borderRadius: 10
                        )

                      ],
                    )
                  ],
                ),
      ),
    );
  }
}
