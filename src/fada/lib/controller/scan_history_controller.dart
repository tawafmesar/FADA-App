import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../core/class/statusrequest.dart';
import '../core/constant/routes.dart';
import '../core/functions/handingdatacontroller.dart';
import '../core/services/services.dart';
import '../data/datasource/remote/scan_history_data.dart';
import '../data/model/scan_history_model.dart';

abstract class ScanHistoryController extends GetxController {
}

class ScanHistoryControllerImp extends ScanHistoryController {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  late TextEditingController recognized_text;
  late TextEditingController result;
  String? user_id;
  String? filePath;

  MyServices myServices = Get.find();

  late StatusRequest statusRequest = StatusRequest.none;

  ScanHistoryData scanHistoryData = ScanHistoryData(Get.find());
  List<ScanHistoryModel> data = [];

  @override
  void onInit() {
    recognized_text = TextEditingController();
    result = TextEditingController();
    user_id = myServices.sharedPreferences.getString("id");
    getScanHistory();
    super.onInit();
  }

  void dispose() {
    recognized_text.dispose();
    result.dispose();
    super.dispose();
  }



  @override
  getScanHistory() async {
    data.clear();
    statusRequest = StatusRequest.loading;
    update();

    try {
      var response = await scanHistoryData.postdata(user_id!);
      print("=============================== Controller Raw Response: $response ");

      statusRequest = handlingData(response);
      if (statusRequest == StatusRequest.success) {
        if (response['status'] == "success") {
          if (response['data'] is List) {
            data.addAll(response['data'].map<ScanHistoryModel>((e) => ScanHistoryModel.fromJson(e)).toList());
            print("Metrics Data: $data");
          } else {
            print("Data is not a list.");
            statusRequest = StatusRequest.failure;
          }
        } else {
          statusRequest = StatusRequest.failure;
          print("API returned failure status.");
        }
      } else if (statusRequest == StatusRequest.serverfailure) {
        // Handle server failure specifically
        print("Server failure encountered.");
        // Optionally, you can show a snackbar or dialog to inform the user
      } else if (statusRequest == StatusRequest.failure) {
        // Handle other failures
        print("General failure encountered.");
        // Optionally, inform the user
      }
    } catch (e, stacktrace) {
      print("Error in ScanHistory: $e");
      print("Stacktrace: $stacktrace");
      statusRequest = StatusRequest.serverfailure;
    }

    update();
  }

  Future<void> _navigateTobackScreen(String title, String middletext) async {
    Get.defaultDialog(
      title: title,
      middleText: middletext,
    );
  }
}