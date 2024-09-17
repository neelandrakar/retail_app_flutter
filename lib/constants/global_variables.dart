import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:retail_app_flutter/models/pending_data_model.dart';
import '../models/loyalty_points_model.dart';
import '../models/submitted_visit_model.dart';
import '../providers/ssml_loyalty_provider.dart';

String uri = 'http://192.168.90.6:3000';
String _uri = 'http://152.6.179.9:3000';
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

LoyaltyPointsModel loyaltyPointsModel = LoyaltyPointsModel(
    total_sale: 0,
    total_points: 0,
    total_pending: 0,
    invoice_wise_points: [],
    loyalty_tiers: []
);
bool isSchemeFullyLoaded = false;
bool isGiftCategoriesFullyLoaded = false;
double horizonal_padding = 15;
String gift_redemption_header_text = "NA";
String gift_redemption_msg = "NA";




