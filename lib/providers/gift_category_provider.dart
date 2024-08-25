import 'package:flutter/cupertino.dart';
import 'package:retail_app_flutter/constants/utils.dart';
import 'package:retail_app_flutter/models/gift_category_model.dart';
import 'package:retail_app_flutter/models/loyalty_points_model.dart';

class GiftCategoryProvider extends ChangeNotifier{

  List<GiftCategoryModel> gift_categories = [];

  // List<DealerMaster> get dealer => dealer_master;


  void getGiftCategoryData(GiftCategoryModel giftCategory, BuildContext context){
    gift_categories.add(giftCategory);
    showSnackBar(context, '${giftCategory.gift_category_name} has been added');
    notifyListeners();
  }
}