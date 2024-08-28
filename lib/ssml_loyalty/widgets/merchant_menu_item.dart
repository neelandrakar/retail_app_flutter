import 'package:flutter/material.dart';
import 'package:retail_app_flutter/constants/my_colors.dart';
import 'package:retail_app_flutter/constants/my_fonts.dart';

class MerchantMenuItem extends StatefulWidget {
  const MerchantMenuItem({super.key, required this.img_url, required this.merchant_name, required this.gift_category_name, required this.onClick});
  final String img_url;
  final String merchant_name;
  final String gift_category_name;
  final VoidCallback onClick;

  @override
  State<MerchantMenuItem> createState() => _MerchantMenuItemState();
}

class _MerchantMenuItemState extends State<MerchantMenuItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
          decoration: BoxDecoration(
            color: MyColors.boneWhite,
            shape: BoxShape.rectangle
          ),
         child: InkWell(
           onTap: widget.onClick,
           child: Column(
             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
             children: [
                Image.network(widget.img_url, width: 70, height: 70),
               Text(
                 widget.merchant_name,
                 maxLines: 1,
                 style: TextStyle(
                   fontSize: 15,
                   fontFamily: MyFonts.poppins,
                   fontWeight: FontWeight.w600,
                   overflow: TextOverflow.ellipsis
                 ),
               ),
               Text(
                 widget.gift_category_name,
                 maxLines: 1,
                 style: TextStyle(
                     fontSize: 12,
                     color: Colors.pink,
                     fontFamily: MyFonts.poppins,
                     fontWeight: FontWeight.w500,
                     overflow: TextOverflow.ellipsis
                 ),
               )
             ],
           ),
         ),

    );
  }
}
