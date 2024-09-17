import 'dart:math';
import 'dart:ui';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:retail_app_flutter/accounts/widgets/account_creation_list_dialogue.dart';
import 'package:retail_app_flutter/constants/loader_dialogue.dart';
import 'package:retail_app_flutter/constants/my_fonts.dart';
import 'package:retail_app_flutter/constants/utils.dart';
import 'package:retail_app_flutter/models/merchant_model.dart';
import '../../constants/custom_app_bar.dart';
import '../../constants/custom_button.dart';
import '../../constants/global_variables.dart';
import '../../constants/my_colors.dart';
import '../../models/coupon_model.dart';
import '../services/ssml_loyalty_services.dart';
import '../widgets/app_bar_point_balance.dart';
import '../widgets/successful_redeem_dialogue.dart';

class GIftRedemptionScreen extends StatefulWidget {
  final MerchantModel merchant;
  final CouponModel coupon;
  static const String routeName = '/gift-redemption-screen';
  const GIftRedemptionScreen({
    super.key,
    required this.merchant,
    required this.coupon
  });

  @override
  State<GIftRedemptionScreen> createState() => _GIftRedemptionScreenState();
}

class _GIftRedemptionScreenState extends State<GIftRedemptionScreen> {
  Color bg_color = MyColors.boneWhite;
  Color fg_color = MyColors.ivoryWhite;
  double percentage = 0;
  double total_points = 0;
  double coupon_value = 0;
  String header_text = "NA";
  SSMLLoyaltyServices ssmlLoyaltyServices = SSMLLoyaltyServices();
  Map<String, dynamic> resData = {};
  bool _isLoading = false;
  late ConfettiController _controllerCenter;
  late ConfettiController _controllerCenterRight;
  late ConfettiController _controllerCenterLeft;
  late ConfettiController _controllerTopCenter;
  late ConfettiController _controllerBottomCenter;

  @override
  void initState() {
    super.initState();
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 5));
    _controllerCenterRight =
        ConfettiController(duration: const Duration(seconds: 5));
    _controllerCenterLeft =
        ConfettiController(duration: const Duration(seconds: 5));
    _controllerTopCenter =
        ConfettiController(duration: const Duration(seconds: 5));
    _controllerBottomCenter =
        ConfettiController(duration: const Duration(seconds: 5));
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    _controllerCenterRight.dispose();
    _controllerCenterLeft.dispose();
    _controllerTopCenter.dispose();
    _controllerBottomCenter.dispose();
    super.dispose();
  }

  /// A custom Path to paint stars.
  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  redeemCoupon() async {
    showDialog(
        context: context,
        builder: (BuildContext con){
          return LoaderDialogue(
            loader_text: 'Redeeming Points...',
          );
        });
    setState(() {
      _isLoading = true; // Set the loader state to true when the button is clicked
    });


        await ssmlLoyaltyServices.redeemACoupon(
        context: context,
        coupon_id: widget.coupon.id,
        onSuccess: (){
          setState(() {
            _isLoading = false; // Set the loader state to false when onSuccess is called
            Navigator.pop(context);
            if (mounted) {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext con){
                    return
                        WillPopScope(
                          onWillPop: () async => false, // <-- Prevents dialog dismiss on press of back button.
                          child: Stack(
                          children: [
                                Center(
                                  child: ConfettiWidget(
                                  confettiController: _controllerCenter,
                                  blastDirectionality: BlastDirectionality.explosive,
                                  shouldLoop: false,
                                  colors: const [
                                    Colors.green,
                                    Colors.blue,
                                    Colors.pink,
                                    Colors.orange,
                                    Colors.purple
                                  ],
                                  createParticlePath: drawStar,
                                  ),
                                ),
                                SuccessfulRedeemDialogue(
                                  header_text: gift_redemption_header_text,
                                  msg: gift_redemption_msg
                                )
                          ],
                                              ),
                        );
                  });
              _controllerCenter.play();
            }
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    total_points = getTotalPoints(context);
    coupon_value = widget.coupon.coupon_value.toDouble();
    double percent_val = total_points/coupon_value;
    percentage = percent_val>= 1 ? 1 : percent_val;
    header_text = widget.merchant.merchant_name.endsWith("s") ? "Get a ${widget.merchant.merchant_name}' coupon worth ₹${widget.coupon.coupon_value}" : "Get a ${widget.merchant.merchant_name}'s coupon worth ₹${widget.coupon.coupon_value}";

    return WillPopScope(
      onWillPop: () async {
        return true; // Return false when _isLoading is true
      },
      child: Scaffold(
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
                  padding: EdgeInsets.symmetric(horizontal: horizonal_padding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
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
                            const SizedBox(height: 20),
                            Text(
                              header_text,
                              maxLines: 2,
                              style: const TextStyle(
                                  fontFamily: MyFonts.poppins,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: MyColors.appBarColor
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Offer will end on December 31st, 2024",
                              maxLines: 2,
                              style: TextStyle(
                                  fontFamily: MyFonts.poppins,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: MyColors.fadedBlack
                              ),
                            ),
                            const SizedBox(height: 15),
                            LinearPercentIndicator(
                              animation: true,
                              padding: EdgeInsets.zero,
                              lineHeight: 3,
                              animationDuration: 2500,
                              percent: percentage,
                              progressColor: MyColors.loyaltyRed,
                            ),
                            const SizedBox(height: 10),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "${total_points.toInt()}",
                                    style: TextStyle(
                                      fontFamily: MyFonts.poppins,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      color: MyColors.loyaltyRed, // Set the color to red
                                    ),
                                  ),
                                  TextSpan(
                                    text: " / ${coupon_value.toInt()}",
                                    style: TextStyle(
                                      fontFamily: MyFonts.poppins,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      color: MyColors.fadedBlack, // Keep the original color
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 15),
                            Divider(
                              height: 1,
                              color: MyColors.fadedBlack,
                              thickness: 0.2  ,
                            ),
                            SizedBox(height: 16),
                            Text(
                              widget.merchant.rewards_screen_text,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: MyFonts.poppins
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              "Terms and Conditions:",
                              maxLines: 1,
                              style: const TextStyle(
                                  fontFamily: MyFonts.poppins,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: MyColors.appBarColor
                              ),
                            ),
                            SizedBox(height: 8),
                            _buildTermItem('Available to members with a minimum of ${widget.coupon.coupon_value} points.'),
                            _buildTermItem('Redeemable once within 30 days.'),
                            _buildTermItem('E-voucher valid for 30 days from redemption.'),
                            _buildTermItem('Complimentary tall-sized coffee of your choice.')
                          ]
                      ),
                            Padding(
                              padding: const EdgeInsets.all(8.0).copyWith(bottom: 15),
                              child: AbsorbPointer(
                                absorbing: _isLoading, // Set absorbing to true when _isLoading is true
                                child: CustomButton(
                                  height: 50,
                                  width: double.infinity,
                                  textColor: MyColors.boneWhite,
                                  buttonColor: MyColors.loyaltyRed,
                                  onClick: ()async{
            
                                      await redeemCoupon();
            
                                  },
                                  buttonText: 'Redeem',
                                  buttonTextSize: 16,
                                  borderRadius: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
            
                    ],
                  ),
                ),
      ),
    );
  }

  Widget _buildTermItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16)),
          Expanded(
            child: Text(
                text,
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: MyFonts.poppins
                )
            ),
          ),
        ],
      ),
    );
  }
}