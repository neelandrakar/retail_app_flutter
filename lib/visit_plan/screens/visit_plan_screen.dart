import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:retail_app_flutter/constants/global_variables.dart';
import 'package:retail_app_flutter/constants/my_colors.dart';
import 'package:retail_app_flutter/constants/utils.dart';
import 'package:retail_app_flutter/models/dealer_master.dart';
import 'package:retail_app_flutter/visit_plan/widgets/choose_visit_plan_dialogue.dart';
import 'package:retail_app_flutter/visit_plan/widgets/set_lat_lon_dialogue.dart';
import '../../accounts/widgets/account_creation_list_dialogue.dart';
import '../../constants/custom_app_bar.dart';
import '../../models/employee.dart';
import '../../providers/user_provider.dart';

class VisitPlanScreen extends StatefulWidget {
  static const String routeName = '/visit-plan-screen';
  final bool showAccDialogue;
  final DealerMaster? dealer;
  const VisitPlanScreen({Key? key, required this.showAccDialogue, this.dealer}) : super(key: key);

  @override
  State<VisitPlanScreen> createState() => _VisitPlanScreenState();
}

class _VisitPlanScreenState extends State<VisitPlanScreen> {
  double currentLatitude = 0;
  double currentLongitude = 0;
  double visitingAccLatitude =0 ;
  double visitingAccLongitude=0;
  late double initialLatitude;
  late double initialLongitude;
  late Future<void> _getLocationFuture;
  bool isLocationAlreadyPlotted = false;
  double distanceFromCurrentLocation = 0.0;
  String currentLocationData = 'NA';

  @override
  void initState() {
    super.initState();
    _getLocationFuture = getCurrentLocation();

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

      if (widget.showAccDialogue) {
        showDialog(
            context: context,
            builder: (_) => const ChooseVisitPlanAccountsDialogue()
        );
      }

      if(widget.dealer!=null){

        visitingAccLatitude = double.parse(widget.dealer!.latitude);
        visitingAccLongitude = double.parse(widget.dealer!.longitude);

        showDialog(
            context: context,
            builder: (_) => SetLatLonDialogue(dealer: widget.dealer!)
        );

        if(visitingAccLatitude != 0.0 || visitingAccLongitude != 0.0) {
          initialLatitude = visitingAccLatitude;
          initialLongitude = visitingAccLongitude;

          distanceFromCurrentLocation = calculateDistance(currentLatitude, currentLongitude, visitingAccLatitude, visitingAccLongitude);

          isLocationAlreadyPlotted = true;
        } else{

          initialLatitude = currentLatitude;
          initialLongitude = currentLongitude;
        }
      } else{

        initialLatitude = currentLatitude;
        initialLongitude = currentLongitude;
      }
    }
  }

  @override
  Widget build(BuildContext context) {


    Employee emp =
        Provider.of<EmployeeProvider>(context, listen: false).employee;


    return Scaffold(
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
          } else {
            return Center(
              child: Container(
                child: Column(
                  children: [
                    Flexible(
                      child: FlutterMap(
                        options: MapOptions(

                          initialCenter:
                          LatLng(initialLatitude, initialLongitude),
                          initialZoom: 16,
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
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: LatLng(currentLatitude, currentLongitude),
                                width: 100,
                                height: 100,
                                child: Icon(
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
                                  onTap: () async {

                                    print(distanceFromCurrentLocation);
                                    // String address = await getAddressFromLatLon(visitingAccLatitude, visitingAccLongitude);
                                    // print(address);
                                    if(distanceFromCurrentLocation<=300){

                                      print('You can submit visit remarks');
                                    } else {
                                       print('Please move closer within 300 meters of ${widget.dealer!.account_name}');
                                    }
                                  },
                                  child: Icon(
                                    Icons.location_on,
                                    color: Colors.red,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          CircleLayer(
                            circles: [
                              CircleMarker(
                                  point: LatLng(visitingAccLatitude, visitingAccLongitude),
                                  radius: 300,
                                  color: Colors.redAccent.withOpacity(0.4),
                                  useRadiusInMeter: true,
                                  borderStrokeWidth: 1,
                                  borderColor: MyColors.redColor
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
          }
        },
      ),
    );
  }
}