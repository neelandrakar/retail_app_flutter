import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:retail_app_flutter/change_password/services/change_password_services.dart';
import 'package:retail_app_flutter/constants/custom_elevated_button.dart';
import 'package:retail_app_flutter/constants/password_textfield.dart';
import 'package:retail_app_flutter/home/screens/home_screen.dart';

import '../../constants/custom_app_bar.dart';
import '../../constants/my_colors.dart';
import '../../constants/my_fonts.dart';
import '../../constants/utils.dart';
import '../../sidemenu/screens/side_menu.dart';

class ChangePasswordScreen extends StatefulWidget {
  static const String routeName = '/change-password-screen';
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  int side_menu_item_no = 5;
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();
  ChangePasswordServices changePasswordServices = ChangePasswordServices();
  bool showHelperText = false;
  bool min_length_error = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.ashColor,
      resizeToAvoidBottomInset: false,
      drawer: Drawer(
        backgroundColor: MyColors.appBarColor,
        child: SideMenu(
          side_menu_item_no: side_menu_item_no,
        ),
        width: 280,
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: CustomAppBar(
          module_name: 'Change Password',
          emp_name: getEmployeeName(context),
          leading: Icon(Icons.menu_outlined, color: MyColors.actionsButtonColor, size: 20,),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  'Change Passowrd',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: MyColors.appBarColor,
                      fontSize: 14,
                      fontFamily: MyFonts.poppins,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 15),
                PasswordTextField(
                  textFieldColor: MyColors.boneWhite,
                  hintText: 'Current Password',
                  labelText: 'Enter current password',
                  controller: currentPasswordController,
                  helperText: min_length_error ? 'Please enter atleast 8 characters' : null,
                ),
                SizedBox(height: 10),
                PasswordTextField(
                  textFieldColor: MyColors.boneWhite,
                  hintText: 'New Password',
                  labelText: 'Enter new password',
                  controller: newPasswordController,
                  helperText: min_length_error ? 'Please enter atleast 8 characters' : null,
                ),
                SizedBox(height: 10),
                PasswordTextField(
                  textFieldColor: MyColors.boneWhite,
                  hintText: 'Confirm New Password',
                  labelText: 'Confirm New Password',
                  controller: confirmNewPasswordController,
                  helperText: showHelperText ? 'Both passwords should match' : null,
                ),
              ],
            ),
            CustomElevatedButton(
                buttonText: 'Update',
                buttonColor: MyColors.appBarColor,
                buttonTextColor: MyColors.boneWhite,
                height: 50,
                textSize: 15,
                onClick: (){

                  if(currentPasswordController.text.length >= 8 || newPasswordController.text.length >= 8) {
                    if (newPasswordController.text ==
                        confirmNewPasswordController.text) {
                      changePasswordServices.changePassword(
                          context: context,
                          onSuccess: () {
                            Navigator.pushNamed(context, HomeScreen.routeName);
                          },
                          old_password: currentPasswordController.text,
                          new_password: confirmNewPasswordController.text
                      );
                      setState(() {
                        min_length_error = false;
                        showHelperText = false;
                      });
                    } else {
                      setState(() {
                        min_length_error = false;
                        showHelperText = true;
                      });
                    }
                  } else {
                    setState(() {
                      min_length_error = true;
                    });
                  }
                }
            ),
          ],
        ),
      ),
    );
  }
}
