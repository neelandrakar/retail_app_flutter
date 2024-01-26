import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:retail_app_flutter/constants/global_variables.dart';
import 'package:retail_app_flutter/constants/my_colors.dart';
import 'package:retail_app_flutter/visit_plan/widgets/choose_visit_plan_dialogue.dart';
import '../../accounts/widgets/account_creation_list_dialogue.dart';
import '../../constants/custom_app_bar.dart';
import '../../models/employee.dart';
import '../../providers/user_provider.dart';

class VisitPlanScreen extends StatefulWidget {
  static const String routeName = '/visit-plan-screen';
  const VisitPlanScreen({Key? key}) : super(key: key);

  @override
  State<VisitPlanScreen> createState() => _VisitPlanScreenState();
}

class _VisitPlanScreenState extends State<VisitPlanScreen> {
  late double currentLatitude;
  late double currentLongitude;
  late Future<void> _getLocationFuture;

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

      showDialog(
          context: context,
          builder: (_)=> ChooseVisitPlanAccountsDialogue()
      );    }
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
          emp_name: emp.emp_name,
        ),
      ),
      body: FutureBuilder<void>(
        future: _getLocationFuture,
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: LoadingAnimationWidget.staggeredDotsWave(color: MyColors.appBarColor, size: 30));
          } else {
            return Center(
              child: Container(
                child: Column(
                  children: [
                    Flexible(
                      child: FlutterMap(
                        options: MapOptions(
                          initialCenter: LatLng(currentLatitude, currentLongitude),
                          initialZoom: 17,
                        ),

                        children: [

                          TileLayer(
                            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                          ),
                          // PolylineLayer(polylines: [
                          //
                          //   Polyline(points: [
                          //     LatLng(currentLatitude, currentLongitude),
                          //     LatLng(22.5808874, 88.4817859)
                          //   ],
                          //       color: MyColors.blueColor,
                          //       strokeWidth: 9
                          //   ),
                          // ]),
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
                              // Marker(
                              //   point: LatLng(22.5808874, 88.4817859),
                              //   width: 100,
                              //   height: 100,
                              //   child: Icon(
                              //     Icons.location_on,
                              //     color: Colors.red,
                              //     size: 30,
                              //   ),
                              // ),
                            ],
                          ),
                          CircleLayer(
                            circles: [
                              CircleMarker(
                                  point: LatLng(22.5808874, 88.4817859),
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