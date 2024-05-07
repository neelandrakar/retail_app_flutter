import 'package:flutter/material.dart';
import 'package:retail_app_flutter/constants/assets_constants.dart';

class OdometerDialogue extends StatelessWidget {
  final String odometerImage;
  const OdometerDialogue({super.key, required this.odometerImage});

  @override
  Widget build(BuildContext context) {
    
    String demoImg = "https://upload.wikimedia.org/wikipedia/commons/thumb/4/46/Eden_Hazard_at_Baku_before_2019_UEFA_Europe_League_Final.jpg/220px-Eden_Hazard_at_Baku_before_2019_UEFA_Europe_League_Final.jpg";

    String img = odometerImage.isNotEmpty ? odometerImage : demoImg;


    return Dialog(
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
            image: DecorationImage(image: NetworkImage(img), fit: BoxFit.fitHeight)
        ),
      ),
    );
  }
}