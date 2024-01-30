import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:retail_app_flutter/constants/my_colors.dart';
import 'package:retail_app_flutter/constants/utils.dart';
import 'package:retail_app_flutter/visit_plan/screens/confirm_location_screen.dart';

import '../main.dart';
import 'custom_app_bar.dart';

class CameraScreen extends StatefulWidget {
  static const String routeName = '/camera-screen';
  final String account_name;
  final int functionalityKey;
  const CameraScreen({super.key, required this.account_name, required this.functionalityKey});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController controller;
  File? imageFile;
  bool imageCaptured = false;

  @override
  void initState() {
    super.initState();

    controller = CameraController(cameras[0], ResolutionPreset.high);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      backgroundColor: MyColors.appBarColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: CustomAppBar(
          module_name: 'Camera',
          emp_name: getEmployeeName(context),
        ),
      ),
      body: !imageCaptured ? CameraPreview(controller, child: Icon(Icons.camera, color: Colors.pinkAccent,),) : Image.file(imageFile!),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            foregroundColor: MyColors.appBarColor,
            backgroundColor: MyColors.boneWhite,
            child: imageCaptured ? Icon(Icons.check_circle_rounded) : Icon(Icons.camera_alt, size: 30,),
            onPressed: () async {
              if (!imageCaptured) {
                try {
                  final image = await controller.takePicture();
                  setState(() {
                    imageFile = File(image.path);
                    imageCaptured = true;
                  });
                  // Do something with the captured image
                  print('Image Path: ${image.path}');
                } catch (e) {
                  print(e);
                }
              } else {
                Navigator.pushNamed(
                    context, ConfirmLocationScreen.routeName,
                    arguments: [widget.account_name, widget.functionalityKey]
                );                print('Navigate to map');
              }
            }
          ),
          if(imageCaptured)
          SizedBox(width: 10),
          if(imageCaptured)
            GestureDetector(
            onTap: ()async{

              if(imageCaptured) {

                setState(() {
                  imageFile!.delete();
                  imageCaptured = false;
                });
              }

            },
            child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: MyColors.boneWhite,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Icon(Icons.refresh_outlined, color: MyColors.appBarColor,)),
          )
        ],
      ),
    );
  }
}