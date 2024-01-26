import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:retail_app_flutter/constants/my_colors.dart';

import '../../constants/my_fonts.dart';

class DataSyncItemCard extends StatefulWidget {
  final String itemText;
  final bool isDone;
  const DataSyncItemCard({super.key, required this.itemText, required this.isDone});

  @override
  State<DataSyncItemCard> createState() => _DataSyncItemCardState();
}

class _DataSyncItemCardState extends State<DataSyncItemCard> {

  Widget loaderIconDone = Icon(Icons.check_circle_rounded, color: MyColors.greenColor,size: 18,);
  Widget loaderIconNotDone = LoadingAnimationWidget.staggeredDotsWave(color: MyColors.greenColor, size: 18);



  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: MyColors.boneWhite,
        border: Border(
          top: BorderSide(
            color: Colors.black12,
            width: 1
          ),
          bottom: BorderSide(
            color: Colors.black12,
            width: 1
        ),
        )
      ),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          widget.isDone ? loaderIconDone : loaderIconNotDone,
          SizedBox(width: 10,),
          Container(
            width: 230,
            child: Text('${widget.itemText}...',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: MyColors.blackColor,
                  fontFamily: MyFonts.poppins,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
              ),
            ),
          ),

        ],
      ),
    );
  }
}
