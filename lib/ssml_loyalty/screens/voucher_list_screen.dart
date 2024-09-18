import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:retail_app_flutter/models/my_vouchers.dart';
import 'package:retail_app_flutter/providers/my_vouchers_provider.dart';

import '../../constants/custom_app_bar.dart';
import '../../constants/global_variables.dart';
import '../../constants/my_colors.dart';
import '../../constants/utils.dart';
import '../services/ssml_loyalty_services.dart';
import '../widgets/single_voucher_card.dart';

class VoucherListScreen extends StatefulWidget {
  const VoucherListScreen({super.key});

  @override
  State<VoucherListScreen> createState() => _VoucherListScreenState();
}

class _VoucherListScreenState extends State<VoucherListScreen> {
  String pageName = "My Vouchers";
  SSMLLoyaltyServices ssmlLoyaltyServices = SSMLLoyaltyServices();
  late Future<void> _getMyVouchersData;
  late List<MyVouchers> myVouchers = [];


  fetchGiftCategoryData() async {
    await ssmlLoyaltyServices.getRedeemedCoupons(
      context: context,
      onSuccess: () {
        setState(() {
          myVouchers = Provider
              .of<MyVouchersProvider>(context, listen: false)
              .my_vouchers;
          isMyVoucherListFullyLoaded = true;
          print("Vouchers are fetched ${myVouchers.length}");

        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _getMyVouchersData = fetchGiftCategoryData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColors.ashColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: CustomAppBar(
            module_name: pageName,
            emp_name: getEmployeeName(context),
            leading: Icon(Icons.menu_outlined, color: MyColors.actionsButtonColor,
                size: 20),
          ),
        ),
        body: FutureBuilder(
            future: _getMyVouchersData,
            builder: (context, snapshot) {
              if (!isMyVoucherListFullyLoaded) {
                return Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                    color: MyColors.appBarColor,
                    size: 30,
                  ),
                );
              } else {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizonal_padding, vertical: 15),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          itemCount: myVouchers.length,
                          itemBuilder: (context, index) {
                            return SingleVoucherCard(
                              merchant_img: myVouchers[index].merchant_img,
                              id: myVouchers[index].id,
                              coupon_value: myVouchers[index].coupon_value,
                              code: myVouchers[index].code,
                              expiry_date: myVouchers[index].expiry_date,
                              merchant_name: myVouchers[index].merchant_name,
                              redeemed_on: myVouchers[index].redeemed_on,
                              header_text: myVouchers[index].header_text,
                              is_expired: myVouchers[index].is_expired,
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(height: 5);
                        },
                        ),
                      ),
                    ],
                  ),
                );
              }
            }
        ),
    );
  }
}
