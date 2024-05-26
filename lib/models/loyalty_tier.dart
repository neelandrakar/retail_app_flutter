// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class LoyaltyTier {
  final String id;
  final String tier_name;
  final int tier_id;
  final int min_points;
  final int max_points;
  final bool d_status;
  LoyaltyTier({
    required this.id,
    required this.tier_name,
    required this.tier_id,
    required this.min_points,
    required this.max_points,
    required this.d_status,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tier_name': tier_name,
      'tier_id': tier_id,
      'min_points': min_points,
      'max_points': max_points,
      'd_status': d_status,
      '_id': id,
    };
  }

  factory LoyaltyTier.fromMap(Map<String, dynamic> map) {
    return LoyaltyTier(
      tier_name: map['tier_name'] as String,
      tier_id: map['tier_id'] as int,
      min_points: map['min_points'] as int,
      max_points: map['max_points'] as int,
      d_status: map['d_status'] as bool,
      id: map['_id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory LoyaltyTier.fromJson(String source) =>
      LoyaltyTier.fromMap(json.decode(source));
}
