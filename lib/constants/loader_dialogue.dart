import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:retail_app_flutter/constants/global_variables.dart';
import 'package:retail_app_flutter/constants/my_colors.dart';
import 'package:retail_app_flutter/constants/my_fonts.dart';

class LoaderDialogue extends StatefulWidget {
  final String loader_text;
  const LoaderDialogue({
    super.key,
    required this.loader_text
  });

  @override
  State<LoaderDialogue> createState() => _LoaderDialogueState();
}

class _LoaderDialogueState extends State<LoaderDialogue> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: MyColors.boneWhite, // Change the background color here
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Change the border radius here
      ),
      content: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            LoadingAnimationWidget.inkDrop(color: Colors.redAccent, size: 40),
            Text(widget.loader_text,
              style: TextStyle(
                color: MyColors.appBarColor,
                fontFamily: MyFonts.poppins,
                fontWeight: FontWeight.w600,
                fontSize: 15
              ),
            )
          ],
        ),
      ),
    );
  }
}
