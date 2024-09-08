import 'package:flutter/material.dart';

import '../../constants/custom_app_bar.dart';
import '../../constants/my_colors.dart';
import '../widgets/app_bar_point_balance.dart';

class GIftRedemptionScreen extends StatefulWidget {
  static const String routeName = '/gift-redemption-screen';
  const GIftRedemptionScreen({super.key});

  @override
  State<GIftRedemptionScreen> createState() => _GIftRedemptionScreenState();
}

class _GIftRedemptionScreenState extends State<GIftRedemptionScreen> {

  Color bg_color = MyColors.boneWhite;
  Color fg_color = MyColors.ivoryWhite;
  double horizonal_padding = 15;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: CustomAppBar(
            module_name: 'Redemption',
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
          )
      ),
    );
  }
}
