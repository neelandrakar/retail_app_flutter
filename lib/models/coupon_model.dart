// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CouponModel {
  final String id;
  final int coupon_id;
  final int merchant_id;
  final int coupon_value;
  final bool d_status;
  CouponModel({
    required this.id,
    required this.coupon_id,
    required this.merchant_id,
    required this.coupon_value,
    required this.d_status,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'coupon_id': coupon_id,
      'merchant_id': merchant_id,
      'coupon_value': coupon_value,
      'd_status': d_status,
    };
  }

  factory CouponModel.fromMap(Map<String, dynamic> map) {
    return CouponModel(
      id: map['_id'] as String,
      coupon_id: map['coupon_id'] as int,
      merchant_id: map['merchant_id'] as int,
      coupon_value: map['coupon_value'] as int,
      d_status: map['d_status'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory CouponModel.fromJson(String source) =>
      CouponModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
