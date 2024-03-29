// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class EngineerMaster {
  final String id;
  final int account_id;
  final String account_name;
  final String parent_dealer;
  final String contact_person_name;
  final int mobno;
  final String state_name;
  final String cluster_name;
  final List<String> district_names;
  final String block_name;
  final String street;
  final String area;
  final String police_station;
  final String city;
  final int pincode;
  final String account_status;
  final int work_for;
  final int account_type_id;
  final int d_status;
  final String latitude;
  final String longitude;
  final String office_latitude;
  final String office_longitude;
  final String referred_by;
  final String tagged_rsm;
  final String tagged_asm;
  final String tagged_me;
  final String tagged_so;
  final String profile_image;
  final DateTime created_on;
  final String created_by_name;
  final int is_doubtful;
  final int created_before;
  final int kyc_approval;
  final String engineer_type_name;
  EngineerMaster({
    required this.id,
    required this.account_id,
    required this.account_name,
    required this.contact_person_name,
    required this.parent_dealer,
    required this.mobno,
    required this.state_name,
    required this.cluster_name,
    required this.district_names,
    required this.block_name,
    required this.street,
    required this.area,
    required this.police_station,
    required this.city,
    required this.pincode,
    required this.account_status,
    required this.work_for,
    required this.account_type_id,
    required this.d_status,
    required this.latitude,
    required this.longitude,
    required this.office_latitude,
    required this.office_longitude,
    required this.referred_by,
    required this.tagged_rsm,
    required this.tagged_asm,
    required this.tagged_me,
    required this.tagged_so,
    required this.profile_image,
    required this.created_on,
    required this.created_by_name,
    required this.is_doubtful,
    required this.created_before,
    required this.engineer_type_name,
    required this.kyc_approval,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'account_id': account_id,
      'account_name': account_name,
      'parent_dealer': parent_dealer,
      'kyc_approval': kyc_approval,
      'contact_person_name': contact_person_name,
      'mobno': mobno,
      'state_name': state_name,
      'cluster_name': cluster_name,
      'district_names': district_names,
      'block_name': block_name,
      'street': street,
      'area': area,
      'police_station': police_station,
      'city': city,
      'pincode': pincode,
      'account_status': account_status,
      'work_for': work_for,
      'account_type_id': account_type_id,
      'd_status': d_status,
      'latitude': latitude,
      'longitude': longitude,
      'office_latitude': office_latitude,
      'office_longitude': office_longitude,
      'referred_by': referred_by,
      'tagged_rsm': tagged_rsm,
      'tagged_asm': tagged_asm,
      'tagged_me': tagged_me,
      'tagged_so': tagged_so,
      'engineer_type_name': engineer_type_name,
      'profile_image': profile_image,
      'created_on': created_on.millisecondsSinceEpoch,
      'created_by_name': created_by_name,
      'is_doubtful': is_doubtful,
      'created_before': created_before,
    };
  }

  factory EngineerMaster.fromMap(Map<String, dynamic> map) {
    return EngineerMaster(
      id: map['_id'] as String,
      account_id: map['account_id'] as int,
      account_name: map['account_name'] as String,
      parent_dealer: map['parent_dealer'] as String,
      kyc_approval: map['kyc_approval'] as int,
      contact_person_name: map['contact_person_name'] as String,
      mobno: map['mobno'] as int,
      state_name: map['state_name'] as String,
      cluster_name: map['cluster_name'] as String,
      district_names: List<String>.from((map['district_names'] as List)),
      block_name: map['block_name'] as String,
      street: map['street'] as String,
      area: map['area'] as String,
      police_station: map['police_station'] as String,
      city: map['city'] as String,
      pincode: map['pincode'] as int,
      account_status: map['account_status'] as String,
      work_for: map['work_for'] as int,
      account_type_id: map['account_type_id'] as int,
      d_status: map['d_status'] as int,
      latitude: map['latitude'] as String,
      longitude: map['longitude'] as String,
      office_latitude: map['office_latitude'] as String,
      office_longitude: map['office_longitude'] as String,
      referred_by: map['referred_by'] as String,
      tagged_rsm: map['tagged_rsm'] as String,
      tagged_asm: map['tagged_asm'] as String,
      tagged_me: map['tagged_me'] as String,
      tagged_so: map['tagged_so'] as String,
      engineer_type_name: map['engineer_type_name'] as String,
      profile_image: map['profile_image'] as String,
      created_on: DateTime.parse(map['created_on']),
      created_by_name: map['created_by_name'] as String,
      is_doubtful: map['is_doubtful'] as int,
      created_before: map['created_before'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory EngineerMaster.fromJson(String source) => EngineerMaster.fromMap(json.decode(source));
}
