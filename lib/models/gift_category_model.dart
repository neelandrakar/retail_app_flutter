import 'dart:convert';
import 'package:retail_app_flutter/models/merchant_model.dart';

class GiftCategoryModel {
  final String id;
  final int gift_category_id;
  final String gift_category_name;
  final String gift_category_logo;
  final bool d_status;
  final List<MerchantModel> merchants;
  GiftCategoryModel({
    required this.id,
    required this.gift_category_id,
    required this.gift_category_name,
    required this.gift_category_logo,
    required this.d_status,
    required this.merchants,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'gift_category_id': gift_category_id,
      'gift_category_name': gift_category_name,
      'gift_category_logo': gift_category_logo,
      'd_status': d_status,
      'merchants': merchants.map((x) => x.toMap()).toList(),
    };
  }

  factory GiftCategoryModel.fromMap(Map<String, dynamic> map) {
    return GiftCategoryModel(
      id: map['_id'] as String,
      gift_category_id: map['gift_category_id'] as int,
      gift_category_name: map['gift_category_name'] as String,
      gift_category_logo: map['gift_category_logo'] as String,
      d_status: map['d_status'] as bool,
      merchants: List<MerchantModel>.from(
          map['merchants']?.map((x) => MerchantModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory GiftCategoryModel.fromJson(String source) =>
      GiftCategoryModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
