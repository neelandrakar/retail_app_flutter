import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:retail_app_flutter/accounts/screens/create_account_screen.dart';
import 'package:retail_app_flutter/constants/global_variables.dart';

import '../../constants/my_colors.dart';
import '../../constants/my_fonts.dart';

class AccountCreationListDialogue extends StatelessWidget {
  const AccountCreationListDialogue({super.key});

  navigateToCreateAccountScreen(BuildContext context, String accType){
    Navigator.pushNamed(context, CreateAccountScreen.routeName, arguments: accType);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 200,
        height: 350,
        color: MyColors.boneWhite,
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              'Create Account',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                  color: MyColors.blackColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  fontFamily: MyFonts.poppins,
                decoration: TextDecoration.underline
              ),
            ),
            SizedBox(height: 10,),
            Expanded(
              child: ListView.separated(
                  itemCount: account_type.length,
                  itemBuilder: (context, index){

                    String acc_type = account_type[index]['account_type'];
              
                    return GestureDetector(
                      onTap: (){
                        print(acc_type);
                        navigateToCreateAccountScreen(context, acc_type);
                      },
                      child: Container(
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: MyColors.ashColor,
                          borderRadius: BorderRadius.circular(10)
                        ),
                          child: Text(
                            account_type[index]['account_type'].toString(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                color: MyColors.blackColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                fontFamily: MyFonts.poppins),
                          )),
                    );
                  }, separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(height: 10,);
              },
              ),
            )
          ],
        )
      ),
    );
  }
}
