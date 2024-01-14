import 'package:flutter/cupertino.dart';

import '../models/dealer_master.dart';

class DealerMasterProvider extends ChangeNotifier{

  List<DealerMaster> dealer_master = [];

  // List<DealerMaster> get dealer => dealer_master;


  void fetchFullList(DealerMaster new_dealer){
    dealer_master.add(new_dealer);
    notifyListeners();
  }

  void removeDealer(DealerMaster dealer){
    dealer_master.remove(dealer);
    notifyListeners();
  }
}