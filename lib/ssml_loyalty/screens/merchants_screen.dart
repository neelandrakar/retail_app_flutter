import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:retail_app_flutter/constants/custom_search_field.dart';

import '../../constants/custom_app_bar.dart';
import '../../constants/global_variables.dart';
import '../../constants/my_colors.dart';
import '../../constants/utils.dart';
import '../services/ssml_loyalty_services.dart';


class MerchantsScreen extends StatefulWidget {
  const MerchantsScreen({super.key});

  @override
  State<MerchantsScreen> createState() => _MerchantsScreenState();
}

class _MerchantsScreenState extends State<MerchantsScreen> {

  String pageName = 'Merchants';
  ScrollController _scrollController = ScrollController();
  int tierWidgetWidth = 140;
  int currTier = 0;
  SSMLLoyaltyServices ssmlLoyaltyServices = SSMLLoyaltyServices();
  late Future<void> _getGiftCategoryData;
  TextEditingController _searchController = TextEditingController();

  fetchGiftCategoryData() async {
    await ssmlLoyaltyServices.getMerchantsData(
      context: context,
      onSuccess: () {
        setState(() {
          isGiftCategoriesFullyLoaded = true;
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    print('hii');
    _getGiftCategoryData = fetchGiftCategoryData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    isGiftCategoriesFullyLoaded = false;
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
          future: _getGiftCategoryData,
          builder: (context, snapshot) {
            if (!isGiftCategoriesFullyLoaded) {
              return Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: MyColors.appBarColor,
                  size: 30,
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  children: [
                    CustomSearchField(
                        controller: _searchController,
                        hintText: "Search Merchants",
                        hintTextColor: MyColors.fadedBlack,
                        hintTextWeight: FontWeight.normal,
                        hintTextSize: 16,
                        searchFieldColor: MyColors.boneWhite,
                        maxLength: 50,
                        width: double.infinity,
                        height: 50,
                        textInputType: TextInputType.text,
                        textColor: MyColors.blackColor,
                        onChanged: (String text){
                          print(text);
                        },
                    ),
                    FilterChip(label: Text('Hello'), onSelected: (bool value)
                    {
                      setState(() {
                      });
                    },)
                  ],
                ),
              );
            }
          }
      ),
    );
  }
}
