import 'package:flutter/foundation.dart';
import 'package:retail_app_flutter/models/attendance_screen_model.dart';
import 'package:retail_app_flutter/models/dealer_target_achievement_model.dart';

class DealerTargetAchievementProvider extends ChangeNotifier{

  DealerTargetAchievementModel dealerTargetAchievementModel = DealerTargetAchievementModel(
      secondary_target_percentage: 0,
      target_data: [],
      min_target_for_active: 0,
      min_target_for_inactive: 0,
      min_target_for_prospective: 0
  );

  DealerTargetAchievementModel get dealerTargets => dealerTargetAchievementModel;

  void setDealerTargetModel(String newTargetModel){
    dealerTargetAchievementModel = DealerTargetAchievementModel.fromJson(newTargetModel);
    notifyListeners();
  }
}