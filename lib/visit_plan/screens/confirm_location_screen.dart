import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:retail_app_flutter/constants/custom_elevated_button.dart';
import 'package:retail_app_flutter/constants/global_variables.dart';
import 'package:retail_app_flutter/constants/my_colors.dart';
import 'package:retail_app_flutter/constants/utils.dart';
import 'package:retail_app_flutter/models/dealer_master.dart';
import 'package:retail_app_flutter/visit_plan/widgets/choose_visit_plan_dialogue.dart';
import 'package:retail_app_flutter/visit_plan/widgets/set_lat_lon_dialogue.dart';
import '../../accounts/widgets/account_creation_list_dialogue.dart';
import '../../constants/custom_app_bar.dart';
import '../../constants/my_fonts.dart';
import '../../models/employee.dart';
import '../../providers/user_provider.dart';

class ConfirmLocationScreen extends StatefulWidget {
  static const String routeName = '/confirm-location-screen';
  final String account_name;
  final int funKey;
  const ConfirmLocationScreen({Key? key, required this.account_name, required this.funKey})
      : super(key: key);

  @override
  State<ConfirmLocationScreen> createState() => _ConfirmLocationScreenState();
}

class _ConfirmLocationScreenState extends State<ConfirmLocationScreen> {
  double currentLatitude = 0;
  double currentLongitude = 0;
  late Future<void> _getLocationFuture;
  String _address = 'NA';
  String locationType = 'NA';
  @override
  void initState() {
    super.initState();
    _getLocationFuture = getCurrentLocation();
  }

  Future<void> getAddressFromLatLang(double lat, double lon) async {
    List<Placemark> homePlaceMark = await placemarkFromCoordinates(lat, lon);
    Placemark homeAdd = homePlaceMark[0];
    _address =
    '${homeAdd.street}, ${homeAdd.subLocality}, ${homeAdd.locality}';
    showSnackBar(context, _address);
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
      getAddressFromLatLang(currentLatitude, currentLongitude);
    }
  }

  @override
  Widget build(BuildContext context) {
    Employee emp =
        Provider.of<EmployeeProvider>(context, listen: false).employee;

    if(widget.funKey==1){
      locationType = 'home';
    }

    return Scaffold(
      backgroundColor: MyColors.boneWhite,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: CustomAppBar(
          module_name: 'Confirm Location',
          emp_name: getEmployeeName(context),
        ),
      ),
      body: FutureBuilder<void>(
          future: _getLocationFuture,
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                      color: MyColors.appBarColor, size: 30));
            } else {
              return Stack(
                  children: [
                    FlutterMap(
                        options: MapOptions(
                          initialCenter: LatLng(currentLatitude, currentLongitude),
                          initialZoom: 17,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: LatLng(currentLatitude, currentLongitude),
                                width: 100,
                                height: 100,
                                child: Icon(
                                  Icons.location_on,
                                  color: MyColors.redColor,
                                  size: 40,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    Positioned(
                      top: 16,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Container(
                              width: 340,
                              height: 200,
                              decoration: BoxDecoration(
                                color: MyColors.appBarColor,
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    "Are you sure you want to plot ${widget.account_name}'s" ,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: MyColors.boneWhite,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 10,
                                        fontFamily: MyFonts.poppins),
                                  )

                                ],
                              ),
                            ),
                          )
                        ],
                      )
                    ),
                  ],
                );
            }
          }),
    );
  }
}
