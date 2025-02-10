import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:fada/core/constant/color.dart';
import 'package:fada/core/constant/imageasset.dart';

import '../../controller/add_file_controller.dart';
import '../widget/custom_app_bar_with_back.dart';
import '../widget/custom_drawer.dart';

class RecognizePage extends StatefulWidget {
  final String? path;
  final List<String> allergyWords;

  const RecognizePage({Key? key, this.path, required this.allergyWords}) : super(key: key);

  @override
  State<RecognizePage> createState() => _RecognizePageState();
}

class _RecognizePageState extends State<RecognizePage> {
  bool _isBusy = false;
  bool _hasAllergyWords = false;
  List<String> _foundAllergyWords = [];
  TextEditingController controller = TextEditingController();
  final AddFileControllerImp addFileController = Get.put(AddFileControllerImp());

  @override
  void initState() {
    super.initState();
    if (widget.path != null) {
      final inputImage = InputImage.fromFilePath(widget.path!);
      processImage(inputImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWithBack(
        title: "Recognized Text",
        icon: Icons.text_fields,
      ),
      drawer:  CustomDrawer(),
      body: _isBusy
          ? Center(
        child: Lottie.asset(
          AppImageAsset.loading,
          width: 250,
          height: 250,
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Display the scanned image (if available)
              if (widget.path != null)
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: FileImage(File(widget.path!)),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),
              // 2. Display the allergy result card
              _buildAllergyStatusCard(),
              const SizedBox(height: 20),
              // 3. Display the recognized text
              Text(
                "Recognized Text",
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(color: AppColor.primaryColor),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(15),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: AppColor.primaryColor, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  controller.text,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a status card that shows whether potential allergens were found.
  Widget _buildAllergyStatusCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: _hasAllergyWords ? Colors.red.shade50 : Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _hasAllergyWords ? Colors.red : Colors.green,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Icon(
            _hasAllergyWords ? Icons.warning_amber_rounded : Icons.check_circle_rounded,
            color: _hasAllergyWords ? Colors.red : Colors.green,
            size: 30,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _hasAllergyWords ? "Allergy Alert!" : "All Clear!",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _hasAllergyWords ? Colors.red : Colors.green,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _hasAllergyWords
                      ? "Found potential allergens: ${_foundAllergyWords.join(', ')}"
                      : "No detected allergens in the scanned text",
                  style: const TextStyle(color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Processes the image using ML Kit to recognize text and checks for allergy words.
  void processImage(InputImage image) async {
    setState(() => _isBusy = true);

    try {
      final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final recognizedText = await textRecognizer.processImage(image);

      _foundAllergyWords = widget.allergyWords.where((word) =>
          recognizedText.text.toLowerCase().contains(word.toLowerCase())).toList();

      setState(() {
        controller.text = recognizedText.text;
        _hasAllergyWords = _foundAllergyWords.isNotEmpty;
        _isBusy = false;
      });

      // Automatically save the recognized text and result
      addFileController.recognized_text.text = recognizedText.text;
      addFileController.result.text = _hasAllergyWords
          ? "Allergy Alert!\nFound potential allergens: ${_foundAllergyWords.join(', ')}"
          : "All Clear!\nNo detected allergens in the scanned text";
      addFileController.filePath = widget.path;
      addFileController.scan_type.text = "1";

      addFileController.addFile();

      textRecognizer.close();
    } catch (e) {
      setState(() => _isBusy = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error processing image: ${e.toString()}")),
      );
    }
  }
}
