import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:retail_app_flutter/attendance/widgets/data_sync_item_card.dart';
import 'package:retail_app_flutter/constants/my_colors.dart';
import 'package:retail_app_flutter/constants/my_fonts.dart';

import '../attendance/services/attendance_services.dart';
import 'custom_elevated_button.dart';

class DataSyncLoader extends StatefulWidget {
  final VoidCallback onSuccessCallBack;
  const DataSyncLoader({super.key, required this.onSuccessCallBack});

  @override
  State<DataSyncLoader> createState() => _DataSyncLoaderState();
}

class _DataSyncLoaderState extends State<DataSyncLoader> {

  List<Map<String, dynamic>> dataSyncList = [
    {
      'item_name': "Fetching user's data",
      'item_status': false
    },
  ];

  bool showCloseButton = false;

  void updateDataSync(VoidCallback onSuccess) async {

    AttendanceServices attendanceServices = AttendanceServices();

    await attendanceServices.updateEmployeeData(context: context, onSuccess: () async {
      dataSyncList[0]['item_status']=true;
      dataSyncList.add({
        'item_name': "Fetching tagged dealer's data",
        'item_status': false
      });
      print('emp data updated');
      await attendanceServices.fetchDealerData(context: context, onSuccess: () async {
        dataSyncList[1]['item_status']=true;
        dataSyncList.add({
          'item_name': "Fetching tagged distributor's data",
          'item_status': false
        });
        setState(() {});
        print('dealer data fetched');
        await attendanceServices.fetchDistributorData(context: context, onSuccess: () async{
          dataSyncList[2]['item_status']=true;
          dataSyncList.add({
            'item_name': "Fetching tagged engineer's data",
            'item_status': false
          });
          setState(() {});
          print('distributor data fetched');
          await attendanceServices.fetchEngineerData(context: context, onSuccess: (){
            dataSyncList[3]['item_status']=true;
            showCloseButton = true;
            setState(() {});
            print('engineer data fetched');
            onSuccess.call();
          });
        });
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateDataSync(() {
        widget.onSuccessCallBack.call();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    



    return WillPopScope(
      onWillPop: () {
        return Future.value(showCloseButton);
      },
      child: Dialog(
        child: Container(
          height: 500,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: MyColors.boneWhite,
          ),
          child: Column(
            children: [
              Container(
                height: 60,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: MyColors.blackColor,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(15),topLeft: Radius.circular(15))
                ),
                child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        showCloseButton ? const Icon(Icons.check_circle_rounded, color: MyColors.greenColor) : LoadingAnimationWidget.discreteCircle(color: MyColors.boneWhite, size: 18),
                        Text(
                          showCloseButton ? 'Data synchronization is completed!' : 'Data synchronization is in progress...',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: MyColors.boneWhite,
                            fontFamily: MyFonts.poppins,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            decoration: TextDecoration.underline
                          ),
                        ),
                      ],
                ),
              ),
              Expanded(
                  child: ListView.builder(
                      itemCount: dataSyncList.length,
                      itemBuilder: (context, index){
                        return DataSyncItemCard(
                            itemText: dataSyncList[index]['item_name'],
                            isDone: dataSyncList[index]['item_status']
                        );
                      }
                  )
              ),
              Visibility(
                visible: showCloseButton,
                child: Stack(
                  children: [
                    Positioned(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CustomElevatedButton(
                            buttonText: 'Close',
                            buttonIcon: Icons.close,
                            buttonColor: MyColors.appBarColor,
                            buttonTextColor: Colors.white,
                            buttonIconColor: MyColors.redColor,
                            width: 100,
                            height: 40,
                            iconSize: 20,
                            textSize: 15,
                            onClick: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                    )
                  ],
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
