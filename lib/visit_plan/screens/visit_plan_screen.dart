import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:retail_app_flutter/constants/custom_elevated_button.dart';
import 'package:retail_app_flutter/constants/my_colors.dart';
import 'package:retail_app_flutter/constants/saved_location_sp.dart';
import 'package:retail_app_flutter/constants/utils.dart';
import 'package:retail_app_flutter/models/dealer_master.dart';
import 'package:retail_app_flutter/models/saved_visit_locations.dart';
import 'package:retail_app_flutter/providers/dealer_master_provider.dart';
import 'package:retail_app_flutter/visit_plan/screens/submit_remarks_screen.dart';
import 'package:retail_app_flutter/visit_plan/widgets/location_marker.dart';
import 'package:retail_app_flutter/visit_plan/widgets/set_lat_lon_dialogue.dart';
import '../../constants/custom_app_bar.dart';
import '../../constants/my_fonts.dart';
import '../../models/employee.dart';
import '../../providers/user_provider.dart';
import '../widgets/choose_visit_plan_dialogue.dart';

class VisitPlanScreen extends StatefulWidget {
  static const String routeName = '/visit-plan-screen';
  final bool showAccDialogue;
  DealerMaster? dealer;
  late int? funKey;
  final bool? direct;
  VisitPlanScreen({Key? key, required this.showAccDialogue, this.dealer, this.funKey, this.direct}) : super(key: key);

  @override
  State<VisitPlanScreen> createState() => _VisitPlanScreenState();
}

class _VisitPlanScreenState extends State<VisitPlanScreen> {
  double currentLatitude = 0;
  double currentLongitude = 0;
  double visitingAccLatitude =0 ;
  double visitingAccLongitude=0;
  double initialLatitude=0;
  double initialLongitude=0;
  late Future<void> _getLocationFuture;
  bool isLocationAlreadyPlotted = false;
  bool allowBack = true;
  double distanceFromCurrentLocation = 0.0;
  String currentLocationData = 'NA';
  String location_type = 'NA';
  List<SavedVisitLocation> saved_locations = [];
  List<Marker> initial_markers = [];
  List<Polyline> initial_polylines = [];
  List<CircleMarker> circle_layers = [];
  List<DealerMaster> _dealer_master = [];
  late DealerMaster clickedDealer;

  @override
  void initState() {
    super.initState();
    _getLocationFuture = getCurrentLocation();

  }

