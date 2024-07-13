import 'package:flutter/cupertino.dart';
import 'package:retail_app_flutter/constants/utils.dart';
import 'package:retail_app_flutter/models/loyalty_points_model.dart';


class SSMLLoyaltyProvider extends ChangeNotifier{

  LoyaltyPointsModel loyaltyPointsModel = LoyaltyPointsModel(
      total_sale: 0,
      total_points: 0,
      total_pending: 0,
      invoice_wise_points: [],
      loyalty_tiers: []
  );

  // List<DealerMaster> get dealer => dealer_master;


  void getPointsData(String data, BuildContext context){
    loyaltyPointsModel = LoyaltyPointsModel.fromJson(data);
    showSnackBar(context, 'Points are fetched');
    notifyListeners();
  }
}