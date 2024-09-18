import 'package:flutter/cupertino.dart';
import 'package:retail_app_flutter/constants/utils.dart';
import 'package:retail_app_flutter/models/loyalty_points_model.dart';
import 'package:retail_app_flutter/models/my_vouchers.dart';


class MyVouchersProvider extends ChangeNotifier {

  List<MyVouchers> my_vouchers = [];
  bool showSnack = true;

  // List<DealerMaster> get dealer => dealer_master;


  void addVoucherCode(MyVouchers myVoucher, BuildContext context) {
    my_vouchers.add(myVoucher);
    notifyListeners();
  }
}