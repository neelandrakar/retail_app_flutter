import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:retail_app_flutter/constants/my_colors.dart';

import '../../constants/global_variables.dart';
import '../../constants/my_fonts.dart';

class CouponCodeBottomSheet extends StatefulWidget {
  final String id;
  final String merchant_img;
  final String expiry_date;
  final String merchant_name;
  final String redeemed_on;
  final bool is_expired;
  final int coupon_value;
  final String header_text;
  final String code;
  const CouponCodeBottomSheet({super.key, required this.id, required this.merchant_img, required this.expiry_date, required this.merchant_name, required this.redeemed_on, required this.is_expired, required this.coupon_value, required this.header_text, required this.code});

  @override
  State<CouponCodeBottomSheet> createState() => _CouponCodeBottomSheetState();
}

class _CouponCodeBottomSheetState extends State<CouponCodeBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizonal_padding).copyWith(top: 10, bottom: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
              width: 80,
              height: 5,
              decoration: BoxDecoration(
                  color: MyColors.ashColor,
                  borderRadius: BorderRadius.circular(5)
              ),
          ),
          SizedBox(height: 10),
          Image.network(
            widget.merchant_img, // Replace with your actual image asset
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 20),
          Text(
            'Coupon worth ₹${widget.coupon_value}',
            maxLines: 1,
            style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                fontFamily: MyFonts.poppins,
                overflow: TextOverflow.ellipsis,
                color: MyColors.appBarColor
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Run this by at your nearest ${widget.merchant_name} to utilize!',
            textAlign: TextAlign.center,
              maxLines: 2,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  fontFamily: MyFonts.poppins,
                  overflow: TextOverflow.ellipsis,
                  color: MyColors.appBarColor

              )
          ),
          SizedBox(height: 20),
          Container(
            width: 200,
            padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.hourglass_bottom, size: 20, color: Colors.orange),
                SizedBox(width: 5),
                RichText(
                    maxLines: 1,
                    text: TextSpan(
                        children: [
                          const TextSpan(
                              text: "Expires: ",
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: MyFonts.poppins,
                                color: MyColors.orangeColor,
                              )),
                          TextSpan(
                              text: widget.expiry_date,
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: MyColors.orangeColor,
                                  fontFamily: MyFonts.poppins,
                                  fontWeight: FontWeight.w600,
                                  overflow: TextOverflow.ellipsis,
                              )
                          )
                        ]
                    )
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [

                Text(
                    widget.code,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: MyFonts.poppins,
                        fontSize: 15
                    )),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: widget.code));
                  },
                  child: Icon(Icons.copy, size: 20, color: Colors.green),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
