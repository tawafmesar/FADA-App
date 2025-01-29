import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constant/color.dart';

Future<bool> alertExitApp() {
  Get.defaultDialog(
    title: "Alert",
    titleStyle: const TextStyle(
        color: AppColor.primaryColor, fontWeight: FontWeight.bold),
    middleText: "Do you want to exit the app?",
    actions: [
      ElevatedButton(
        style: ButtonStyle(
          backgroundColor:
          MaterialStateProperty.all(AppColor.primaryColor),
        ),
        onPressed: () {
          exit(0);
        },
        child: const Text("Confirm",style: TextStyle(
          color: AppColor.white,)),
      ),
      ElevatedButton(
        style: ButtonStyle(
          backgroundColor:
          MaterialStateProperty.all(AppColor.primaryColor),
        ),
        onPressed: () {
          Get.back();
        },
        child: const Text("Cancel" ,style: TextStyle(
            color: AppColor.white,),),
      )
    ],
  );
  return Future.value(true);
}
