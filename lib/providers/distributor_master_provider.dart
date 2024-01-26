import 'package:flutter/cupertino.dart';
import 'package:retail_app_flutter/models/distributor_master.dart';

import '../models/dealer_master.dart';

class DistributorMasterProvider extends ChangeNotifier{

  List<DistributorMaster> distributor_master = [];

  // List<DealerMaster> get dealer => dealer_master;


  void fetchFullList(DistributorMaster new_distributor){
    distributor_master.add(new_distributor);
    notifyListeners();
  }

  void removeDistributor(DistributorMaster distributor){
    distributor_master.remove(distributor);
    notifyListeners();
  }
}