import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constant/color.dart';
import 'custom_elevated_button.dart';

void imagePickerModal(BuildContext context,
    {VoidCallback? onCameraTap, VoidCallback? onGalleryTap}) {
  Get.bottomSheet(
    backgroundColor: const Color(0xffEAF8FB),
    Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child:  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Scan Photo',
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
                  SizedBox(
                    width: double.infinity,
                    child: CustomElevatedButton(
                      text: 'Camera',
                      onPressed: () {
                        if (onCameraTap != null) onCameraTap();
                        },
                      icon: Icons.camera_alt_rounded,
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: CustomElevatedButton(
                      text: 'Gallery',
                      onPressed: ()
                      {
                        if (onGalleryTap != null) onGalleryTap();
                        },
                      icon: Icons.photo_library,
                    ),
                  ),
                ],
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
