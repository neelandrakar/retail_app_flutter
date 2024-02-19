import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:retail_app_flutter/constants/assets_constants.dart';
import 'package:retail_app_flutter/constants/camera_screen.dart';
import 'package:retail_app_flutter/constants/custom_elevated_button.dart';
import 'package:retail_app_flutter/constants/global_variables.dart';
import 'package:retail_app_flutter/constants/my_colors.dart';
import 'package:retail_app_flutter/constants/utils.dart';
import 'package:retail_app_flutter/models/dealer_master.dart';
import 'package:retail_app_flutter/visit_plan/widgets/home_office_site_radio_button.dart';

import '../../constants/my_fonts.dart';

class SetLatLonDialogue extends StatefulWidget {
  final DealerMaster dealer;
  final double emp_lat;
  final double emp_lon;
  final void Function(String) onClick;
  const SetLatLonDialogue({super.key, required this.dealer, required this.emp_lat, required this.emp_lon, required this.onClick});

  @override
  State<SetLatLonDialogue> createState() => _SetLatLonDialogueState();
}

class _SetLatLonDialogueState extends State<SetLatLonDialogue> {
  String accName = 'NA';
  String noLocationText = 'NA';
  String _homeAddress = 'NA';
  String _officeAddress = 'NA';
  Position? _currentPosition;
  bool homeLocationAlreadyPlotted = false;
  bool officeLocationAlreadyPlotted = false;
  late Future<void> getAddressData;

  Future<void> getAddressFromLatLang() async {
    List<Placemark> homePlaceMark = await placemarkFromCoordinates(
        double.parse(widget.dealer.latitude),
        double.parse(widget.dealer.longitude));
    Placemark homeAdd = homePlaceMark[0];
    _homeAddress =
        '${homeAdd.street}, ${homeAdd.subLocality}, ${homeAdd.locality}';

    List<Placemark> officePlaceMark = await placemarkFromCoordinates(
        double.parse(widget.dealer.latitude),
        double.parse(widget.dealer.longitude));
    Placemark officeAdd = officePlaceMark[0];
    _officeAddress =
        '${officeAdd.street}, ${officeAdd.subLocality}, ${officeAdd.locality}';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    List<String> accNameList = widget.dealer.account_name.split(" ");
    accName = accNameList[0];
    homeLocationAlreadyPlotted = widget.dealer.latitude != 0.0.toString() &&
        widget.dealer.longitude != 0.0.toString();
    officeLocationAlreadyPlotted =
        widget.dealer.office_latitude != 0.0.toString() &&
            widget.dealer.office_longitude != 0.0.toString();
    getAddressData = getAddressFromLatLang();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    visitLocationType = VisitLocationType.Home;
    homeLocationAlreadyPlotted = false;
    officeLocationAlreadyPlotted = false;
  }

