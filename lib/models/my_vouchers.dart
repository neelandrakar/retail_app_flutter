// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MyVouchers {
  final String id;
  final int coupon_code_id;
  final String header_text;
  final String merchant_name;
  final String merchant_img;
  final String code;
  final int coupon_value;
  final String expiry_date;
  final String redeemed_on;
  final bool is_expired;
  MyVouchers({
    required this.id,
    required this.coupon_code_id,
    required this.header_text,
    required this.merchant_name,
    required this.merchant_img,
    required this.code,
    required this.coupon_value,
    required this.expiry_date,
    required this.redeemed_on,
    required this.is_expired,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'coupon_code_id': coupon_code_id,
      'header_text': header_text,
      'merchant_name': merchant_name,
      'merchant_img': merchant_img,
      'code': code,
      'coupon_value': coupon_value,
      'expiry_date': expiry_date,
      'redeemed_on': redeemed_on,
      'is_expired': is_expired,
    };
  }

  factory MyVouchers.fromMap(Map<String, dynamic> map) {
    return MyVouchers(
      id: map['id'] as String,
      coupon_code_id: map['coupon_code_id'] as int,
      header_text: map['header_text'] as String,
      merchant_name: map['merchant_name'] as String,
      merchant_img: map['merchant_img'] as String,
      code: map['code'] as String,
      coupon_value: map['coupon_value'] as int,
      expiry_date: map['expiry_date'] as String,
      redeemed_on: map['redeemed_on'] as String,
      is_expired: map['is_expired'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory MyVouchers.fromJson(String source) =>
      MyVouchers.fromMap(json.decode(source) as Map<String, dynamic>);
}
