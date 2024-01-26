import 'package:flutter/cupertino.dart';
import 'package:retail_app_flutter/models/engineer_master.dart';

import '../models/dealer_master.dart';

class EngineerMasterProvider extends ChangeNotifier{

  List<EngineerMaster> engineer_master = [];

  // List<DealerMaster> get dealer => dealer_master;


  void fetchFullList(EngineerMaster new_engineer){
    engineer_master.add(new_engineer);
    notifyListeners();
  }

  void removeEngineer(EngineerMaster engineer){
    engineer_master.remove(engineer);
    notifyListeners();
  }
}