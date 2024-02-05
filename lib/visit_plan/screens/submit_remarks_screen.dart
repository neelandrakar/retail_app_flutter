import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:retail_app_flutter/constants/assets_constants.dart';
import 'package:retail_app_flutter/constants/custom_elevated_button.dart';
import 'package:retail_app_flutter/models/dealer_master.dart';

import '../../constants/custom_app_bar.dart';
import '../../constants/my_colors.dart';
import '../../constants/my_fonts.dart';
import '../../constants/utils.dart';

class SubmitRemarksScreen extends StatefulWidget {
  static const String routeName = '/submit-remarks-screen';
  final DealerMaster? dealer;
  final int account_type_id;
  final int location_type;
  const SubmitRemarksScreen(
      {super.key,
      required this.account_type_id,
      this.dealer,
      required this.location_type});

  @override
  State<SubmitRemarksScreen> createState() => _SubmitRemarksScreenState();
}

class _SubmitRemarksScreenState extends State<SubmitRemarksScreen> {
  String actionType = 'NA';
  String ratingText = 'Rate';
  double rating = 0.0;
  String ratingIcon = AssetsConstants.shyam_steel_logo_round;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.location_type==1 || widget.location_type==2){
      actionType = 'Visit';
    }
  }
  @override
  Widget build(BuildContext context) {

    print(widget.location_type);

    return Scaffold(
      backgroundColor: MyColors.boneWhite,
      body: Stack(
        children: <Widget>[
          Container(
              height: 160,
              child: CustomAppBar(
                module_name: 'Submit Remarks',
                emp_name: getEmployeeName(context),
              )),
          Padding(padding: EdgeInsets.only(top: 110.0), child: _buildBody())
        ],
      ),
    );
  }

  _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: <Widget>[
          Container(
                  height: 110,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: MyColors.whiteColor,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: MyColors.black12,
                        offset: const Offset(
                          1.0,
                          1.0,
                        ),
                        blurRadius: 2.0,
                        spreadRadius: 2.0,
                      ),
                    ],
                  ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        width: 80,
                        height: 23,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(5),
                        decoration:  BoxDecoration(
                          image: DecorationImage(image: AssetImage(AssetsConstants.account_status_box), fit: BoxFit.fill),
                        ),
                        child: Text(
                          widget.dealer!.account_status,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: MyColors.boneWhite,
                              fontSize: 11,
                              fontFamily: MyFonts.poppins,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15).copyWith(top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 210,
                            // color: Colors.red,
                            child: Text(
                              widget.dealer!.account_name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: MyColors.appBarColor,
                                  fontSize: 17,
                                  fontFamily: MyFonts.poppins,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IntrinsicHeight(
                                child: Row(
                                  children: [
                                    Container(
                                      width: 100,
                                      // color: Colors.red,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Mobile Number',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: MyColors.fadedBlack,
                                                fontSize: 13,
                                                fontFamily: MyFonts.poppins,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          SizedBox(height: 3),
                                          Row(
                                            children: [
                                              Icon(Icons.phone, color: MyColors.blueColor,size: 14),
                                              SizedBox(width: 3),
                                              Text(
                                                widget.dealer!.mobno.toString(),
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: MyColors.appBarColor,
                                                    fontSize: 13,
                                                    fontFamily: MyFonts.poppins,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                            ],
                                          )
                                        ],
                                      )
                                    ),
                                    SizedBox(width: 5),
                                    VerticalDivider(
                                      thickness: 0.3,
                                      color: MyColors.fadedBlack,
                                    ),
                                    SizedBox(width: 5),
                                    Container(
                                        width: 100,
                                        // color: Colors.red,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Action',
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                  color: MyColors.fadedBlack,
                                                  fontSize: 13,
                                                  fontFamily: MyFonts.poppins,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            const SizedBox(height: 3),
                                                Text(
                                                  actionType,
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                      color: MyColors.appBarColor,
                                                      fontSize: 13,
                                                      fontFamily: MyFonts.poppins,
                                                      fontWeight: FontWeight.w500),
                                                ),
                                          ],
                                        )
                                    )
                                  ],
                                ),
                              ),
                              CustomElevatedButton(
                                  buttonText: 'View More',
                                  textSize: 10,
                                  buttonColor: MyColors.lightBlueColor,
                                  buttonTextColor: MyColors.blueColor,
                                  height: 30,
                                  width: 70,
                                  onClick: (){}
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
          SizedBox(height: 12),
          Stack(
            children: [
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: MyColors.lightYellowColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.yellow, width: 0.5)
                ),
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Rate your experience',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: MyColors.appBarColor,
                                fontSize: 16,
                                fontFamily: MyFonts.poppins,
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'How would you rate your interaction with ${widget.dealer!.account_name}?',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: MyColors.fadedBlack,
                                fontSize: 12,
                                fontFamily: MyFonts.poppins,
                                fontWeight: FontWeight.w400),
                          )
                        ],
                      ),
                    ),
                          SizedBox(height: 8),
                          RatingBar.builder(
                            initialRating: 3,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 30,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Container(
                              child: Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                            ),
                            onRatingUpdate: (rating) {

                              setState(() {
                                if (rating > 0 && rating <= 1) {
                                  ratingText = 'Very Bad';
                                  ratingIcon = AssetsConstants.dizzy;
                                } else if (rating > 1 && rating <= 2) {
                                  ratingText = 'Bad';
                                  ratingIcon = AssetsConstants.sad_face;
                                } else if (rating > 2 && rating <= 3) {
                                  ratingText = 'Moderate';
                                  ratingIcon = AssetsConstants.moderate_face;
                                } else if (rating > 3 && rating <= 4) {
                                  ratingText = 'Good';
                                  ratingIcon = AssetsConstants.happy_face;
                                } else if (rating > 4 && rating <= 5) {
                                  ratingText = 'Very Good';
                                  ratingIcon = AssetsConstants.very_happy_face;
                                }
                                print(rating);
                              }
                              ); },
                          ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 120,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: MyColors.whiteColor,
                        borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(ratingIcon, height: 25,width: 25),
                        SizedBox(width: 3),
                        Container(
                          width: 80,
                          alignment: Alignment.center,
                          child: Text(
                            ratingText,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: MyColors.appBarColor,
                                fontSize: 15,
                                fontFamily: MyFonts.poppins,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
