import 'package:flutter/cupertino.dart';

import '../models/dealer_master.dart';

class DealerMasterProvider extends ChangeNotifier{

  List<DealerMaster> dealer_master = [];

  // List<DealerMaster> get dealer => dealer_master;


  void fetchFullList(DealerMaster newDealer){
    dealer_master.add(newDealer);
    notifyListeners();
  }

  void removeDealer(DealerMaster dealer){
    dealer_master.remove(dealer);
    notifyListeners();
  }

  void updateSingleDealer(DealerMaster updatedDealer){

    for(int i=0; i<dealer_master.length; i++){
      print('Debug===> NEEL');

      if(dealer_master[i].id == updatedDealer.id){
        print('Debug===> FOUND');

        dealer_master[i] = updatedDealer;
        notifyListeners();
        // print(dealer_master[i].office_location_img);
        break;
      }
    }

  }
}