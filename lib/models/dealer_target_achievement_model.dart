// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'dealer_target_model.dart';

class DealerTargetAchievementModel {
  final int secondary_target_percentage;
  final List<DealerTargetModel> target_data;
  final int min_target_for_active;
  final int min_target_for_inactive;
  final int min_target_for_prospective;
  DealerTargetAchievementModel({
    required this.secondary_target_percentage,
    required this.target_data,
    required this.min_target_for_active,
    required this.min_target_for_inactive,
    required this.min_target_for_prospective,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'secondary_target_percentage': secondary_target_percentage,
      'target_data': target_data.map((x) => x.toMap()).toList(),
      'min_target_for_active': min_target_for_active,
      'min_target_for_inactive': min_target_for_inactive,
      'min_target_for_prospective': min_target_for_prospective,
    };
  }

  factory DealerTargetAchievementModel.fromMap(Map<String, dynamic> map) {
    return DealerTargetAchievementModel(
      secondary_target_percentage: map['secondary_target_percentage'] as int,
      target_data: List<DealerTargetModel>.from(map['target_data']
            .map((x) => DealerTargetModel.fromMap(x))),
      min_target_for_active: map['min_target_for_active'] as int,
      min_target_for_inactive: map['min_target_for_inactive'] as int,
      min_target_for_prospective: map['min_target_for_prospective'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory DealerTargetAchievementModel.fromJson(String source) =>
      DealerTargetAchievementModel.fromMap(json.decode(source));
}
