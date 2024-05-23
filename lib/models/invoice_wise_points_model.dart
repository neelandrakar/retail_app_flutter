// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class InvoiceWisePointsModel {
  final String invoice_no;
  final int total_quantity;
  final DateTime date;
  final String dealer_name;
  final int earned_points;
  final int point_type;
  final int sapid;
  final String string_date;
  InvoiceWisePointsModel(
      {required this.invoice_no,
      required this.total_quantity,
      required this.date,
      required this.dealer_name,
      required this.earned_points,
      required this.point_type,
      required this.sapid,
      required this.string_date});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': invoice_no,
      'total_quantity': total_quantity,
      'date': date.millisecondsSinceEpoch,
      'dealer_name': dealer_name,
      'earned_points': earned_points,
      'point_type': point_type,
      'sapid': sapid,
      'string_date': string_date
    };
  }

  factory InvoiceWisePointsModel.fromMap(Map<String, dynamic> map) {
    return InvoiceWisePointsModel(
        invoice_no: map['_id'] as String,
        total_quantity: map['total_quantity'] as int,
        dealer_name: map['dealer_name'] as String,
        date: DateTime.parse(map['date']),
        earned_points: map['earned_points'] as int,
        point_type: map['point_type'] as int,
        sapid: map['sapid'] as int,
        string_date: map['string_date'] as String);
  }

  String toJson() => json.encode(toMap());

  factory InvoiceWisePointsModel.fromJson(String source) =>
      InvoiceWisePointsModel.fromMap(json.decode(source));
}
