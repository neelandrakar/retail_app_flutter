import 'package:flutter/cupertino.dart';
import 'package:retail_app_flutter/models/employee.dart';

class EmployeeProvider extends ChangeNotifier{

  Employee _employee = Employee(
      id: '',
      emp_name: '',
      username: '',
      mobno: 0,
      password: '',
      reporting_to: '',
      profile_id: 0,
      responsible_for: 0,
      state_id: [],
      district_id: [],
      active: 0,
      division: 0,
      work_on: 0,
      jwt_token: '',
      profile_pic: '',
      joining_date: DateTime.now()
  );

  Employee get employee => _employee;

  void setUser(String employee){
    _employee = Employee.fromJson(employee);
    notifyListeners();
  }
}