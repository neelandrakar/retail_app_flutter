import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retail_app_flutter/attendance/screens/attendance_screen.dart';
import 'package:retail_app_flutter/constants/my_colors.dart';
import 'package:retail_app_flutter/home/screens/home_screen.dart';
import 'package:retail_app_flutter/providers/attendance_model_provider.dart';
import 'package:retail_app_flutter/providers/dashboard_menu_provider.dart';
import 'package:retail_app_flutter/providers/user_provider.dart';
import 'package:retail_app_flutter/router.dart';
import 'package:retail_app_flutter/sign_in/screens/sign_in_screen.dart';
import 'package:retail_app_flutter/sign_in/services/sign_in_services.dart';

void main() {
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context)=> EmployeeProvider()),
          ChangeNotifierProvider(create: (context)=> AttendanceModelProvider()),
          ChangeNotifierProvider(create: (context)=> DashboardMenuProvider()),
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

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      signInServices.getUserData(context);
    });
    // TODO: implement initState
    super.initState();
  }


    // This widget is the root of your application.
    @override
    Widget build(BuildContext context) {
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
  }