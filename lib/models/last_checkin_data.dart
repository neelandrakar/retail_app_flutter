import 'dart:convert';

class LastCheckInData {
  final String account_obj_id;
  final int location_type;
  final DateTime check_in_time;
  final DateTime added_on;

  LastCheckInData({
    required this.account_obj_id,
    required this.location_type,
    required this.check_in_time,
    required this.added_on,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'account_obj_id': account_obj_id,
      'location_type': location_type,
      'check_in_time': check_in_time.toIso8601String(),
      'added_on': added_on.toIso8601String(),
    };
  }

  factory LastCheckInData.fromMap(Map<String, dynamic> json) {
    return LastCheckInData(
      account_obj_id: json['account_obj_id'] as String,
      location_type: json['location_type'] as int,
      check_in_time: DateTime.parse(json['check_in_time'] as String),
      added_on: DateTime.parse(json['added_on'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory LastCheckInData.fromJson(String source) =>
      LastCheckInData.fromMap(json.decode(source));
}