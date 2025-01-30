import 'package:fada/data/datasource/remote/allergydb_data.dart';
import 'package:fada/data/model/allergydb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/class/statusrequest.dart';
import '../core/functions/handingdatacontroller.dart';
import '../core/services/services.dart';

abstract class AllergyDBController extends GetxController {
  getallergydb();
}

class AllergyDBControllerImp extends AllergyDBController {
  MyServices myServices = Get.find();

  String? users_id;

  StatusRequest statusRequest = StatusRequest.none;

  AllergyDBData allergyDBData = AllergyDBData(Get.find());

  List<allergydb_model> data = [];

  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  late TextEditingController title_allergy;
  late TextEditingController allergy_desc;

  @override
  void onInit() {
    users_id = myServices.sharedPreferences.getString("id");
    title_allergy = TextEditingController();
    allergy_desc = TextEditingController();
    getallergydb();
    super.onInit();
  }

  @override
  void dispose() {
    title_allergy.dispose();
    allergy_desc.dispose();
    super.dispose();
  }

  // Getter to compute unique allergy words
  List<String> get allergyWords {
    final Set<String> uniqueNames = {};
    for (var item in data) {
      if (item.status == 'Activated') {
        uniqueNames.add(item.ingredientName ?? '');
        uniqueNames.add(item.derivativeName ?? '');
      }
    }
    uniqueNames.remove('');
    return uniqueNames.toList();
  }

  // Getter to compute unique data
  List<allergydb_model> get uniqueData {
    final uniqueSet = <String>{};
    final uniqueList = <allergydb_model>[];

    for (var item in data) {
      String key = "${item.allergyId}_${item.ingredientName}";
      if (!uniqueSet.contains(key)) {
        uniqueSet.add(key);
        uniqueList.add(item);
      }
    }

    return uniqueList;
  }

  @override
  AddAllergy() async {
    print('title_allergy.............. $title_allergy');
    print('allergy_desc.............. $allergy_desc');

    print('users_id.............. $users_id');

    if (formstate.currentState!.validate()) {
      statusRequest = StatusRequest.loading;
      update();
      try {
        var response = await allergyDBData.adddata(
            title_allergy.text, allergy_desc.text, users_id!);
        print("=============================== Controller $response ");
        statusRequest = handlingData(response);
        if (StatusRequest.success == statusRequest) {
          if (response['status'] == "success") {
            _navigateTobackScreen(
              "Success",
              "The Allergy has been added successfully.",
            );

            title_allergy.clear();
            allergy_desc.clear();

            getallergydb();
          } else {
            _navigateTobackScreen(
              "Notification",
              "Sorry, your Allergy could not be added.",
            );
            statusRequest = StatusRequest.failure;
          }
        }
      } catch (e) {
        print("Error while adding Allergy: $e");
        statusRequest = StatusRequest.serverfailure;
      }

      update();
    } else {
      _navigateTobackScreen(
        "Notification",
        "Sorry, You must Enter Allergy title.",
      );
    }
    update();
  }

  @override
  void getallergydb() async {
    data.clear();
    statusRequest = StatusRequest.loading;
    var response = await allergyDBData.postdata(users_id!);
    print("=============================== Controller $response ");
    statusRequest = handlingData(response);
    if (StatusRequest.success == statusRequest) {
      if (response['status'] == "success") {
        // Add all items to the data list
        data.addAll(response['data']
            .map<allergydb_model>((e) => allergydb_model.fromJson(e))
            .toList());

        // Print the original data
        print("=============================== Original data $data ");

        print("=============================== allergyWords  ${allergyWords} ");

        // Print the unique data
        print("=============================== Unique data ${uniqueData} ");
      } else {
        statusRequest = StatusRequest.failure;
      }
    }
    update();
  }

  @override
  remove(String id) async {
    print("=============================== id $id ");
    statusRequest = StatusRequest.loading;
    var response = await allergyDBData.removedata(id, users_id!);
    print("=============================== Controller $response ");
    statusRequest = handlingData(response);
    if (StatusRequest.success == statusRequest) {
      if (response['status'] == "success") {
        _navigateTobackScreen("Success", "The Item was Deleted successfully");
        getallergydb();
      } else {
        statusRequest = StatusRequest.failure;
      }
    }
    update();
  }

  @override
  active(String id) async {
    print("=============================== id $id ");
    statusRequest = StatusRequest.loading;
    var response = await allergyDBData.activedata(id, users_id!);
    print("=============================== Controller $response ");
    statusRequest = handlingData(response);
    if (StatusRequest.success == statusRequest) {
      if (response['status'] == "success") {
        _navigateTobackScreen("Success", "The Items was Active successfully");
        getallergydb();
      } else {
        statusRequest = StatusRequest.failure;
      }
    }
    update();
  }

  @override
  deactive(String id) async {
    print("=============================== id $id ");
    statusRequest = StatusRequest.loading;
    var response = await allergyDBData.deactivedata(id, users_id!);
    print("=============================== Controller $response ");
    statusRequest = handlingData(response);
    if (StatusRequest.success == statusRequest) {
      if (response['status'] == "success") {
        _navigateTobackScreen("Success", "The Items was Deactive successfully");
        getallergydb();
      } else {
        statusRequest = StatusRequest.failure;
      }
    }
    update();
  }

  Future<void> _navigateTobackScreen(String title, String middletext) async {
    Get.defaultDialog(
      title: title,
      middleText: middletext,
    );

    await Future.delayed(Duration(seconds: 2));

    Get.back();
    Get.back();
  }
}
