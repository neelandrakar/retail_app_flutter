import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:retail_app_flutter/attendance/services/attendance_services.dart';
import 'package:retail_app_flutter/attendance/widgets/vehicle_radio_button.dart';
import 'package:retail_app_flutter/constants/assets_constants.dart';
import 'package:retail_app_flutter/constants/custom_app_bar.dart';
import 'package:retail_app_flutter/constants/custom_button.dart';
import 'package:retail_app_flutter/constants/custom_textfield.dart';
import 'package:retail_app_flutter/constants/my_colors.dart';
import 'package:retail_app_flutter/constants/my_fonts.dart';
import 'package:retail_app_flutter/constants/odometer_text_field.dart';
import 'package:retail_app_flutter/constants/utils.dart';
import 'package:retail_app_flutter/home/screens/home_screen.dart';

import '../../models/employee.dart';
import '../../providers/user_provider.dart';

class SubmitOdometerScreen extends StatefulWidget{
  static const String routeName = '/odometer-page';
  const SubmitOdometerScreen({super.key});

  @override
  State<SubmitOdometerScreen> createState() => _SubmitOdometerScreenState();
}

class _SubmitOdometerScreenState extends State<SubmitOdometerScreen> {
  int selectedVehicleType = 0;
  bool imageIsUploaded = false;
  TextEditingController _odometerController = TextEditingController();


  @override
  Widget build(BuildContext context) {

    Employee emp = Provider.of<EmployeeProvider>(context, listen: false).employee;
    final AttendanceServices attendanceServices = AttendanceServices();

    void setVehicleType(int vehicleIndex){

      selectedVehicleType = vehicleIndex;
      setState(() {});
      print(selectedVehicleType);
    }

    void captureImage(){

      print('image');
    }

    void submitdata() {
      if (selectedVehicleType > 0 && _odometerController.text.isNotEmpty) {
        attendanceServices.submitLoginOdometer(
            context: context,
            onSuccess: () {
              dataSync(context, () {
                Navigator.pushNamed(context, HomeScreen.routeName);
              });
            },
            vehicleType: selectedVehicleType,
            startKM: int.parse(_odometerController.text),
            startOdometer: 'https://images.deccanherald.com/deccanherald%2F2023-10%2F31e666c7-9e31-4f0b-9b3f-65ec63c1ab21%2F2018_09_26T203107Z_667506215_RC1F17EA4CE0_RTRMADP_3_SOCCER_ENGLAND_LIV_CHE.JPG?rect=698%2C0%2C935%2C1246'
        );
      } else if(selectedVehicleType==0 && _odometerController.text.isEmpty){
        showSnackBar(context, 'Please select vehicle type and start km');
      } else if(selectedVehicleType==0 && _odometerController.text.isNotEmpty){
        showSnackBar(context, 'Please enter vehicle type');
      } else if(selectedVehicleType>0 && _odometerController.text.isEmpty){
        showSnackBar(context, 'Please enter start km');
      }
    }

    



    
    return Scaffold(
      backgroundColor: MyColors.offWhiteColor,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: CustomAppBar(
            module_name: 'Login Odometer Entry',
            emp_name: emp.emp_name,
            show_back_button: false,
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 120,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: MyColors.boneWhite,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(
                    1.0,
                    1.0,
                  ),
                  blurRadius: 3.0,
                  spreadRadius: 1.0,
                ), //BoxShadow
                BoxShadow(
                  color: Colors.white,
                  offset: Offset(0.0, 0.0),
                  blurRadius: 0.0,
                  spreadRadius: 0.0,
                ), //BoxShadow
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Select Vehicle Type',
                  style: TextStyle(
                    color: MyColors.blackColor,
                    fontFamily: MyFonts.poppins,
                    fontWeight: FontWeight.w500,
                    fontSize: 18
                  ),
                ),
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    VehicleRadioButton(
                        image: selectedVehicleType == 1 ? AssetsConstants.bike_selected : AssetsConstants.bike_unselected,
                        index: 1,
                        onClick: (){
                          setVehicleType(1);
                        },
                    ),
                    VehicleRadioButton(
                      image: selectedVehicleType == 2 ? AssetsConstants.car_selected : AssetsConstants.car_unselected,
                      index: 1,
                      onClick: (){
                        setVehicleType(2);
                      },
                    ),
                    VehicleRadioButton(
                      image: selectedVehicleType == 3 ? AssetsConstants.others_selected : AssetsConstants.others_unselected,
                      index: 1,
                      onClick: (){
                        setVehicleType(3);
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20,),
          Container(
            // height: 240,
            padding: EdgeInsets.all(15),
            width: double.infinity,
            decoration: BoxDecoration(
              color: MyColors.boneWhite,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Visibility(
                  visible: selectedVehicleType!=3,
                  child: Container(
                    height: 150,
                      // color: Colors.red,
                      width: double.infinity,
                      child:
                      Stack(
                        children: [
                          Image.asset(
                              !imageIsUploaded ?
                              AssetsConstants.odometer_no_image
                                  : AssetsConstants.car_selected,
                            width: 600,
                            fit: BoxFit.fill,
                          ),
                          Positioned(
                                top: 75,
                                right: 130,
                                child: GestureDetector(
                                  onTap: captureImage,
                                  child: Image.asset(
                                      AssetsConstants.odometer_camera,
                                      width:70,
                                      height: 70,
                                  ),
                                )
                            ),
                        ],
                      ),
                  ),
                ),
                Container(
                  height: 55,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: MyColors.boneWhite,
                    border: Border.all(color: MyColors.black12),
                    borderRadius: BorderRadius.circular(30)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('Start KM:',
                        style: TextStyle(
                          color: MyColors.appBarColor,
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      SizedBox(width: 10,),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: OdometerTextField(
                              controller: _odometerController,
                              hintText: 'Enter here...',
                              textColor: MyColors.appBarColor,
                          ),
                        ),
                      )
                    ],
                  ),

                )
              ],
            ),
          ),
          SizedBox(height: 10,),
          Padding(
            padding: EdgeInsets.all(15),
            child: CustomButton(
                onClick: submitdata,
                buttonText: 'Submit',
                borderRadius: 20,
                buttonColor: MyColors.appBarColor,
                textColor: MyColors.whiteColor,
            ),
          )
        ],
      ),
      // body: ,
    );
  }
}