  @override
  Widget build(BuildContext context) {
    if (VisitLocationType == VisitLocationType.Home) {
      String noLocationText = 'Home location is yet to be plotted';
    } else if (VisitLocationType == VisitLocationType.Office) {
      String noLocationText = 'Office location is yet to be plotted';
    }

    String getLocationHeaderText(VisitLocationType visitLocType) {
      if (visitLocType == VisitLocationType.Home) {
        if (homeLocationAlreadyPlotted) {
          return _homeAddress;
        } else {
          return "Home location isn't plotted";
        }
      } else if (visitLocType == VisitLocationType.Office) {
        if (officeLocationAlreadyPlotted) {
          return _officeAddress;
        } else {
          return "Office location isn't plotted";
        }
      } else if (visitLocType == VisitLocationType.Site) {
        return 'Please choose a site';
      } else {
        return 'NA';
      }
    }

    String getLocationSmallText(VisitLocationType visitLocType) {
      if (visitLocType == VisitLocationType.Home) {
        if (homeLocationAlreadyPlotted) {
          return 'Please click the button below to check in';
        } else {
          return "Please click the button below to set home location of ${accName}";
        }
      } else if (visitLocType == VisitLocationType.Office) {
        if (officeLocationAlreadyPlotted) {
          return 'Please click the button below to check in';
        } else {
          return "Please click the button below to set office location of ${accName}";
        }
      } else if (visitLocType == VisitLocationType.Site) {
        return 'Please choose a site from the dropdown below';
      } else {
        return 'NA';
      }
    }

    String getButtonText(VisitLocationType visitLocType) {
      if (visitLocType == VisitLocationType.Home) {
        if (homeLocationAlreadyPlotted) {
          return 'Check In';
        } else {
          return "Set Location";
        }
      } else if (visitLocType == VisitLocationType.Office) {
        if (officeLocationAlreadyPlotted) {
          return 'Check In';
        } else {
          return "Set Location";
        }
      } else if (visitLocType == VisitLocationType.Site) {
        return 'Check In';
      } else {
        return 'NA';
      }
    }

    double getDistance(VisitLocationType visitLocType) {
      if (visitLocType == VisitLocationType.Home) {
        if (homeLocationAlreadyPlotted) {
          return calculateDistance(widget.emp_lat, widget.emp_lon, double.parse(widget.dealer.latitude), double.parse(widget.dealer.longitude));
        } else {
          return 0.0;
        }
      } else if (visitLocType == VisitLocationType.Office) {
        if (officeLocationAlreadyPlotted) {
          return calculateDistance(widget.emp_lat, widget.emp_lon, double.parse(widget.dealer.office_latitude), double.parse(widget.dealer.office_longitude));
        } else {
          return 0.0;
        }
      } else if (visitLocType == VisitLocationType.Site) {
        return 0.0;
      } else {
        return 0.0;
      }
    }

    Widget getDistanceWidget(VisitLocationType visitLocType) {
      if (visitLocType == VisitLocationType.Home) {
        if (homeLocationAlreadyPlotted) {
          return distanceWidget((visitLocType) => getDistance(visitLocationType));
        } else {
          return Container();
        }
      } else if (visitLocType == VisitLocationType.Office) {
        if (officeLocationAlreadyPlotted) {
          return distanceWidget((visitLocType) => getDistance(visitLocationType));
        } else {
          return Container();
        }
      } else if (visitLocType == VisitLocationType.Site) {
        return Container();
      } else {
        return Container();
      }
    }


    IconData getButtonIcon(VisitLocationType visitLocType) {
      if (visitLocType == VisitLocationType.Home) {
        if (homeLocationAlreadyPlotted) {
          return Icons.pin_drop_rounded;
        } else {
          return Icons.camera_alt;
        }
      } else if (visitLocType == VisitLocationType.Office) {
        if (officeLocationAlreadyPlotted) {
          return Icons.pin_drop_rounded;
        } else {
          return Icons.camera_alt;
        }
      } else if (visitLocType == VisitLocationType.Site) {
        return Icons.pin_drop_rounded;
      } else {
        return Icons.camera_alt;
      }
    }

    void buttonClick(VisitLocationType visitLocType){

      if (visitLocType == VisitLocationType.Home) {
        if (homeLocationAlreadyPlotted) {
          widget.onClick('home');
          Navigator.pop(context);
        } else {
          Navigator.pushNamed(
              context, CameraScreen.routeName,
              arguments: [1, accName, widget.dealer.id]
          );
        }
      } else if (visitLocType == VisitLocationType.Office) {
        if (officeLocationAlreadyPlotted) {
          widget.onClick('office');
          Navigator.pop(context);
          print('Check in at office');
        } else {
          Navigator.pushNamed(
              context, CameraScreen.routeName,
              arguments: [2, accName,  widget.dealer.id]
          );
        }
      } else if (visitLocType == VisitLocationType.Site) {
        print('Check in at site');
      } else {
        print('Error while navigating');
      }
    }

    return FutureBuilder<void>(
        future: getAddressData,
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Dialog(
              child: SizedBox(
                  height: 400,
                  child: LoadingAnimationWidget.staggeredDotsWave(
                      color: MyColors.appBarColor, size: 30)),
            );
          } else {
            return WillPopScope(
              onWillPop: Future.value,
              child: Dialog(
                child: Container(
                  height: 400,
                  decoration: BoxDecoration(
                      color: MyColors.boneWhite,
                      borderRadius: BorderRadius.circular(20)),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        AssetsConstants.earth_pin,
                        height: 100,
                        width: 100,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        getLocationHeaderText(visitLocationType),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                          color: MyColors.blackColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                          fontFamily: MyFonts.poppins,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        getLocationSmallText(visitLocationType),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                          color: MyColors.blackColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                          fontFamily: MyFonts.poppins,
                        ),
                      ),
                      SizedBox(height: 10),
                      HomeOfficeSiteRadio(
                        onRadioChange: () async {
                          // await getAddressFromLatLang(double.parse(widget.dealer.latitude), double.parse(widget.dealer.longitude));

                          setState(() {
                            print(visitLocationType);
                          });
                        },
                      ),
                      const SizedBox(height: 15),
                      getDistanceWidget(visitLocationType),
                      SizedBox(height: 10,),
                      CustomElevatedButton(
                          buttonText: getButtonText(visitLocationType),
                          buttonIcon: getButtonIcon(visitLocationType),
                          buttonColor: MyColors.appBarColor,
                          buttonTextColor: MyColors.boneWhite,
                          buttonIconColor: MyColors.boneWhite,
                          height: 40,
                          width: 100,
                          onClick: () {
                            buttonClick(visitLocationType);
                          })
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }

  Text distanceWidget(double getDistance(VisitLocationType visitLocType)) {
    return Text(
                "You're only ${getDistance(visitLocationType).round()}m away",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  color: getDistance(visitLocationType) > 300 ? MyColors.redColor : MyColors.greenColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  fontFamily: MyFonts.poppins,
                ),
              );
  }
}
