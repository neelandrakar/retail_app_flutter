import 'package:flutter/material.dart';
import 'package:retail_app_flutter/constants/my_colors.dart';
import 'package:retail_app_flutter/constants/my_fonts.dart';

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
        height: 100,
        decoration: BoxDecoration(
          color: MyColors.boneWhite,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Row(
            children: [
              // QR Code Image
              Image.network(
                widget.merchant_img, // Replace with your actual image asset
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
              SizedBox(width: 16),
              // Coupon Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Coupon worth ₹${widget.coupon_value}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: MyFonts.poppins
                      ),
                    ),
                    SizedBox(height: 4),
                    RichText(text: TextSpan(
                      children: [
                        TextSpan(
                          text: widget.expiry_date,
                          style: TextStyle( fontSize: 12, color: Colors.grey[600], ),),
                        TextSpan(
                          text: widget.merchant_name,
                          style: TextStyle( fontSize: 12, color: MyColors.loyaltyRed, ),)
                      ]
                    )
                    ),
                    SizedBox(height: 2),
                    Text(
                      widget.redeemed_on,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              // Chevron Icon
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
    );
  }
}
