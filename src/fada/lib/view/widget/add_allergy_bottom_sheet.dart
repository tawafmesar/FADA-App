import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/allergydb_controller.dart';
import '../../core/constant/color.dart';
import '../widget/auth/customtextformauth.dart';
import 'custom_elevated_button.dart';

void AddAllergyBottomSheet(BuildContext context) {
  Get.bottomSheet(
    backgroundColor: const Color(0xffEAF8FB),
    Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: GetBuilder<AllergyDBControllerImp>(
        builder: (controller) => SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: Form(
              key: controller.formstate,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Add Allergy',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColor.primaryColor,
                          shadows: [
                            Shadow(
                              blurRadius: 5.0,
                              color: Colors.black26,
                              offset: Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(height: 2, color: AppColor.primaryColor),
                  const SizedBox(height: 10),

                  const Text(
                    "Enter Allergy Information",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: AppColor.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 20),

                  CustonTextFormAuth(
                    isNumber: false,
                    valid: (val) => val != null && val.isNotEmpty
                        ? null
                        : "Title allergy is required",
                    mycontroller: controller.title_allergy,
                    hinttext: "Enter allergy title",
                    iconData: Icons.local_hospital,
                    labeltext: "Allergy Title",
                  ),
                  const SizedBox(height: 10),
                  CustonTextFormAuth(
                    isNumber: false,
                    valid: (val) => null, // Description is optional
                    mycontroller: controller.allergy_desc,
                    hinttext: "Enter allergy description (optional)",
                    iconData: Icons.description,
                    labeltext: "Description",
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: CustomElevatedButton(
                      radius: 25.0,
                      text: "Add Allergy",
                      icon: Icons.local_hospital,
                      onPressed: () {
                        if (controller.title_allergy.text.isEmpty) {
                          Get.snackbar(
                            "Error",
                            "You must provide an allergy title.",
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.BOTTOM,
                            margin: const EdgeInsets.all(10),
                            duration: const Duration(seconds: 3),
                          );
                        } else {
                          controller.AddAllergy();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
    isScrollControlled: true,
    elevation: 10,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(42),
        topRight: Radius.circular(42),
      ),
    ),
  );
}
