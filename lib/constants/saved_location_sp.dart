import 'dart:convert';
import 'dart:ui';
import 'package:retail_app_flutter/models/last_checkin_data.dart';
import 'package:retail_app_flutter/models/pending_data_model.dart';
import 'package:retail_app_flutter/models/submitted_visit_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/saved_visit_locations.dart';

class SavedLocationSP {
  static const String _savedVisitLocationsKey = 'savedVisitLocations';
  static const String _lastCheckInData = 'lastCheckInData';
  static const String _pendingData = 'pendingDatas';

  static Future<List<SavedVisitLocation>> getSavedVisitLocations() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_savedVisitLocationsKey) ?? '[]';
    final jsonList = json.decode(jsonString) as List;
    return jsonList.map((json) => SavedVisitLocation.fromJson(json)).toList();
  }

  static Future<void> saveSavedVisitLocations(SavedVisitLocation location) async {
    final prefs = await SharedPreferences.getInstance();
    List<SavedVisitLocation> saved_locations = await getSavedVisitLocations();
    for(int i=0; i<saved_locations.length; i++){
      if(saved_locations[i].account_obj_id==location.account_obj_id){
        saved_locations.removeAt(i);
        print('Existing Location is deleted');
      }
    }
    saved_locations.add(location);
    print('debug===> '+ saved_locations.length.toString());
    //var jsonList = locations.map((location) => location.toJson()).toList();
    final jsonString = json.encode(saved_locations);
    await prefs.setString(_savedVisitLocationsKey, jsonString);
    print('location is saved!');
  }

  static Future<void> clearSavedVisitLocationsKey() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_savedVisitLocationsKey);
    print('cleared');
  }

  static Future<void> clearLastCheckInData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastCheckInData);
    print('cleared');
  }

  static Future<LastCheckInData> getLastCheckInData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_lastCheckInData) ?? '';
    //print(jsonDecode(jsonString));
    dynamic jsonRes = 'NA';
    if (jsonString != '') {
      jsonRes = jsonDecode(jsonString);
      return LastCheckInData.fromJson(jsonRes);
    } else {
      return LastCheckInData(account_obj_id: '', location_type: 0, check_in_time: DateTime.fromMillisecondsSinceEpoch(1607414860000), added_on: DateTime.now());
    }
  }

  static Future<void> saveLastCheckInTime(LastCheckInData newLastCheckInData) async {
    final prefs = await SharedPreferences.getInstance();
    LastCheckInData lastCheckInData = await getLastCheckInData();

    if (lastCheckInData.account_obj_id == '') {
      print('no data found');
      lastCheckInData = newLastCheckInData;
    } else {
      print('last===> ' + lastCheckInData.account_obj_id + " == " +
          lastCheckInData.location_type.toString());
      print('new===> ' + newLastCheckInData.account_obj_id + " == " +
          newLastCheckInData.location_type.toString());

      if (lastCheckInData.account_obj_id != newLastCheckInData.account_obj_id) {
        print('new check in');
        lastCheckInData = newLastCheckInData;
      } else
      if (lastCheckInData.account_obj_id == newLastCheckInData.account_obj_id) {
        if (lastCheckInData.location_type.toString() !=
            newLastCheckInData.location_type.toString()) {
          print('new location for same account');
          lastCheckInData = newLastCheckInData;
        }
      }
    }
      print('debug===> ' + lastCheckInData.toString());
      //var jsonList = locations.map((location) => location.toJson()).toList();
      final jsonString = json.encode(lastCheckInData);
      await prefs.setString(_lastCheckInData, jsonString);
      print('check in time is saved!');
  }

  static Future<PendingDataModel> getPendingData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_pendingData) ?? '';
    //print(jsonDecode(jsonString));
    dynamic jsonRes = 'NA';
    if (jsonString != '') {
      jsonRes = jsonDecode(jsonString);
      return PendingDataModel.fromJson(jsonRes);
    } else {
      return PendingDataModel(
          stored_visits: []
      );
    }
  }

  static Future<void> storeNewVisit(SubmittedVisitModel newStoredVisit, VoidCallback onSuccess) async {
    final prefs = await SharedPreferences.getInstance();
    bool addData = false;
    PendingDataModel pendingData = await getPendingData();
    List<SubmittedVisitModel> pre_stored_visits = pendingData.stored_visits;

    //Checking if there is no stored visits. Then data is added immediately;
    if(pre_stored_visits.isEmpty){
      addData = true;
    } else {
      for (int i = 0; i < pre_stored_visits.length; i++) {
        if (pre_stored_visits[i].account_obj_id !=
            newStoredVisit.account_obj_id) {
          addData = true;
        } else {
          if (pre_stored_visits[i].is_sent == true) {
            addData = true;
          }
        }
      }
    }

    if(addData){
      pendingData.stored_visits.add(newStoredVisit);
    }

    final jsonString = json.encode(pendingData);
    await prefs.setString(_pendingData, jsonString);
    onSuccess.call();
  }

  static Future<void> clearStoredVisits() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_pendingData);
    print('cleared');
  }
}