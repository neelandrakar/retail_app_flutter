import 'package:flutter/material.dart';
import 'package:retail_app_flutter/constants/my_colors.dart';
import 'package:retail_app_flutter/constants/my_fonts.dart';

import 'coupon_code_bottom_sheet.dart';

class SingleVoucherCard extends StatefulWidget {
  final String id;
  final String merchant_img;
  final String expiry_date;
  final String merchant_name;
  final String redeemed_on;
  final bool is_expired;
  final int coupon_value;
  final String header_text;
  final String code;
  const SingleVoucherCard({
    super.key,
    required this.merchant_img,
    required this.expiry_date,
    required this.merchant_name,
    required this.redeemed_on,
    required this.is_expired,
    required this.coupon_value,
    required this.id,
    required this.header_text,
    required this.code
  });

  @override
  State<SingleVoucherCard> createState() => _SingleVoucherCardState();
}

class _SingleVoucherCardState extends State<SingleVoucherCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 90,
        decoration: BoxDecoration(
          color: MyColors.boneWhite,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // QR Code Image
              Image.network(
                widget.merchant_img, // Replace with your actual image asset
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              SizedBox(width: 16),
              // Coupon Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Coupon worth ₹${widget.coupon_value}',
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: MyFonts.poppins,
                        overflow: TextOverflow.ellipsis
                      ),
                    ),
                    SizedBox(height: 4),
                    RichText(
                        maxLines: 1,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "${widget.expiry_date} • ",
                              style: const TextStyle(
                                fontSize: 11,
                                fontFamily: MyFonts.poppins,
                                color: MyColors.fadedBlack,
                              )),
                            TextSpan(
                              text: widget.merchant_name,
                              style: const TextStyle(
                                fontSize: 11,
                                color: MyColors.loyaltyRed,
                                  fontFamily: MyFonts.poppins,
                                  overflow: TextOverflow.ellipsis
                              )
                            )
                          ]
                        )
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.redeemed_on,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 11,
                        overflow: TextOverflow.ellipsis,
                        fontFamily: MyFonts.poppins,
                        color: MyColors.fadedBlack,
                      ),
                    ),
                  ],
                ),
              ),
              // Chevron Icon
              IconButton(
                onPressed: (){
                  print(widget.id);
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return CouponCodeBottomSheet(
                        merchant_img: widget.merchant_img,
                        id: widget.id,
                        coupon_value: widget.coupon_value,
                        code: widget.code,
                        expiry_date: widget.expiry_date,
                        merchant_name: widget.merchant_name,
                        redeemed_on: widget.redeemed_on,
                        header_text: widget.header_text,
                        is_expired: widget.is_expired,
                      );
                    },
                  );
                },
                color: MyColors.appBarColor,
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
        ),
    );
  }
}
