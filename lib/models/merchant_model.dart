// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'coupon_model.dart';

class MerchantModel {
  final String id;
  final int merchant_id;
  final String merchant_name;
  final String merchant_logo;
  final bool d_status;
  final List<CouponModel> coupons;
  MerchantModel({
    required this.id,
    required this.merchant_id,
    required this.merchant_name,
    required this.merchant_logo,
    required this.d_status,
    required this.coupons
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'merchant_id': merchant_id,
      'merchant_name': merchant_name,
      'merchant_logo': merchant_logo,
      'd_status': d_status,
      'coupons': coupons.map((x) => x.toMap()).toList(),
    };
  }

  factory MerchantModel.fromMap(Map<String, dynamic> map) {
    return MerchantModel(
      id: map['_id'] as String,
      merchant_id: map['merchant_id'] as int,
      merchant_name: map['merchant_name'] as String,
      merchant_logo: map['merchant_logo'] as String,
      d_status: map['d_status'] as bool,
      coupons: List<CouponModel>.from(
          map['coupons']?.map((x) => CouponModel.fromMap(x)))
    );
  }

  String toJson() => json.encode(toMap());

  factory MerchantModel.fromJson(String source) =>
      MerchantModel.fromMap(json.decode(source) as Map<String, dynamic>);
}