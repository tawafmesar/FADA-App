import 'dart:developer';
import 'package:fada/core/constant/color.dart';
import 'package:fada/view/Screen/recognization_page.dart';
import 'package:fada/view/widget/custom_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';
import '../../Utils/image_cropper_page.dart';
import '../../Utils/image_picker_class.dart';
import '../../controller/allergydb_controller.dart';
import '../../core/class/statusrequest.dart';
import '../widget/add_allergy_bottom_sheet.dart';
import '../widget/custom_app_bar.dart';
import '../widget/custom_elevated_button.dart';
import '../widget/modal_dialog.dart';

      class ScanScreen extends StatelessWidget {
        const ScanScreen({Key? key}) : super(key: key);

        @override
        Widget build(BuildContext context) {
          final AllergyDBControllerImp controller = Get.put(AllergyDBControllerImp());

          return Scaffold(
            appBar: CustomAppBar(
              title: 'Scan Allergies',
            icon: Icons.camera_alt_rounded,
            actions: [
              IconButton(
                icon: const Icon(Icons.update, color: Colors.white),
                onPressed: () {
                  controller.getallergydb();
                },
              ),
            ],),
            drawer: CustomDrawer(),
            body:
            Column(
                children: [
            Container(
              color: const Color(0xffEAF8FB),
              child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(

                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Detected Allergies',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColor.primaryColor,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  CustomElevatedButton(
                    text: 'Add Allergy to List',
                    icon: Icons.add_circle_outline ,
                    onPressed: () {
                      AddAllergyBottomSheet(context);
                    },
                  ),
                ],
              ),
                        ),
            ),
          Expanded(
          child:
            GetBuilder<AllergyDBControllerImp>(
              builder: (controller) {
                if (controller.statusRequest == StatusRequest.loading) {
                  return ListView.builder(
                    padding:  const  EdgeInsets.only(bottom: 32),
                    itemCount: 20,
                    itemBuilder: (context, index) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey[300],
                            radius: 20,
                          ),
                          title: Container(
                            height: 10,
                            width: double.infinity,
                            color: Colors.grey[300],
                          ),
                          trailing: Container(
                            height: 20,
                            width: 40,
                            color: Colors.grey[300],
                          ),
                        ),
                      );
                    },
                  );
                }

                if (controller.statusRequest == StatusRequest.failure ||
                    controller.uniqueData.isEmpty) {
                  return const Center(child: Text('No Allergies Found'));
                }

                // We have data, show it in a ListView
                return ListView.builder(
                  padding:  const  EdgeInsets.only(bottom: 70),

                  itemCount: controller.uniqueData.length,
                  itemBuilder: (context, index) {
                    final allergy = controller.uniqueData[index];

                    // "allergy" is an instance of allergydb_model
                    String ingredientName = allergy.ingredientName ?? '';
                    String status = allergy.status ?? 'Inactive';
                    bool isActivated = (status == 'Activated');

                    // Pick an icon if we have one
                    IconData iconData = Icons.view_list_outlined; // fallback icon
                    if (allergenIconMap.containsKey(ingredientName)) {
                      iconData = allergenIconMap[ingredientName]!;
                    }

                    return ListTile(
                      leading: Icon(iconData, size: 30, color: Colors.grey[700]),
                      title: Text(ingredientName),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min, // Ensures the row takes minimal space
                        children: [
                          // Conditionally show the delete icon if createdBy is not 'System'
                          if (allergy.createdBy != 'System')
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                // Confirm deletion with the user
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text('Delete Allergy'),
                                    content: Text('Are you sure you want to delete $ingredientName?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(ctx).pop(),
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                          controller.remove(allergy.allergyId.toString());
                                        },
                                        child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),

                          // Add some spacing between the delete icon and the switch
                          SizedBox(width: 8),
                          // This custom gradient switch
                          Container(
                            width: 48,
                            height: 24,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: isActivated
                                  ? const LinearGradient(
                                colors: [
                                  Color(0xFF2c90c4),
                                  Color(0xFF31CCB0),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                                  : LinearGradient(
                                colors: [Colors.grey[400]!, Colors.grey[400]!],
                              ),
                            ),
                            child: Stack(
                              children: [
                                AnimatedPositioned(
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeInOut,
                                  left: isActivated ? 24 : 0,
                                  right: isActivated ? 0 : 24,
                                  child: GestureDetector(
                                    onTap: () {
                                      final newValue = !isActivated;
                                      if (newValue) {
                                        debugPrint('Activating $ingredientName');
                                        controller.active(allergy.allergyId.toString());
                                      } else {
                                        debugPrint('Deactivating $ingredientName');
                                        controller.deactive(allergy.allergyId.toString());
                                      }
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.all(2),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      width: 20,
                                      height: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  );
                },
              );
            },
          )
        )]
          ),
              floatingActionButton: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    stops: [0.4, 0.8],
                    colors: [
                      Color(0xFF2c90c4),
                      Color(0xFF31CCB0),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: FloatingActionButton.extended(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  onPressed: () {
                    imagePickerModal(context, onCameraTap: () {
                      log("Camera");
                      pickImage(source: ImageSource.camera).then((value) {
                        if (value != '') {
                          imageCropperView(value, context).then((value) {
                            if (value != '') {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (_) => RecognizePage(
                                    path: value,
                                    allergyWords: Get.find<AllergyDBControllerImp>().allergyWords,
                                  ),
                                ),
                              );
                            }
                          });
                        }
                      });
                    }, onGalleryTap: () {
                      log("Gallery");
                      pickImage(source: ImageSource.gallery).then((value) {
                        if (value != '') {
                          imageCropperView(value, context).then((value) {
                            if (value != '') {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (_) => RecognizePage(
                                    path: value,
                                    allergyWords: Get.find<AllergyDBControllerImp>().allergyWords,
                                  ),
                                ),
                              );
                            }
                          });
                        }
                      });
                    });
                  },
                  label: Icon(Icons.camera_alt_rounded,color: AppColor.white,),
                ),
              ),

    );
  }
}

Map<String, IconData> allergenIconMap = {
  "Milk": Icons.local_drink,
  "Eggs": Icons.egg,
  "Peanuts": Icons.spa,
  "Tree Nuts": Icons.spa,
  "Fish": Icons.set_meal,
  "Shellfish": Icons.set_meal,
  "Soy": Icons.spa,
  "Wheat": Icons.grain,
  "Sesame": Icons.spa,
  "Mustard": Icons.spa,
  "Sulphites": Icons.spa,
  "Celery": Icons.spa,
  "Lupin": Icons.spa,
  "Gluten": Icons.grain,
  "Palm Oil": Icons.eco,
  "Glutamate": Icons.spa,
};
