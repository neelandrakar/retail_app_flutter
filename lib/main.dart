import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:retail_app_flutter/attendance/screens/attendance_screen.dart';
import 'package:retail_app_flutter/constants/assets_constants.dart';
import 'package:retail_app_flutter/constants/global_variables.dart';
import 'package:retail_app_flutter/constants/my_colors.dart';
import 'package:retail_app_flutter/constants/utils.dart';
import 'package:retail_app_flutter/home/screens/home_screen.dart';
import 'package:retail_app_flutter/providers/attendance_model_provider.dart';
import 'package:retail_app_flutter/providers/dashboard_menu_provider.dart';
import 'package:retail_app_flutter/providers/dealer_master_provider.dart';
import 'package:retail_app_flutter/providers/dealer_target_achievement_provider.dart';
import 'package:retail_app_flutter/providers/distributor_master_provider.dart';
import 'package:retail_app_flutter/providers/engineer_master_provider.dart';
import 'package:retail_app_flutter/providers/gift_category_provider.dart';
import 'package:retail_app_flutter/providers/my_vouchers_provider.dart';
import 'package:retail_app_flutter/providers/ssml_loyalty_provider.dart';
import 'package:retail_app_flutter/providers/user_provider.dart';
import 'package:retail_app_flutter/providers/visit_questions_provider.dart';
import 'package:retail_app_flutter/router.dart';
import 'package:retail_app_flutter/sign_in/screens/sign_in_screen.dart';
import 'package:retail_app_flutter/sign_in/services/sign_in_services.dart';

List<CameraDescription> cameras = [];
void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context)=> VisitQuestionsProvider()),
          ChangeNotifierProvider(create: (context)=> EmployeeProvider()),
          ChangeNotifierProvider(create: (context)=> AttendanceModelProvider()),
          ChangeNotifierProvider(create: (context)=> DashboardMenuProvider()),
          ChangeNotifierProvider(create: (context)=> DealerMasterProvider()),
          ChangeNotifierProvider(create: (context)=> DistributorMasterProvider()),
          ChangeNotifierProvider(create: (context)=> EngineerMasterProvider()),
          ChangeNotifierProvider(create: (context)=> DealerTargetAchievementProvider()),
          ChangeNotifierProvider(create: (context)=> SSMLLoyaltyProvider()),
          ChangeNotifierProvider(create: (context)=> GiftCategoryProvider()),
          ChangeNotifierProvider(create: (context)=> MyVouchersProvider()),
        ],
        child: const MyApp(),
      ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final SignInServices signInServices = SignInServices();
  bool fullyLoaded = false;

  Future<void> _requestPermissions() async {

    try {
      /// Initialize Ip Address
      var ipAddress = IpAddress(type: RequestType.json);

      /// Get the IpAddress based on requestType.
      dynamic data = await ipAddress.getIpAddress();
      print(data.toString());
    } on IpAddressException catch (exception) {

    }

      /// Handle the exception.

      // appVersion = await getAppInfo();
    final PermissionStatus cameraStatus = await Permission.camera.request();
    if (cameraStatus.isGranted) {
      print('Camera permission is granted');
      final PermissionStatus locationStatus = await Permission.location
          .request();
      if (locationStatus.isGranted) {
        print('Location permission is granted');
      } else {
        print('Location permission is denied');
      }
    } else {
      print('Permission is denied');
    }
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {


      _requestPermissions();
      signInServices.getUserData(context, (){
        print('is fully loaded');
        setState(() {
          fullyLoaded = true;
        });
      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return FutureBuilder(
      future: Future.delayed(Duration(seconds: 1)), // replace this with your async operation
      builder: (context, snapshot) {
        if (!fullyLoaded) {
          return Container(
            color: MyColors.appBarColor,
            child: Center(
              child: Image.asset(AssetsConstants.shyam_steel_logo_round),
            ),
          ); // or any other loading indicator
        } else {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Retail CRM Flutter',
            onGenerateRoute: (settings) => generateRoute(settings),
            theme: ThemeData(
              // colorScheme: ColorScheme.light(),
              primaryColor: MyColors.mainYellowColor,
              useMaterial3: true,
            ),
            home: Provider.of<EmployeeProvider>(context).employee.jwt_token.isNotEmpty
                ? AttendanceScreen()
                : SignInScreen(),
          );
        }
      },
    );
  }
}