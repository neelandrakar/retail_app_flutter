// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DistributorMaster {
  final String id;
  final int account_id;
  final String account_name;
  final String distributor_name;
  final int sapid;
  final String contact_person_name;
  final int mobno;
  final String state_name;
  final String cluster_name;
  final List<String> district_names;
  final String main_district;
  final String block_name;
  final String street;
  final String area;
  final String police_station;
  final String city;
  final int pincode;
  final String account_status;
  final int work_for;
  final int account_type_id;
  final int working_as_dealer;
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
  final int potential;
  final String profile_image;
  final int nod;
  final DateTime created_on;
  final String created_by_name;
  final int is_doubtful;
  final int last_billing_quantity;
  final DateTime? last_billing_date;
  final int cy_primary_sale;
  final int ly_primary_sale;
  final int cy_sec_sale;
  final int total_outstanding;
  final int below_thirty;
  final int thirtyOne_to_fourtyFive;
  final int fourtySix_to_sixty;
  final int sixtyOne_to_ninety;
  final int ninetyOne_to_above;
  final int security_deposite;
  final int created_before;
  DistributorMaster({
    required this.id,
    required this.account_id,
    required this.account_name,
    required this.distributor_name,
    required this.sapid,
    required this.contact_person_name,
    required this.mobno,
    required this.state_name,
    required this.cluster_name,
    required this.district_names,
    required this.main_district,
    required this.block_name,
    required this.street,
    required this.area,
    required this.police_station,
    required this.city,
    required this.pincode,
    required this.account_status,
    required this.work_for,
    required this.account_type_id,
    required this.working_as_dealer,
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
    required this.potential,
    required this.profile_image,
    required this.nod,
    required this.created_on,
    required this.created_by_name,
    required this.is_doubtful,
    required this.last_billing_quantity,
    required this.last_billing_date,
    required this.cy_primary_sale,
    required this.ly_primary_sale,
    required this.cy_sec_sale,
    required this.total_outstanding,
    required this.below_thirty,
    required this.thirtyOne_to_fourtyFive,
    required this.fourtySix_to_sixty,
    required this.sixtyOne_to_ninety,
    required this.ninetyOne_to_above,
    required this.security_deposite,
    required this.created_before,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'account_id': account_id,
      'account_name': account_name,
      'distributor_name': distributor_name,
      'sapid': sapid,
      'contact_person_name': contact_person_name,
      'mobno': mobno,
      'state_name': state_name,
      'cluster_name': cluster_name,
      'district_names': district_names,
      'main_district_name': main_district,
      'block_name': block_name,
      'street': street,
      'area': area,
      'police_station': police_station,
      'city': city,
      'pincode': pincode,
      'account_status': account_status,
      'work_for': work_for,
      'account_type_id': account_type_id,
      'working_as_dealer': working_as_dealer,
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
      'potential': potential,
      'profile_image': profile_image,
      'nod': nod,
      'created_on': created_on.millisecondsSinceEpoch,
      'created_by_name': created_by_name,
      'is_doubtful': is_doubtful,
      'last_billing_quantity': last_billing_quantity,
      'last_billing_date': last_billing_date?.millisecondsSinceEpoch,
      'cy_primary_sale': cy_primary_sale,
      'ly_primary_sale': ly_primary_sale,
      'cy_sec_sale': cy_sec_sale,
      'total_outstanding': total_outstanding,
      'below_thirty': below_thirty,
      'thirtyOne_to_fourtyFive': thirtyOne_to_fourtyFive,
      'fourtySix_to_sixty': fourtySix_to_sixty,
      'sixtyOne_to_ninety': sixtyOne_to_ninety,
      'ninetyOne_to_above': ninetyOne_to_above,
      'security_deposite': security_deposite,
      'created_before': created_before,
    };
  }

  factory DistributorMaster.fromMap(Map<String, dynamic> map) {
    return DistributorMaster(
      id: map['_id'] as String,
      account_id: map['account_id'] as int,
      account_name: map['account_name'] as String,
      distributor_name: map['distributor_name'] as String,
      sapid: map['sapid'] as int,
      contact_person_name: map['contact_person_name'] as String,
      mobno: map['mobno'] as int,
      state_name: map['state_name'] as String,
      cluster_name: map['cluster_name'] as String,
      main_district: map['main_district_name'] as String,
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
      working_as_dealer: map['working_as_dealer'] as int,
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
      potential: map['potential'] as int,
      profile_image: map['profile_image'] as String,
      nod: map['nod'] as int,
      created_on: DateTime.parse(map['created_on']),
      created_by_name: map['created_by_name'] as String,
      is_doubtful: map['is_doubtful'] as int,
      last_billing_quantity: map['last_billing_quantity'] as int,
      last_billing_date: map['last_billing_date'] != null ? DateTime.parse(map['last_billing_date']) : null,
      cy_primary_sale: map['cy_primary_sale'] as int,
      ly_primary_sale: map['ly_primary_sale'] as int,
      cy_sec_sale: map['cy_sec_sale'] as int,
      total_outstanding: map['total_outstanding'] as int,
      below_thirty: map['below_thirty'] as int,
      thirtyOne_to_fourtyFive: map['thirtyOne_to_fourtyFive'] as int,
      fourtySix_to_sixty: map['fourtySix_to_sixty'] as int,
      sixtyOne_to_ninety: map['sixtyOne_to_ninety'] as int,
      ninetyOne_to_above: map['ninetyOne_to_above'] as int,
      security_deposite: map['security_deposite'] as int,
      created_before: map['created_before'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory DistributorMaster.fromJson(String source) => DistributorMaster.fromMap(json.decode(source));
}
