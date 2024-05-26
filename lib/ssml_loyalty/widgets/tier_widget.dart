import 'package:flutter/material.dart';
import 'package:retail_app_flutter/constants/assets_constants.dart';

import '../../constants/my_colors.dart';
import '../../constants/my_fonts.dart';

class TierWidget extends StatefulWidget {
  const TierWidget({super.key});

  @override
  State<TierWidget> createState() => _TierWidgetState();
}

class _TierWidgetState extends State<TierWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(AssetsConstants.bronze_badge, width: 80,height: 80,),
        Text(
          'Silver',
          maxLines: 1,
          style: TextStyle(
              color: MyColors.boneWhite,
              fontSize: 11,
              fontFamily: MyFonts.poppins,
              fontWeight: FontWeight.normal,
              overflow: TextOverflow.ellipsis
          ),
        )
      ],
    );
  }
}
