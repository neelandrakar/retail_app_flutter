import 'dart:convert';
import 'package:retail_app_flutter/models/last_checkin_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/saved_visit_locations.dart';

class SavedLocationSP {
  static const String _savedVisitLocationsKey = 'savedVisitLocations';
  static const String _lastCheckInData = 'lastCheckInData';

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
    print(jsonDecode(jsonString));
    final jsonRes = jsonDecode(jsonString);
    return LastCheckInData.fromJson(jsonRes);
  }

  static Future<void> saveLastCheckInTime(LastCheckInData newLastCheckInData) async {
    final prefs = await SharedPreferences.getInstance();
    LastCheckInData lastCheckInData = await getLastCheckInData();
    if(lastCheckInData.account_obj_id != newLastCheckInData.account_obj_id && lastCheckInData.location_type != newLastCheckInData.location_type){
      print('new check in');
      lastCheckInData = newLastCheckInData;
    }
    print('debug===> '+ lastCheckInData.toString());
    //var jsonList = locations.map((location) => location.toJson()).toList();
    final jsonString = json.encode(lastCheckInData);
    await prefs.setString(_lastCheckInData, jsonString);
    print('check in time is saved!');
  }
}