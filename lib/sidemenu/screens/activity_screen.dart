import 'package:flutter/material.dart';

import '../../constants/custom_app_bar.dart';
import '../../constants/my_colors.dart';
import '../../constants/utils.dart';

class ActivitySchemeScreen extends StatefulWidget {
  const ActivitySchemeScreen({super.key});

  @override
  State<ActivitySchemeScreen> createState() => _ActivitySchemeScreenState();
}

class _ActivitySchemeScreenState extends State<ActivitySchemeScreen> {

  String pageName = 'Activity';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: CustomAppBar(
            module_name: pageName,
            emp_name: getEmployeeName(context),
            leading: Icon(Icons.menu_outlined, color: MyColors.actionsButtonColor, size: 20,),
          ),
        )
    );
  }
}
