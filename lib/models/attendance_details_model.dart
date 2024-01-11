// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AttendanceDetailsModel {
  final DateTime date;
  late int login_status;
  late DateTime? login_time;
  late DateTime? logout_time;
  late int checkin_deviation;
  late int checkout_deviation;
  late int? field_time;
  late DateTime? checkin_time;
  late DateTime? checkout_time;
  late int startKM;
  late String startOdometer;
  late int endKM;
  late String endOdometer;
  late int vehicle;
  AttendanceDetailsModel({
    required this.date,
    required this.login_status,
    required this.login_time,
    required this.logout_time,
    required this.checkin_deviation,
    required this.checkout_deviation,
    required this.field_time,
    required this.checkin_time,
    required this.checkout_time,
    required this.startKM,
    required this.startOdometer,
    required this.endKM,
    required this.endOdometer,
    required this.vehicle,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date': date.millisecondsSinceEpoch,
      'logged_in': login_status,
      'login_time': login_time?.millisecondsSinceEpoch,
      'logout_time': logout_time?.millisecondsSinceEpoch,
      'checkin_deviation': checkin_deviation,
      'checkout_deviation': checkout_deviation,
      'field_time': field_time,
      'checkin_time': checkin_time?.millisecondsSinceEpoch,
      'checkout_time': checkout_time?.millisecondsSinceEpoch,
      'startKM': startKM,
      'startOdometer': startOdometer,
      'endKM': endKM,
      'endOdometer': endOdometer,
      'vehicle': vehicle,
    };
  }

  factory AttendanceDetailsModel.fromMap(Map<String, dynamic> map) {
    return AttendanceDetailsModel(
      date: DateTime.parse(map['date']),
      login_status: map['login_status'] as int,
      login_time: map['login_time'] != null ? DateTime.parse(map['login_time']) : null,
      logout_time: map['logout_time'] != null ? DateTime.parse(map['logout_time']) : null,
      checkin_deviation: map['checkin_deviation'] as int,
      checkout_deviation: map['checkout_deviation'] as int,
      field_time: map['field_time'] !=null ? map['field_time'] : null,
      checkin_time: map['checkin_time'] != null ? DateTime.parse(map['checkin_time']) : null,
      checkout_time: map['checkout_time'] != null ? DateTime.parse(map['checkout_time']) : null,
      startKM: map['startKM'] as int,
      startOdometer: map['startOdometer'] as String,
      endKM: map['endKM'] as int,
      endOdometer: map['endOdometer'] as String,
      vehicle: map['vehicle'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory AttendanceDetailsModel.fromJson(String source) =>
      AttendanceDetailsModel.fromMap(json.decode(source));
}
