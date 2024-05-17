import 'package:camera/camera.dart';
import 'package:retail_app_flutter/models/pending_data_model.dart';

import '../models/submitted_visit_model.dart';

String uri = 'http://192.168.88.6:3000';
String appVersion = 'NA';
double currentLatitude = 0.0;
double currentLongitude = 0.0;
XFile? imageXFile;
List<String> account_status = [
  'Active SSIL',
  'Inactive',
  'Prospective',
  'Survey',
];

List<String> demo_distributors = [
  'Ramesh Retail',
  'Udai Shetty',
  'Neelandra Kar',
  'Damon Salvatore',
];

Map discussionData= {};
Map actionPlanData= {};



List<Map<String, dynamic>> account_type = [
  {
    'account_type_id': 1,
    'account_type': 'Dealer'
  },
  {
    'account_type_id': 2,
    'account_type': 'Sub Dealer'
  },
  {
    'account_type_id': 4,
    'account_type': 'Mason'
  },
  {
    'account_type_id': 6,
    'account_type': 'Engineer'
  },
  {
    'account_type_id': 7,
    'account_type': 'Distributor'
  },
  {
    'account_type_id': 10,
    'account_type': 'IHB Owner'
  },
];

enum VisitLocationType { Home, Office, Site }
VisitLocationType visitLocationType = VisitLocationType.Home;

enum QuestionAnswerType { Yes, No }
QuestionAnswerType questionAnswerType= QuestionAnswerType.No;

bool discussion_submitted = false;
bool action_plan_submitted = false;

List<SubmittedVisitModel> storedVisits = [];
PendingDataModel allPendingData = PendingDataModel(stored_visits: storedVisits);

