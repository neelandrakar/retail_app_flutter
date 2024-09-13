import 'package:flutter/material.dart';
import 'package:retail_app_flutter/models/merchant_model.dart';

import '../../constants/custom_app_bar.dart';
import '../../constants/global_variables.dart';
import '../../constants/my_colors.dart';
import '../widgets/app_bar_point_balance.dart';

class GIftRedemptionScreen extends StatefulWidget {
  final MerchantModel merchant;
  static const String routeName = '/gift-redemption-screen';
  const GIftRedemptionScreen({super.key, required this.merchant});

  @override
  State<GIftRedemptionScreen> createState() => _GIftRedemptionScreenState();
}

class _GIftRedemptionScreenState extends State<GIftRedemptionScreen> {

  Color bg_color = MyColors.boneWhite;
  Color fg_color = MyColors.ivoryWhite;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg_color,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: CustomAppBar(
          module_name: widget.merchant.merchant_name,
          emp_name: '',
          module_font_weight: FontWeight.w600,
          show_emp_name: false,
          appBarColor: bg_color,
          titleTextColor: MyColors.appBarColor,
          leadingIconColor: MyColors.appBarColor,
          actions: const [
            AppBarPointBalance(),
            Padding(
              padding:  EdgeInsets.only(right: 5),
              child: Icon(Icons.more_vert_outlined, color: MyColors.appBarColor,
                  size: 20),
            )
          ],
          leading: Icon(Icons.arrow_back_outlined, color: MyColors.appBarColor,
              size: 20)
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: horizonal_padding),
            Container(
              decoration: BoxDecoration(
                color: fg_color,
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(widget.merchant.merchant_cover_img),
                  fit: BoxFit.cover,
                ),
              ),
              width: double.infinity,
              height: 150,
            ),
            Text("Get a ${widget.merchant.merchant_name}'s coupon worth 500!")
          ],
        )
      ),
    );
  }
}
