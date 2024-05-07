import 'package:flutter/material.dart';

import '../../constants/custom_app_bar.dart';
import '../../constants/my_colors.dart';
import '../../constants/utils.dart';

class AccountMap extends StatefulWidget {
  static const String routeName = '/account-map-screen';
  const AccountMap({super.key});

  @override
  State<AccountMap> createState() => _AccountMapState();
}

class _AccountMapState extends State<AccountMap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.boneWhite,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: CustomAppBar(
          module_name: 'Account Map',
          emp_name: getEmployeeName(context),
        ),
      ),
    );
  }
}
