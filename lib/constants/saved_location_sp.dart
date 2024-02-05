import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/saved_visit_locations.dart';

class SavedLocationSP {
  static const String _savedVisitLocationsKey = 'savedVisitLocations';

  static Future<List<SavedVisitLocation>> getSavedVisitLocations() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_savedVisitLocationsKey) ?? '[]';
    final jsonList = json.decode(jsonString) as List;
    return jsonList.map((json) => SavedVisitLocation.fromJson(json)).toList();
  }

  static Future<void> saveSavedVisitLocations(SavedVisitLocation location) async {
    final prefs = await SharedPreferences.getInstance();
    List<SavedVisitLocation> saved_locations = await getSavedVisitLocations();
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
}