import 'package:flutter/material.dart';
import 'package:retail_app_flutter/constants/my_fonts.dart';
import 'package:retail_app_flutter/ssml_loyalty/screens/gift_redemption_screen.dart';
import 'package:retail_app_flutter/ssml_loyalty/widgets/app_bar_point_balance.dart';
import 'package:retail_app_flutter/ssml_loyalty/widgets/coupon_card.dart';

import '../../constants/custom_app_bar.dart';
import '../../constants/my_colors.dart';
import '../../constants/utils.dart';
import '../../models/merchant_model.dart';
import '../services/ssml_loyalty_services.dart';
import '../widgets/info_widget.dart';

class MerchantDetailScreen extends StatefulWidget {
  final MerchantModel merchant;
  static const String routeName = '/merchant-detail-screen';
  const MerchantDetailScreen({super.key, required this.merchant});

  @override
  State<MerchantDetailScreen> createState() => _MerchantDetailScreenState();
}

class _MerchantDetailScreenState extends State<MerchantDetailScreen> {

  SSMLLoyaltyServices ssmlLoyaltyServices = SSMLLoyaltyServices();
  late Future<void> _getMerchantDetails;
  late MerchantModel merchant;
  Color bg_color = MyColors.boneWhite;
  Color fg_color = MyColors.ivoryWhite;
  double horizonal_padding = 15;

  fetchGiftCategoryData() async {
    await ssmlLoyaltyServices.getMerchantsData(
      context: context,
      onSuccess: () {
        setState(() {

        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    print('hii');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
          backgroundColor: bg_color,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(285),
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
                  size: 20),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(100),
                child: Container(
                  color: bg_color,
                  padding: EdgeInsets.symmetric(horizontal: horizonal_padding),
                  child: Column(
                    children: [
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
                      SizedBox(height: 20,),

                      Container(
                        height: 40,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: MyColors.topNavigationBarUnselected,

                        ),
                        child: TabBar(

                          indicator: BoxDecoration(
                              color: MyColors.topNavigationBarSelected,

                              borderRadius: BorderRadius.circular(10)
                          ),
                          labelColor: MyColors.appBarColor,
                          dividerHeight: 0,

                          // unselectedLabelColor: MyColors.topNavigationBarSelected,
                          tabs: [
                            Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: const Text(
                                  'Info',
                                style: TextStyle(
                                  fontFamily: MyFonts.poppins
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: const Text(
                                'Coupons',
                                style: TextStyle(
                                    fontFamily: MyFonts.poppins
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: const Text(
                                'Store',
                                style: TextStyle(
                                    fontFamily: MyFonts.poppins
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ),

        body: TabBarView(
          children: [
            Center(
              child: InfoWidget(
                about_us: widget.merchant.about_us,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizonal_padding).copyWith(top: 20),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemBuilder: (context, index){
                          return CouponCard(
                            is_last: index == widget.merchant.coupons.length-1 ? true : false,
                            is_first: index == 0 ? true : false,
                            coupon: widget.merchant.coupons[index],
                          );
                        },
                        itemCount: widget.merchant.coupons.length
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Text("It's sunny here"),
            )
          ],
        ),
        ),
    );
  }
}
