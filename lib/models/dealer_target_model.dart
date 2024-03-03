// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DealerTargetModel {
  final int account_id;
  final String dealer_name;
  final String initial_status;
  final String account_status;
  final int primary_target;
  final int cm_achievement;
  final int lm_achievement;
  final List<String> district_names;
  final List<int> district_ids;
  DealerTargetModel({
    required this.account_id,
    required this.dealer_name,
    required this.initial_status,
    required this.account_status,
    required this.primary_target,
    required this.cm_achievement,
    required this.lm_achievement,
    required this.district_names,
    required this.district_ids,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'account_id': account_id,
      'dealer_name': dealer_name,
      'initial_status': initial_status,
      'account_status': account_status,
      'primary_target': primary_target,
      'cm_achievement': cm_achievement,
      'lm_achievement': lm_achievement,
      'district_names': district_names,
      'district_ids': district_ids,
    };
  }

  factory DealerTargetModel.fromMap(Map<String, dynamic> map) {
    return DealerTargetModel(
        account_id: map['account_id'] as int,
        dealer_name: map['dealer_name'] as String,
        initial_status: map['initial_status'] as String,
        account_status: map['account_status'] as String,
        primary_target: map['primary_target'] as int,
        cm_achievement: map['cm_achievement'] as int,
        lm_achievement: map['lm_achievement'] as int,
        district_names: List<String>.from((map['district_names'] as List)),
        district_ids : map["district_ids"].cast<int>(),
    );
  }

  String toJson() => json.encode(toMap());

  factory DealerTargetModel.fromJson(String source) =>
      DealerTargetModel.fromMap(json.decode(source));
}
