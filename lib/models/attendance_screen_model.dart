// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:retail_app_flutter/models/attendance_details_model.dart';

class AttendanceScreenModel {
  final String cycle_start_date;
  final String cycle_end_date;
  final DateTime current_date;
  late bool hasLoggedInToday;
  final List<AttendanceDetailsModel> get_attendance;
  AttendanceScreenModel({
    required this.cycle_start_date,
    required this.cycle_end_date,
    required this.current_date,
    required this.hasLoggedInToday,
    required this.get_attendance,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cycle_start_date': cycle_start_date,
      'cycle_end_date': cycle_end_date,
      'current_date': current_date,
      'hasLoggedInToday': hasLoggedInToday,
      'get_attendance': get_attendance.map((x) => x.toMap()).toList(),
    };
  }

  factory AttendanceScreenModel.fromMap(Map<String, dynamic> map) {
    return AttendanceScreenModel(
        cycle_start_date: map['cycle_start_date'] as String,
        cycle_end_date: map['cycle_end_date'] as String,
        current_date: DateTime.parse(map['current_date']),
        hasLoggedInToday: map['hasLoggedInToday'] as bool,
        get_attendance: List<AttendanceDetailsModel>.from(map['get_attendance']
            .map((x) => AttendanceDetailsModel.fromMap(x))));
  }

  String toJson() => json.encode(toMap());

  factory AttendanceScreenModel.fromJson(String source) =>
      AttendanceScreenModel.fromMap(json.decode(source));
}
