import 'dart:convert';

class SavedVisitLocation {
  final String account_obj_id;
  final int location_type;
  final double account_latitude;
  final double account_longitude;
  final DateTime added_on;

  SavedVisitLocation({
    required this.account_obj_id,
    required this.location_type,
    required this.account_latitude,
    required this.account_longitude,
    required this.added_on,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'account_obj_id': account_obj_id,
      'location_type': location_type,
      'account_latitude': account_latitude,
      'account_longitude': account_longitude,
      'added_on': added_on.toIso8601String(),
    };
  }

  factory SavedVisitLocation.fromMap(Map<String, dynamic> json) {
    return SavedVisitLocation(
      account_obj_id: json['account_obj_id'] as String,
      location_type: json['location_type'] as int,
      account_latitude: json['account_latitude'] as double,
      account_longitude: json['account_longitude'] as double,
      added_on: DateTime.parse(json['added_on'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory SavedVisitLocation.fromJson(String source) =>
      SavedVisitLocation.fromMap(json.decode(source));
}