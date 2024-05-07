import 'package:flutter/material.dart';
import 'package:retail_app_flutter/constants/custom_elevated_button.dart';
import 'package:retail_app_flutter/models/distributor_master.dart';
import 'package:retail_app_flutter/models/engineer_master.dart';
import 'package:retail_app_flutter/providers/distributor_master_provider.dart';

import '../../constants/assets_constants.dart';
import '../../constants/my_colors.dart';
import '../../constants/my_fonts.dart';

class AccountInfoCard extends StatefulWidget {
  final DistributorMaster? distributor_master;
  final EngineerMaster? engineer_master;
  final int account_type_id;
  const AccountInfoCard({super.key, this.distributor_master, required this.account_type_id, this.engineer_master});

  @override
  State<AccountInfoCard> createState() => _AccountInfoCardState();
}

class _AccountInfoCardState extends State<AccountInfoCard> {
  String address = 'NA';
  late DistributorMaster distributor;
  late EngineerMaster engineer;

  @override
  Widget build(BuildContext context) {


    if(widget.account_type_id==7) {
      distributor = widget.distributor_master!;
      address =
      "${distributor.area}, ${distributor.main_district}, ${distributor
          .state_name}";
    } else if(widget.account_type_id==6){
        engineer = widget.engineer_master!;
        address =
        "${engineer.area}, ${engineer.district_names[0]}, ${engineer
            .state_name}";
      }



    if(widget.account_type_id==7) {
      return Container(
        height: 123.08,
        width: double.infinity,
        decoration: BoxDecoration(
            color: MyColors.ashColor,
            border: Border.all(color: MyColors.offWhiteColor, width: 1),
            borderRadius: BorderRadius.circular(20)
        ),
        child: Column(
          children: [
            Container(
              height: 84.05,
              width: double.infinity,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: MyColors.boneWhite,
                  borderRadius: BorderRadius.circular(18)
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Icon(Icons.person, size: 15, color: MyColors.purpleColor,),
                          Container(
                            // color: Colors.red,
                            width: 150,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  distributor.account_name,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: MyColors.blackColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      fontFamily: MyFonts.poppins),
                                ),
                                Text(
                                  distributor.contact_person_name,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: MyColors.fadedBlack,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 11,
                                      fontFamily: MyFonts.poppins),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8,),
                          Row(
                            children: [
                              Image.asset(
                                AssetsConstants.account_status_icon,
                                height: 15,
                                width: 15,
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              Container(
                                width: 70,
                                child: Text(
                                  distributor.account_status,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: MyColors.blackColor,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      fontFamily: MyFonts.poppins),
                                ),
                              ),

                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.location_on, size: 15,
                            color: MyColors.purpleColor,),
                          SizedBox(width: 3,),
                          Container(
                            width: 200,
                            child: Text(
                              address,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  color: MyColors.blackColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  fontFamily: MyFonts.poppins),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      print('call ${distributor.account_name}');
                    },
                    child: Image.asset(
                        AssetsConstants.call_icon,
                        height: 30,
                        width: 30
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomElevatedButton(
                  buttonText: 'Edit',
                  buttonIcon: Icons.edit,
                  buttonColor: MyColors.boneWhite,
                  buttonTextColor: Colors.black,
                  buttonIconColor: MyColors.blueColor,
                  width: 80,
                  height: 25,
                  onClick: () {
                    print('Edit');
                  },
                ),
                if(widget.account_type_id == 7)
                  SizedBox(width: 5,),
                if(widget.account_type_id == 7)
                  CustomElevatedButton(
                    buttonText: 'Branding',
                    buttonIcon: Icons.format_paint,
                    buttonColor: MyColors.boneWhite,
                    buttonTextColor: Colors.black,
                    buttonIconColor: MyColors.blueColor,
                    width: 80,
                    height: 25,
                    onClick: () {
                      print('Branding');
                    },
                  ),
              ],
            )
          ],
        ),
      );
    } else if(widget.account_type_id==6){
      return Container(
        height: 123.08,
        width: double.infinity,
        decoration: BoxDecoration(
            color: MyColors.ashColor,
            border: Border.all(color: MyColors.offWhiteColor, width: 1),
            borderRadius: BorderRadius.circular(20)
        ),
        child: Column(
          children: [
            Container(
              height: 84.05,
              width: double.infinity,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: MyColors.boneWhite,
                  borderRadius: BorderRadius.circular(18)
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Icon(Icons.person, size: 15, color: MyColors.purpleColor,),
                          Container(
                            // color: Colors.red,
                            width: 150,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  engineer.account_name,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: MyColors.blackColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      fontFamily: MyFonts.poppins),
                                ),
                                Text(
                                  engineer.contact_person_name,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: MyColors.fadedBlack,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 11,
                                      fontFamily: MyFonts.poppins),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8,),
                          Row(
                            children: [
                              Image.asset(
                                AssetsConstants.account_status_icon,
                                height: 15,
                                width: 15,
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              Container(
                                width: 70,
                                child: Text(
                                  engineer.account_status,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: MyColors.blackColor,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      fontFamily: MyFonts.poppins),
                                ),
                              ),

                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.location_on, size: 15,
                            color: MyColors.purpleColor,),
                          SizedBox(width: 3,),
                          Container(
                            width: 200,
                            child: Text(
                              address,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  color: MyColors.blackColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  fontFamily: MyFonts.poppins),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      print('call ${engineer.account_name}');
                    },
                    child: Image.asset(
                        AssetsConstants.call_icon,
                        height: 30,
                        width: 30
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomElevatedButton(
                  buttonText: 'Edit',
                  buttonIcon: Icons.edit,
                  buttonColor: MyColors.boneWhite,
                  buttonTextColor: Colors.black,
                  buttonIconColor: MyColors.blueColor,
                  width: 80,
                  height: 25,
                  onClick: () {
                    print('Edit');
                  },
                ),
              ],
            )
          ],
        ),
      );
    }else{
      return Text('404 No Data Found');
    }
  }
}
