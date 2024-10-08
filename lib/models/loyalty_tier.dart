// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class LoyaltyTier {
  final String id;
  final String tier_name;
  final String tier_img;
  final String tier_detail;
  final int tier_id;
  final int min_points;
  final int max_points;
  final bool d_status;
  final int is_current;
  final int till_next_tier;
  LoyaltyTier({
    required this.id,
    required this.tier_name,
    required this.tier_img,
    required this.tier_detail,
    required this.tier_id,
    required this.min_points,
    required this.max_points,
    required this.d_status,
    required this.is_current,
    required this.till_next_tier,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tier_name': tier_name,
      'tier_id': tier_id,
      'tier_img':tier_img,
      'tier_detail':tier_detail,
      'min_points': min_points,
      'max_points': max_points,
      'd_status': d_status,
      '_id': id,
      'is_current': is_current,
      'till_next_tier': till_next_tier,
    };
  }

  factory LoyaltyTier.fromMap(Map<String, dynamic> map) {
    return LoyaltyTier(
      tier_name: map['tier_name'] as String,
      tier_img: map['tier_img'] as String,
      tier_detail: map['tier_detail'] as String,
      tier_id: map['tier_id'] as int,
      min_points: map['min_points'] as int,
      max_points: map['max_points'] as int,
      is_current: map['is_current'] as int,
      till_next_tier: map['till_next_tier'] as int,
      d_status: map['d_status'] as bool,
      id: map['_id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory LoyaltyTier.fromJson(String source) =>
      LoyaltyTier.fromMap(json.decode(source));
}
