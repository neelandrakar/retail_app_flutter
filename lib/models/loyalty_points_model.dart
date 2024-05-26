// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:retail_app_flutter/models/invoice_wise_points_model.dart';
import 'package:retail_app_flutter/models/loyalty_tier.dart';

class LoyaltyPointsModel {
  final int total_sale;
  final List<InvoiceWisePointsModel>? invoice_wise_points;
  final List<LoyaltyTier> loyalty_tiers;

  LoyaltyPointsModel({
    required this.total_sale,
    this.invoice_wise_points,
    required this.loyalty_tiers
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'total_sale': total_sale,
      'invoiceWisePoints': invoice_wise_points?.map((x) => x.toMap()).toList(),
      'loyalty_tiers': loyalty_tiers.map((x) => x.toMap()).toList(),
    };
  }

  factory LoyaltyPointsModel.fromMap(Map<String, dynamic> map) {
    return LoyaltyPointsModel(
        total_sale: map['total_sale'] as int,
        invoice_wise_points: List<InvoiceWisePointsModel>.from(map['details']
            .map((x) => InvoiceWisePointsModel.fromMap(x))),
        loyalty_tiers: List<LoyaltyTier>.from(map['tier_details']
            .map((x) => LoyaltyTier.fromMap(x)))
    );
  }

  String toJson() => json.encode(toMap());

  factory LoyaltyPointsModel.fromJson(String source) =>
      LoyaltyPointsModel.fromMap(json.decode(source));
}
