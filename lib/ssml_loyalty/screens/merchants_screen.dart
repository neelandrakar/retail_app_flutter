import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:retail_app_flutter/constants/custom_search_field.dart';
import 'package:retail_app_flutter/constants/my_fonts.dart';
import 'package:retail_app_flutter/models/gift_category_model.dart';
import 'package:retail_app_flutter/models/merchant_model.dart';
import 'package:retail_app_flutter/providers/gift_category_provider.dart';
import 'package:retail_app_flutter/ssml_loyalty/screens/merchant_detail_screen.dart';
import 'package:retail_app_flutter/ssml_loyalty/widgets/merchant_menu_item.dart';

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
  late List<GiftCategoryModel> giftCategoryModel;
  List<MerchantModel> searchedMerchants = [];
  int filter_val = 0;
  bool hasBeenSearched = false;

  fetchGiftCategoryData() async {
    await ssmlLoyaltyServices.getMerchantsData(
      context: context,
      onSuccess: () {
        setState(() {
          giftCategoryModel = Provider
              .of<GiftCategoryProvider>(context, listen: false)
              .gift_categories;
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
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
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

                          setState(() {
                            searchedMerchants = []; // Clear the list before adding new items

                            for(int i=0; i<giftCategoryModel[filter_val].merchants.length; i++){
                              if (giftCategoryModel[filter_val].merchants[i].merchant_name.toLowerCase().contains(text.toLowerCase())) {
                                print('The list contains the search filter ${text} ');
                                searchedMerchants.add(giftCategoryModel[filter_val].merchants[i]);
                              }
                            }

                            if (searchedMerchants.isEmpty) {
                              hasBeenSearched = false;
                            } else {
                              hasBeenSearched = true;
                            }
                          });
                        },
                    ),
                    const SizedBox(height: 5),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: techChips(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15 ,
                        children: hasBeenSearched ?
                        (List.generate(searchedMerchants.length, (i) {
                          return MerchantMenuItem(
                            img_url: searchedMerchants[i].merchant_logo,
                            merchant_name: searchedMerchants[i].merchant_name,
                            gift_category_name: filter_val == 0 ? searchedMerchants[i].gift_category_name : giftCategoryModel[filter_val].gift_category_name,
                            onClick: (){},
                          );
                        }))
                            : List.generate(giftCategoryModel[filter_val].merchants.length, (i) {
                          return MerchantMenuItem(
                            img_url: giftCategoryModel[filter_val].merchants[i].merchant_logo,
                            merchant_name: giftCategoryModel[filter_val].merchants[i].merchant_name,
                            gift_category_name: filter_val == 0 ? giftCategoryModel[filter_val].merchants[i].gift_category_name : giftCategoryModel[filter_val].gift_category_name,
                            onClick: (){

                              List<dynamic> args = [ giftCategoryModel[filter_val].merchants[i].merchant_id,
                                giftCategoryModel[filter_val].merchants[i].merchant_name];

                              Navigator.pushNamed(
                                  context,
                                  MerchantDetailScreen.routeName,
                                  arguments:
                                    giftCategoryModel[filter_val].merchants[i],

                              );
                            },
                          );
                        })),
                    )
                  ],
                ),
              );
            }
          }
      ),
    );
  }

  List<Widget> techChips () {
    List<Widget> chips = [];
    for (int i=0; i< giftCategoryModel.length; i++) {
      Widget item = Padding(
        padding: const EdgeInsets.only(left:5, right: 2), // Reduce the left and right padding
        child: FilterChip(
          label: Text(
            giftCategoryModel[i].gift_category_name,
            style: TextStyle(
              color: i==filter_val ? MyColors.boneWhite : MyColors.blackColor,
              fontFamily: MyFonts.poppins,
              fontSize: 12,
            ),
          ),
          backgroundColor: MyColors.boneWhite,
          selected: filter_val == i,
          selectedColor: Colors.pink,
          showCheckmark: false,
          shape: const StadiumBorder(side: BorderSide.none),
          onSelected: (bool value)
          {
            setState(() {
              filter_val = (value ? i : null)!;
              print(giftCategoryModel[i].gift_category_name);
              hasBeenSearched = false;
              _searchController.clear();
            });
          },
        ),
      );
      chips.add(item);
    }
    return chips;
  }


}
