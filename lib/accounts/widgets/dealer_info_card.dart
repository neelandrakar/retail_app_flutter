import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:retail_app_flutter/accounts/widgets/outstanding_box.dart';
import 'package:retail_app_flutter/accounts/widgets/sale_box_column.dart';
import 'package:retail_app_flutter/constants/account_list_button.dart';
import 'package:retail_app_flutter/constants/assets_constants.dart';
import 'package:retail_app_flutter/constants/my_colors.dart';
import 'package:retail_app_flutter/constants/my_fonts.dart';
import 'package:retail_app_flutter/constants/utils.dart';
import 'package:retail_app_flutter/models/dealer_master.dart';

class DealerInfoCard extends StatefulWidget {
  final DealerMaster dealerMaster;
  const DealerInfoCard({super.key, required this.dealerMaster});

  @override
  State<DealerInfoCard> createState() => _DealerInfoCardState();
}

class _DealerInfoCardState extends State<DealerInfoCard> {

  String last_billing_date = '';

  @override
  Widget build(BuildContext context) {

    var dealer = widget.dealerMaster;
    if(dealer.last_billing_date!=null){
      last_billing_date = getDateUniversalFormat(dealer.last_billing_date!);
    } else {
      last_billing_date = 'NA';
    }



    return Container(
        height: 205,
        width: double.infinity,
        decoration: BoxDecoration(
            color: MyColors.ashColor,
            border: Border.all(color: MyColors.offWhiteColor, width: 1),
            borderRadius: BorderRadius.circular(20)
        ),
        child: Column(
          children: [
            Container(
              height: 155,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: MyColors.boneWhite,
                  borderRadius: BorderRadius.circular(18)),
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                          children: [
                        Row(
                          children: [
                            Stack(
                              children: [
                                Image.asset(
                                  AssetsConstants.calender_icon,
                                  height: 21,
                                  width: 21,
                                ),
                                Positioned(
                                  left: 3,
                                  top: 2,
                                  child: Text(
                                    '${dealer.created_before}d\nago',
                                    style: TextStyle(
                                        color: MyColors.appBarColor,
                                        fontSize: 7,
                                        fontFamily: MyFonts.poppins,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 5),
                            Container(
                              width: 95,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    dealer.account_name,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: MyColors.blackColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        fontFamily: MyFonts.poppins),
                                  ),
                                  Text(
                                    dealer.contact_person_name,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: MyColors.fadedBlack,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 10,
                                        fontFamily: MyFonts.poppins),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(width: 5),
                            Container(
                              width: 120,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                                      Flexible(
                                        child: Text(
                                          dealer.account_status,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                              color: MyColors.blackColor,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 11,
                                              fontFamily: MyFonts.poppins),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'District:',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: MyColors.purpleColor,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 11,
                                          fontFamily: MyFonts.poppins,
                                        ),
                                      ),
                                      SizedBox(width: 3),
                                      Flexible(
                                        child: Text(
                                          dealer.district_names[0],
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                            color: MyColors.blackColor,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 11,
                                            fontFamily: MyFonts.poppins,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      ]),
                      GestureDetector(
                        onTap: (){
                          print('call ${dealer.account_name}');
                        },
                        child: Image.asset(
                            AssetsConstants.call_icon,
                            height: 27,
                            width: 27
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: MyColors.offWhiteColor,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        alignment: Alignment.center,
                        width: 230,
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SaleBoxColumn(
                                upperText: getFinantialYear(1),
                                lowerText: dealer.cy_primary_sale.toString()
                            ),
                            SaleBoxColumn(
                                upperText: getFinantialYear(2),
                                lowerText: dealer.ly_primary_sale.toString()
                            ),
                            SaleBoxColumn(
                                upperText: 'Last Bill. Qty.',
                                lowerText: '${dealer.last_billing_quantity.toString()}MT'
                            ),
                            SaleBoxColumn(
                                upperText: 'Date',
                                lowerText: last_billing_date
                            ),

                          ],
                        ),
                      ),
                      SizedBox(width: 5,),
                      Container(
                        height: 40,
                        width: 55,
                        decoration: BoxDecoration(
                          color: MyColors.topNavigationBarUnselected,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: MyColors.topNavigationBarSelected, width: 0.5)
                        ),
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             const Text(
                               'Sec. Dep.',
                               overflow: TextOverflow.ellipsis,
                               maxLines: 1,
                               style: TextStyle(
                                 color: MyColors.fadedBlack,
                                 fontWeight: FontWeight.w500,
                                 fontSize: 10,
                                 fontFamily: MyFonts.poppins,
                               ),
                             ),
                             Text(
                               convertToINR(dealer.security_deposite),
                               overflow: TextOverflow.ellipsis,
                               maxLines: 1,
                               style: TextStyle(
                                 color: MyColors.blackColor,
                                 fontWeight: FontWeight.w600,
                                 fontSize: 12,
                                 fontFamily: MyFonts.poppins,
                               ),
                             ),
                           ],
                         ),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        height: 40,
                        width: 80,
                        decoration: BoxDecoration(
                          color: MyColors.ashColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: MyColors.blueGreyColor, width: 0)
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Current O/S.',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                color: MyColors.blackColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 11,
                                fontFamily: MyFonts.poppins,
                              ),
                            ),
                            Text(
                              convertToINR(dealer.total_outstanding),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                color: MyColors.deepBlueColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                fontFamily: MyFonts.poppins,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              OutstandingBox(date_range: '<30d', osValue: dealer.below_thirty,),
                              OutstandingBox(date_range: '31-45d',osValue: dealer.thirtyOne_to_fourtyFive,),
                              OutstandingBox(date_range: '46-60d',osValue: dealer.fourtySix_to_sixty,),
                              OutstandingBox(date_range: '61-90d',osValue: dealer.sixtyOne_to_ninety,),
                              OutstandingBox(date_range: '>91d ',osValue: dealer.ninetyOne_to_above,),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 13),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AccountListButton(
                    buttonColor: MyColors.boneWhite,
                    buttonText: 'Edit',
                    buttonIcon: Icons.edit,
                    iconColor: MyColors.deepBlueColor,
                    iconSize: 13,
                    onClick: (){},
                ),
                AccountListButton(
                  buttonColor: MyColors.boneWhite,
                  buttonText: 'Details',
                  buttonIcon: Icons.info,
                  iconColor: MyColors.deepBlueColor,
                  iconSize: 13,
                  onClick: (){},
                ),
                AccountListButton(
                  buttonColor: MyColors.boneWhite,
                  buttonText: 'Branding',
                  buttonIcon: Icons.format_paint,
                  iconColor: MyColors.deepBlueColor,
                  iconSize: 13,
                  onClick: (){},
                ),
                AccountListButton(
                  buttonColor: MyColors.boneWhite,
                  buttonText: 'Mark doubtful',
                  buttonIcon: Icons.delete,
                  iconColor: MyColors.redColor,
                  iconSize: 13,
                  onClick: (){},
                )
              ],
            )
          ],
        )
    );
  }
}
