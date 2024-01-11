import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class DashboardMenu {
  final String id;
  final String menu_title;
  final String menu_subtitle;
  final String menu_image;
  final int menu_type;
  final String menu_color;
  final int d_status;
  final int menu_division;
  final int order;
  final DateTime created_on;
  DashboardMenu({
    required this.id,
    required this.menu_title,
    required this.menu_subtitle,
    required this.menu_image,
    required this.menu_type,
    required this.menu_color,
    required this.d_status,
    required this.menu_division,
    required this.order,
    required this.created_on,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'menu_title': menu_title,
      'menu_subtitle': menu_subtitle,
      'menu_image': menu_image,
      'menu_type': menu_type,
      'menu_color': menu_color,
      'd_status': d_status,
      'menu_division': menu_division,
      'order': order,
      'created_on': created_on,
    };
  }

  factory DashboardMenu.fromMap(Map<String, dynamic> map) {
    return DashboardMenu(
      id: map['_id'] as String,
      menu_title: map['menu_title'] as String,
      menu_subtitle: map['menu_subtitle'] as String,
      menu_image: map['menu_image'] as String,
      menu_type: map['menu_type'] as int,
      menu_color: map['menu_color'] as String,
      d_status: map['d_status'] as int,
      menu_division: map['menu_division'] as int,
      order: map['order'] as int,
      created_on: DateTime.parse(map['created_on']),
    );
  }

  String toJson() => json.encode(toMap());

  factory DashboardMenu.fromJson(String source) =>
      DashboardMenu.fromMap(json.decode(source));
}
