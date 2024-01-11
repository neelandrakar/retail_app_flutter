// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Employee {
  final String id;
  final String emp_name;
  final String username;
  final int mobno;
  final String password;
  final String? email;
  final String reporting_to;
  final int profile_id;
  final int responsible_for;
  final List<int> state_id;
  final List<int> district_id;
  final int active;
  final int division;
  final int work_on;
  final String jwt_token;
  final String profile_pic;
  final DateTime joining_date;
  Employee({
    required this.id,
    required this.emp_name,
    required this.username,
    required this.mobno,
    required this.password,
    this.email,
    required this.reporting_to,
    required this.profile_id,
    required this.responsible_for,
    required this.state_id,
    required this.district_id,
    required this.active,
    required this.division,
    required this.work_on,
    required this.jwt_token,
    required this.profile_pic,
    required this.joining_date
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'emp_name': emp_name,
      'username': username,
      'mobno': mobno,
      'password': password,
      'email': email,
      'reporting_to': reporting_to,
      'profile_id': profile_id,
      'responsible_for': responsible_for,
      'state_id': state_id,
      'district_id': district_id,
      'active': active,
      'division': division,
      'work_on': work_on,
      'jwt_token': jwt_token,
      'profile_pic': profile_pic,
      'joining_date': joining_date,
    };
  }

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['_id'] as String,
      emp_name: map['emp_name'] as String,
      username: map['username'] as String,
      mobno: map['mobno'] as int,
      password: map['password'] as String,
      email: map['email'] != null ? map['email'] as String : null,
      reporting_to: map['reporting_to'] as String,
      profile_id: map['profile_id'] as int,
      responsible_for: map['responsible_for'] as int,
      state_id : map["state_id"].cast<int>(),
      district_id : map["district_id"].cast<int>(),
      active: map['active'] as int,
      division: map['division'] as int,
      work_on: map['work_on'] as int,
      jwt_token: map['jwt_token'] as String,
      profile_pic: map['profile_pic'] as String,
      joining_date: DateTime.parse(map['joining_date']),

    );
  }

  String toJson() => json.encode(toMap());

  factory Employee.fromJson(String source) => Employee.fromMap(json.decode(source));
}
