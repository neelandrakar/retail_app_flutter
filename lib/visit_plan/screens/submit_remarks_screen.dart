import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:getwidget/components/dropdown/gf_dropdown.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:retail_app_flutter/constants/assets_constants.dart';
import 'package:retail_app_flutter/constants/custom_elevated_button.dart';
import 'package:retail_app_flutter/constants/custom_text_formfield.dart';
import 'package:retail_app_flutter/constants/simpleTextField.dart';
import 'package:retail_app_flutter/models/dealer_master.dart';
import 'package:retail_app_flutter/models/visit_question_model.dart';
import 'package:retail_app_flutter/visit_plan/services/visit_plan_services.dart';

import '../../constants/custom_app_bar.dart';
import '../../constants/my_colors.dart';
import '../../constants/my_fonts.dart';
import '../../constants/utils.dart';
import '../../providers/visit_questions_provider.dart';

enum GiftHandOverType { Yes, No }
GiftHandOverType giftHandOverType = GiftHandOverType.No;


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
  String accountType = 'NA';
  String purposeOfVisitDropdown = 'NA';
  List<DropdownMenuItem> purposeOfVisitItems = [];
  String ratingText = 'Rate';
  String dealerPotLabel = 'Dealer Counter Potential';
  String subDealerCount = 'Sub-dealer count';
  double rating = 0.0;
  String ratingIcon = AssetsConstants.shyam_steel_logo_round;
  final VisitPlanServices visitPlanServices = VisitPlanServices();
  late Future<void> _getVisitQuestions;
  bool fullyLoaded = false;
  TextEditingController _dealerCounterPotentialController = TextEditingController();
  TextEditingController _subDealerCountController = TextEditingController();
  late VisitQuestionModel visitQuestions;

  List<DropdownMenuItem<String>> getDropdownItems(List<String> pur_of_visit) {
    List<DropdownMenuItem<String>> items = [];
    for(int i=0; i<pur_of_visit.length; i++){
      items.add(DropdownMenuItem(value: pur_of_visit[i], child: Text(pur_of_visit[i].toString())));
    }
    return items;
  }

  Future<void> fetchQuestions()async{

    visitPlanServices.fetchVisitQuestion(
        context: context,
        account_obj_id: widget.dealer!.id,
        onSuccess: (){
          print('Successfully done!');
          fullyLoaded = true;
          setState(() {
            visitQuestions = Provider.of<VisitQuestionsProvider>(context, listen: false).visitQuestionsModel;
            purposeOfVisitDropdown = visitQuestions.purpose_of_visit.first;
            if(widget.account_type_id==1){
              accountType = 'Dealer';
            }
          });
        }
    );
  }

  String getPurposeOfVisitValue(List<String> pur_of_visit){
    String val = pur_of_visit.first;
    purposeOfVisitDropdown = val;
    return val;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getVisitQuestions = fetchQuestions();
    if(widget.location_type==1 || widget.location_type==2){
      actionType = 'Visit';
    }
  }
  @override
  Widget build(BuildContext context) {

    print(widget.location_type);

    return Scaffold(
        backgroundColor: MyColors.boneWhite,
        body:
        FutureBuilder<void>(
            future: _getVisitQuestions,
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              if (!fullyLoaded) {
                return Center(
                    child: LoadingAnimationWidget.staggeredDotsWave(
                        color: MyColors.appBarColor,
                        size: 30
                    ));
              } else {
                return SingleChildScrollView(
                  child: Stack(
                    children: <Widget>[
                      Container(
                          height: 160,
                          child: CustomAppBar(
                            module_name: 'Submit Remarks',
                            emp_name: getEmployeeName(context),
                          )),
                      Padding(
                          padding: EdgeInsets.only(top: 110.0), child: _buildBody())
                    ],
                  ),
                );
              }
            })
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
                height: 130,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: MyColors.lightYellowColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.yellow, width: 0.5),
                    boxShadow: [
                      BoxShadow(
                        color: MyColors.black12,
                        offset: const Offset(
                          1.0,
                          1.0,
                        ),
                        blurRadius: 0.5,
                        spreadRadius: 0.5,
                      )
                    ]
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
                          Container(
                            // color: Colors.red,
                            width: double.infinity,
                            height: 30,
                            child: Text(
                              'How would you rate your interaction with ${widget.dealer!.account_name}?',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: MyColors.fadedBlack,
                                  fontSize: 12,
                                  fontFamily: MyFonts.poppins,
                                  fontWeight: FontWeight.w400),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    RatingBar.builder(
                      initialRating: 0,
                      minRating: 0.5,
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
                padding: const EdgeInsets.only(top: 110),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 120,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: MyColors.whiteColor,
                      borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: MyColors.black12,
                            offset: const Offset(
                              1.0,
                              1.0,
                            ),
                            blurRadius: 0.5,
                            spreadRadius: 0.5,
                          )
                        ]
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
          SizedBox(height: 12),
          if(visitQuestions.show_business_survey)
            Container(
              height: 125,
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: MyColors.whiteColor,
                  boxShadow: [
                    BoxShadow(
                      color: MyColors.black12,
                      offset: const Offset(
                        1.0,
                        1.0,
                      ),
                      blurRadius: 0.5,
                      spreadRadius: 0.5,
                    )
                  ]
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Business Survey',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: MyColors.appBarColor,
                            fontSize: 15,
                            fontFamily: MyFonts.poppins,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Click here to submit survey',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: MyColors.fadedBlack,
                            fontSize: 12,
                            fontFamily: MyFonts.poppins,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(height: 15),
                      CustomElevatedButton(
                          buttonText: 'Tap to submit',
                          textSize: 10,
                          buttonColor: MyColors.businessSurveyBackground,
                          buttonTextColor: MyColors.businessSurveyForeground,
                          height: 30,
                          width: 90,
                          onClick: (){}
                      )
                    ],
                  ),
                  Image.asset(AssetsConstants.business_survey_icon, scale: 2)
                ],
              ),
            ),
          SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: MyColors.whiteColor,
              boxShadow: [
                BoxShadow(
                  color: MyColors.black12,
                  offset: const Offset(
                    1.0,
                    1.0,
                  ),
                  blurRadius: 0.5,
                  spreadRadius: 0.5,
                )
              ]
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if(visitQuestions.show_dealer_counter_potential)
                SimpleTextField(
                    labelText: 'Dealer Counter Potential*',
                    hintText: 'Please enter counter potential',
                    height: 50,
                    width: double.infinity,
                    controller: _dealerCounterPotentialController,
                    onChanged: (val){
                      print(val);
                    }
                ),
                const SizedBox(height: 10),
                if(visitQuestions.show_sub_dealer_count)
                  SimpleTextField(
                      labelText: 'Sub-dealer count*',
                      hintText: 'Please enter sub-dealer count',
                      height: 50,
                      width: double.infinity,
                      controller: _subDealerCountController,
                      onChanged: (val){
                        print(val);
                      }
                  ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: MyColors.whiteColor,
                      border: Border.all(color: MyColors.offWhiteColor)
                  ),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: purposeOfVisitDropdown,
                    icon: null,
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        purposeOfVisitDropdown = value!;
                      });
                    },
                    items: visitQuestions.purpose_of_visit.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,
                          style: TextStyle(
                            color: MyColors.blackColor
                          ),
                        ),
                      );
                    }).toList(),
                  )
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                          'Handed over gifts to \n$accountType?*',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: MyColors.blackColor,
                              fontSize: 14,
                              fontFamily: MyFonts.poppins,
                              fontWeight: FontWeight.w400),
                        ),
                    Row(
                      children: [
                        Row(
                          children: [
                            Radio(
                              activeColor: MyColors.appBarColor,
                              value: GiftHandOverType.Yes,
                              groupValue: giftHandOverType,
                              onChanged: (GiftHandOverType? val) {
                                print(val.toString());
                                setState(() {
                                  giftHandOverType = val!;
                                });
                              },
                            ),
                            Text(
                              'Yes',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: MyColors.blackColor,
                                  fontSize: 14,
                                  fontFamily: MyFonts.poppins,
                                  fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              activeColor: MyColors.appBarColor,
                              value: GiftHandOverType.No,
                              groupValue: giftHandOverType,
                              onChanged: (GiftHandOverType? val) {
                                print(val.toString());
                                setState(() {
                                  giftHandOverType = val!;
                                });
                              },
                            ),
                            Text(
                              'No',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: MyColors.blackColor,
                                  fontSize: 14,
                                  fontFamily: MyFonts.poppins,
                                  fontWeight: FontWeight.w400),
                            )
                          ],
                        )
                      ],
                    )

                  ],
                )

              ],
            ),
          )

        ],
      ),
    );
  }
}