  void onClickFun(String obj_id, int loc_type) async {
    print(distanceFromCurrentLocation);
    double distance_from_emp = 0.0;

    _dealer_master = Provider.of<DealerMasterProvider>(context, listen: false).dealer_master;
    for(int i=0; i<_dealer_master.length; i++){
      if(_dealer_master[i].id==obj_id){
        clickedDealer = _dealer_master[i];
        break;
      }
    }
    if(loc_type==0){
      distance_from_emp = distanceFromCurrentLocation;
    } else {
      if(loc_type==1){
        distance_from_emp = calculateDistance(currentLatitude, currentLongitude, double.parse(clickedDealer.latitude), double.parse(clickedDealer.longitude));
      } else if(loc_type==2){
        distance_from_emp = calculateDistance(currentLatitude, currentLongitude, double.parse(clickedDealer.office_latitude), double.parse(clickedDealer.office_longitude));
      }
    }

    // String address = await getAddressFromLatLon(visitingAccLatitude, visitingAccLongitude);
    // print(address);
    if(distance_from_emp<=300){

      print('You can submit visit remarks===> ${clickedDealer.account_name}');
      showDialog(
          context: context,
          barrierDismissible: false,  //has to click a button
          builder: (context){
            return CupertinoAlertDialog(
              title: Text('Warning!'),
              content: Text('Are you sure you want to check in?'),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      if(clickedDealer.account_type_id==1){

                        List<dynamic> _args = [clickedDealer.account_type_id, widget.funKey, clickedDealer];

                        Navigator.pushNamed(context, SubmitRemarksScreen.routeName, arguments: _args);
                      }
                    },
                    child: const Text('Yes')),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); //close Dialog
                  },
                  child: Text('No'),
                )
              ],
            );
          });
    } else {
      print('Please move closer within 300 meters of ${clickedDealer.account_name} ===> ${widget.funKey}');
      showDialog(
          context: context,
          barrierDismissible: false,  //has to click a button
          builder: (context){
            return CupertinoAlertDialog(
              title: const Text(
                "Warning!",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: MyColors.appBarColor,
                    fontSize: 17,
                    fontFamily: MyFonts.poppins,
                    fontWeight: FontWeight.w600
                ),
              ),
              content: Text(
                "Please move within 300m of ${clickedDealer.account_name}'s $location_type location to check in. \n$distanceFromCurrentLocation m away",
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: MyColors.appBarColor,
                    fontSize: 11,
                    fontFamily: MyFonts.poppins,
                    fontWeight: FontWeight.w500),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); //close Dialog
                  },
                  child: const Text(
                    "OK",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: MyColors.appBarColor,
                        fontSize: 15,
                        fontFamily: MyFonts.poppins,
                        fontWeight: FontWeight.w600),
                  ),
                )
              ],
            );
          });
    }
  }

  storeLocation() async {

    try {
      final location = SavedVisitLocation(
          account_obj_id: widget.dealer!.id,
          location_type: widget.funKey!,
          account_latitude: visitingAccLatitude,
          account_longitude: visitingAccLongitude,
          added_on: DateTime.now()
      );
      await SavedLocationSP.saveSavedVisitLocations(location);
    } catch(e){
      print(e.toString());
      showSnackBar(context, e.toString());
    }

    }

  Future<void> getCurrentLocation() async {
    print("CHECKING LOCATION PERMISSION");
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      print('Location is denied');
      LocationPermission askLocationPermission =
      await Geolocator.requestPermission();
    } else {
      Position currentLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium);
      print("Latitude: ${currentLocation.latitude.toString()}");
      print("Longitude: ${currentLocation.longitude.toString()}");
      setState(() {
        currentLongitude = currentLocation.longitude;
        currentLatitude = currentLocation.latitude;
      });

      //From dashboard
      if (widget.showAccDialogue) {
        print('a');
        String locationTypeShort = 'NA';
        _dealer_master = Provider.of<DealerMasterProvider>(context, listen: false).dealer_master;
        saved_locations = await SavedLocationSP.getSavedVisitLocations();
        print(saved_locations.length);
        initial_markers.add(
            Marker(
              point: LatLng(currentLatitude, currentLongitude),
              width: 100,
              height: 100,
              child: LocationMarker(
                  visit_account_name: 'You',
                  icon_color: Colors.blue,
              )
            )
        );
        print('dealer_master length: ' + _dealer_master.length.toString());

        for(int i=0; i<saved_locations.length; i++){

          for(int j=0; j<_dealer_master.length; j++){
            if(_dealer_master[j].id==saved_locations[i].account_obj_id){
              print(saved_locations[i].account_obj_id);
              widget.dealer = _dealer_master[j];
            }
          }

          if(saved_locations[i].location_type==1){
            locationTypeShort = 'H';
            location_type = 'home';
            widget.funKey=1;
            distanceFromCurrentLocation = calculateDistance(currentLatitude, currentLongitude, double.parse(widget.dealer!.latitude), double.parse(widget.dealer!.longitude));
          } else if(saved_locations[i].location_type==2){
            locationTypeShort = 'O';
            location_type = 'office';
            widget.funKey=2;
            distanceFromCurrentLocation = calculateDistance(currentLatitude, currentLongitude, double.parse(widget.dealer!.office_latitude), double.parse(widget.dealer!.office_longitude));
          }
          double save_location_distance = 0.0;

          initial_markers.add(Marker(
              point: LatLng(
                  saved_locations[i].account_latitude,
                  saved_locations[i].account_longitude
              ),
              width: 100,
              height: 100,
              child: LocationMarker(
                  visit_account_name: "${widget.dealer!.account_name}($locationTypeShort)",
                  onClick: () {
                    onClickFun(saved_locations[i].account_obj_id, saved_locations[i].location_type);
                  }
              )
          ));
          
          initial_polylines.add(Polyline(
              points: [
                LatLng(currentLatitude, currentLongitude),
                LatLng(saved_locations[i].account_latitude,saved_locations[i].account_longitude),
              ],
              color: MyColors.blueColor,
              strokeWidth: 9
          ));

              circle_layers.add(CircleMarker(
                  point:  LatLng(saved_locations[i].account_latitude,saved_locations[i].account_longitude),
                  radius: 300,
                  color: Colors.redAccent.withOpacity(0.15),
                  useRadiusInMeter: true,
                  borderStrokeWidth: 1,
                  borderColor: MyColors.redColor
              ));
        }
      }

      //From account section
      else if(widget.dealer!=null && widget.direct==false){
        print('b');



        showDialog(
            context: context,
            builder: (_) => SetLatLonDialogue(
                dealer: widget.dealer!,
                emp_lat: currentLatitude,
                emp_lon: currentLongitude,
                onClick: (val) {
                  print(val);
                  setState(() {
                    isLocationAlreadyPlotted = true;
                    if(val=='home'){
                      widget.funKey=1;
                      visitingAccLatitude = double.parse(widget.dealer!.latitude);
                      visitingAccLongitude = double.parse(widget.dealer!.longitude);
                      distanceFromCurrentLocation = calculateDistance(currentLatitude, currentLongitude, visitingAccLatitude, visitingAccLongitude);
                      storeLocation();
                    } else if(val=='office'){
                      widget.funKey=2;
                      visitingAccLatitude = double.parse(widget.dealer!.office_latitude);
                      visitingAccLongitude = double.parse(widget.dealer!.office_longitude);
                      distanceFromCurrentLocation = calculateDistance(currentLatitude, currentLongitude, visitingAccLatitude, visitingAccLongitude);
                      storeLocation();
                    }
                  });
                }
            )
        );

        //From location approval
      }
      else if(widget.dealer!=null && widget.direct==true){
      print('c');

        setState(() {
          isLocationAlreadyPlotted = true;
          if(widget.funKey==1){
            visitingAccLatitude = double.parse(widget.dealer!.latitude);
            visitingAccLongitude = double.parse(widget.dealer!.longitude);
            distanceFromCurrentLocation = calculateDistance(currentLatitude, currentLongitude, visitingAccLatitude, visitingAccLongitude);
            storeLocation();
          } else if(widget.funKey==2){
            visitingAccLatitude = double.parse(widget.dealer!.office_latitude);
            visitingAccLongitude = double.parse(widget.dealer!.office_longitude);
            distanceFromCurrentLocation = calculateDistance(currentLatitude, currentLongitude, visitingAccLatitude, visitingAccLongitude);
            storeLocation();
          }
        });
      }

      else{

        print('hello ${widget.direct}');

        initialLatitude = currentLatitude;
        initialLongitude = currentLongitude;
      }
    }
  }

  @override
  Widget build(BuildContext context) {


    Employee emp =
        Provider.of<EmployeeProvider>(context, listen: false).employee;

    if(widget.funKey==1){
      location_type = 'home';
    } else if(widget.funKey==2){
      location_type = 'office';
    }

    print('funKey===> ${widget.funKey}');

    return WillPopScope(
      onWillPop: () async => allowBack,
      child: Scaffold(

        floatingActionButton: Visibility(
          visible: widget.showAccDialogue,
          child: FloatingActionButton(
            onPressed: (){
              showDialog(
            context: context,
            builder: (_) => const ChooseVisitPlanAccountsDialogue()
        );
            },
            child: Icon(Icons.add),
            foregroundColor: MyColors.boneWhite,
            backgroundColor: MyColors.appBarColor,
          ),
        ),
        backgroundColor: MyColors.boneWhite,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: CustomAppBar(
            module_name: 'Visit Plan',
            emp_name: getEmployeeName(context),
          ),
        ),
        body: FutureBuilder<void>(
          future: _getLocationFuture,
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                      color: MyColors.appBarColor,
                      size: 30
                  ));
            } else if(widget.showAccDialogue){
              //From Dashboard
              return Center(
                child: Container(
                  child: Column(
                    children: [
                      Flexible(
                        child: FlutterMap(
                          options: MapOptions(


                            initialCenter:
                            LatLng(currentLatitude, currentLongitude),
                            initialZoom: 15,
                          ),

                          children: [


                            TileLayer(
                              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                            ),
                            CircleLayer(
                              circles: circle_layers,
                            ),
                            MarkerLayer(
                              markers: initial_markers,
                            ),
                            PolylineLayer(
                                polylines: initial_polylines),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            //From account section
            else if(visitingAccLatitude>0 && visitingAccLongitude>0 && isLocationAlreadyPlotted){

              print(1);
              return Center(
                child: Container(
                  child: Column(
                    children: [
                      Flexible(
                        child: FlutterMap(
                          options: MapOptions(


                            initialCenter:
                            LatLng(visitingAccLatitude, visitingAccLongitude),
                            initialZoom: 15,
                          ),

                          children: [


                            TileLayer(
                              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                            ),
                            if(isLocationAlreadyPlotted)
                              PolylineLayer(polylines: [

                              Polyline(points: [
                                LatLng(currentLatitude, currentLongitude),
                                LatLng(visitingAccLatitude, visitingAccLongitude)
                              ],
                                  color: MyColors.blueColor,
                                  strokeWidth: 9
                              ),
                            ]),
                            CircleLayer(
                              circles: [
                                CircleMarker(
                                    point: LatLng(visitingAccLatitude, visitingAccLongitude),
                                    radius: 300,
                                    color: Colors.redAccent.withOpacity(0.15),
                                    useRadiusInMeter: true,
                                    borderStrokeWidth: 1,
                                    borderColor: MyColors.redColor
                                ),
                              ],
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: LatLng(currentLatitude, currentLongitude),
                                  width: 100,
                                  height: 100,
                                  child: const Icon(
                                    Icons.location_on,
                                    color: Colors.blue,
                                    size: 30,
                                  ),
                                ),
                                if(isLocationAlreadyPlotted)
                                Marker(
                                  point: LatLng(visitingAccLatitude,visitingAccLongitude),
                                  width: 100,
                                  height: 100,
                                  child: GestureDetector(
                                    onTap: (){
                                      onClickFun(widget.dealer!.id,0);
                                    },
                                    child: LocationMarker(visit_account_name: widget.dealer!.account_name)
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else{
              print('error===> my exception');
              return Container(
                child: Center(
                  child: Text('404 Not found!'),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}