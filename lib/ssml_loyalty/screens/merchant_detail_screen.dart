import 'package:flutter/material.dart';

import '../../constants/custom_app_bar.dart';
import '../../constants/my_colors.dart';
import '../../constants/utils.dart';
import '../../models/merchant_model.dart';
import '../services/ssml_loyalty_services.dart';

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
    return Scaffold(
        backgroundColor: MyColors.ashColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: CustomAppBar(
            module_name: widget.merchant.merchant_name,
            emp_name: '',
            module_font_weight: FontWeight.w600,
            show_emp_name: false,
            appBarColor: MyColors.ashColor,
            titleTextColor: MyColors.appBarColor,
            leadingIconColor: MyColors.appBarColor,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Icon(Icons.more_vert_outlined, color: MyColors.appBarColor,
                    size: 20),
              )
            ],
            leading: Icon(Icons.arrow_back_outlined, color: MyColors.appBarColor,
                size: 20),
          ),
        ),
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10).copyWith(top: 10),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(widget.merchant.merchant_cover_img),
                    fit: BoxFit.cover,
                  ),
                ),
                width: double.infinity,
                height: 150,
              )
            ],
          ),
      ),
    );
  }
}
