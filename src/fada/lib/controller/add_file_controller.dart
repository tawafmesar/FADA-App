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

abstract class AddFileController extends GetxController {
  addFile();
}

class AddFileControllerImp extends AddFileController {
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
    super.onInit();
  }

  void dispose() {
    recognized_text.dispose();
    result.dispose();
    super.dispose();
  }




  @override
  addFile() async {
    if (filePath == null) {
      Get.defaultDialog(
        title: "Warning",
        middleText: "Please try again and make sure to upload a file",
      );
      return;
    }

    Map<String, String> data = {
      "recognized_text": recognized_text.text ,
      "result": result.text ,
      "user_id": user_id!,
    };

    print("data =======================   $data ");
    print("file =======================   $filePath ");

    statusRequest = StatusRequest.loading;

    try {
      var response = await scanHistoryData.addFile(data, File(filePath!));
      print("=============================== Controller $response ");
      statusRequest = handlingData(response);

      if (statusRequest == StatusRequest.success) {
        print("Response from server: $response");

        if (response['status'] == "success") {

        } else {
          Get.defaultDialog(
            title: "Alert",
            middleText: "The file not uploaded.",
          );
          statusRequest = StatusRequest.failure;
        }
      }
    } catch (e) {
      print("Exception during addFile: $e");
      statusRequest = StatusRequest.serverException;
    } finally {
      update();
    }
  }


  Future<void> _navigateTobackScreen(String title, String middletext) async {
    Get.defaultDialog(
      title: title,
      middleText: middletext,
    );
  }
}