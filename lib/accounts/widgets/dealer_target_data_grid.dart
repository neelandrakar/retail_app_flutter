import 'package:retail_app_flutter/accounts/screens/target_vs_achievement_screen.dart';
import 'package:retail_app_flutter/models/dealer_target_model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:flutter/material.dart';

import '../../constants/my_colors.dart';
import '../../constants/my_fonts.dart';

class DealerTargetDataSource extends DataGridSource {

  bool enableEditing = false;
  void enableEditingMode(){
    if(enableEditing){
      enableEditing = false;
    } else {
      enableEditing = true;
    }
    print(enableEditing);

  }

  /// Creates the employee data source class with required details.
  DealerTargetDataSource({required List<DealerTargetModel> dealerTargets}) {
    _targetData = dealerTargets
        .map<DataGridRow>((e) {

      String initialStatus = "NA";
      String currentStatus = "NA";
      if(e.initial_status=='Active SSIL'){
        initialStatus = 'A';
      } else if(e.initial_status=='Inactive'){
        initialStatus = 'I';
      } else if(e.initial_status=='Prospective'){
        initialStatus = 'P';
      } else if(e.initial_status=='Survey'){
        initialStatus = 'S';
      }
      if(e.account_status=='Active SSIL'){
        currentStatus = 'A';
      } else if(e.account_status=='Inactive'){
        currentStatus = 'I';
      } else if(e.account_status=='Prospective'){
        currentStatus = 'P';
      } else if(e.account_status=='Survey'){
        currentStatus = 'S';
      }

        return DataGridRow(cells: [
      DataGridCell<String>(columnName: 'dealer_name', value: e.dealer_name),
      DataGridCell<String>(columnName: 'current_status', value: currentStatus),
      DataGridCell<String>(columnName: 'initial_status', value: initialStatus),
      DataGridCell<int>(columnName: 'primary_target', value: e.primary_target),
      DataGridCell<int>(columnName: 'cm_achievement', value: e.cm_achievement),
      DataGridCell<int>(columnName: 'lm_achievement', value: e.lm_achievement),
    ]);
   }).toList();
  }


  List<DataGridRow> _targetData = [];

  @override
  List<DataGridRow> get rows => _targetData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {

    /// Helps to control the editable text in the [TextField] widget.
    TextEditingController editingController = TextEditingController();
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
          bool is_editing_mode = false;
          if(e.columnName=='primary_target'){
            is_editing_mode = is_editing_mode;
          }

          Color getColor() {
            if (e.value == 'P') {
              if (e.value == 'P') {
                return Colors.tealAccent;
              } else if (e.value == 'P') {
                return Colors.blue[200]!;
              }
            }

            return Colors.transparent;
          }

          return GestureDetector(
            onTap: (){
              print(e.value.toString());
              is_editing_mode = true;
            },
            child: Container(
              // color: getColor(),
              alignment: Alignment.center,
              // padding: EdgeInsets.all(8),
              child: is_editing_mode==false ? Text(e.value.toString(),
                  style: TextStyle(
                      color: MyColors.appBarColor,
                      fontFamily: MyFonts.poppins,
                      fontSize: 12,
                      fontWeight: FontWeight.w500
                  )) : TextField(
                      autofocus: false,
                      controller: editingController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: MyColors.ashColor,
                        hintText: e.value.toString(),
                        contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      ),
                      keyboardType: TextInputType.number,

                      onSubmitted: (String value) {
                        print(value);
                      },
                    ),
            ),
          );
        }).toList());
  }
}