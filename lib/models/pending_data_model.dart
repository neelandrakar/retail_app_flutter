// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:retail_app_flutter/models/submitted_visit_model.dart';

class PendingDataModel {
  final List<SubmittedVisitModel> stored_visits;
  PendingDataModel({
    required this.stored_visits,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'stored_visits': stored_visits.map((x) => x.toMap()).toList(),
    };
  }

  factory PendingDataModel.fromMap(Map<String, dynamic> map) {
    return PendingDataModel(
        stored_visits: List<SubmittedVisitModel>.from(
            map['stored_visits'].map((x) => SubmittedVisitModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory PendingDataModel.fromJson(String source) =>
      PendingDataModel.fromMap(json.decode(source));
}
