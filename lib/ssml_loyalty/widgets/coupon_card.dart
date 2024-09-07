import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:retail_app_flutter/constants/assets_constants.dart';
import 'package:retail_app_flutter/constants/custom_button.dart';
import 'package:retail_app_flutter/constants/custom_button_two.dart';
import 'package:retail_app_flutter/constants/my_colors.dart';
import 'package:retail_app_flutter/constants/my_fonts.dart';
import 'package:retail_app_flutter/models/coupon_model.dart';

class CouponCard extends StatefulWidget {
  final bool is_first;
  final bool is_last;
  final CouponModel coupon;
  const CouponCard({
    super.key,
    this.is_first = false,
    this.is_last = false,
    required this.coupon
  });

  @override
  State<CouponCard> createState() => _CouponCardState();
}

class _CouponCardState extends State<CouponCard> {

  Color bg_color = MyColors.ashColor;

  @override
  Widget build(BuildContext context) {
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
                        CustomButton(onClick: (){}, buttonText: 'Redeem Code', borderRadius: 10)

                      ],
                    )
                  ],
                ),
      ),
    );
  }
}
