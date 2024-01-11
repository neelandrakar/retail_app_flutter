import 'package:flutter/material.dart';
import 'package:retail_app_flutter/constants/assets_constants.dart';
import 'package:retail_app_flutter/constants/custom_button.dart';
import 'package:retail_app_flutter/constants/custom_textfield.dart';
import 'package:retail_app_flutter/constants/my_colors.dart';
import 'package:retail_app_flutter/sign_in/services/sign_in_services.dart';
import 'package:retail_app_flutter/sign_in/widgets/bezier_clipper.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {

    final TextEditingController _usernameController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final _checkUsernamePasswordKey = GlobalKey<FormState>();
    final SignInServices signInServices = SignInServices();

    void signInMethod() {
        print(_usernameController.text.trim());
        print(_passwordController.text.trim());

        signInServices.signIn(
            context: context,
            username: _usernameController.text.trim(),
            password: _passwordController.text.trim());


      // print(_usernameController.text.trim());
      // print(_passwordController.text.trim());
    }

    return Scaffold(
      backgroundColor: MyColors.offWhiteColor,
      body: SafeArea(
        child:
            ClipPath(
              clipper: BezierClipper1(),
                child: Container(
                  color: MyColors.darkBlueColor,
                  height: 800,
                  width: double.infinity,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(AssetsConstants.shyam_steel_logo_round,width: 200,height: 200,),
                          Padding(
                            padding: const EdgeInsets.only(right: 250),
                            child: Divider(height: 4,color: MyColors.mainYellowColor,thickness: 3,),
                          ),
                          SizedBox(height: 10,),
                          Text(
                            'Sign in',
                            style: TextStyle(
                              color: MyColors.whiteColor,
                              fontSize: 30,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(height: 10,),
                          CustomTextField(controller: _usernameController, hintText: 'Username'),
                          SizedBox(height: 10,),
                          CustomTextField(controller: _passwordController, hintText: 'Password'),
                          SizedBox(height: 40,),
                          CustomButton(
                            onClick: (){
                              signInMethod();
                            },
                            buttonText: 'Sign in',
                            borderRadius: 25,
                            height: 45,
                            textColor: MyColors.darkBlueColor,
                          )
                        ],
                      ),
                    ),
                  ),

                )),
            // Container(color: MyColors.offWhiteColor,height: 300,)
        )
      );
  }
}
