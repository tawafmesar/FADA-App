import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';

import '../../core/constant/imageasset.dart';
import '../../core/constant/color.dart';
import '../widget/custom_app_bar_with_back.dart';
import '../widget/custom_drawer.dart';
import '../../controller/add_file_controller.dart';

class AIScannerScreen extends StatefulWidget {

  final String? imagePath;
  final bool autoCall;
  final List<String> allergyWords;

  const AIScannerScreen({
    Key? key,
    this.imagePath,
    this.autoCall = false,
    required this.allergyWords,
  }) : super(key: key);

  @override
  State<AIScannerScreen> createState() => _ImageChatState();
}

class _ImageChatState extends State<AIScannerScreen> {
  PlatformFile? pickedImage;
  Uint8List? imageBytes;
  String mytext = '';
  bool scanning = false;

  /// Variables for storing found allergy words
  List<String> _foundAllergyWords = [];
  bool _hasAllergyWords = false;

  TextEditingController prompt = TextEditingController();

  final apiUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro:generateContent?key=${dotenv.env['GEMINI_API_KEY']}";

  final header = {
    'Content-Type': 'application/json',
  };

  final AddFileControllerImp addFileController =
  Get.put(AddFileControllerImp());

  @override
  void initState() {
    super.initState();
    // If an imagePath is provided and autoCall is true, load the image and call getdata()
    if (widget.autoCall && widget.imagePath != null) {
      if (!kIsWeb) {
        File file = File(widget.imagePath!);
        setState(() {
          imageBytes = file.readAsBytesSync();
          prompt.text = "Identify food ingredients from image";
        });
        // Automatically call the API after loading the image
        getdata();
      } else {
        // For web, adjust how you load image bytes if needed.
      }
    }
  }

  /// (Optional) Function for manually picking an image.
  Future<void> getImage() async {
    FilePickerResult? result =
    await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      setState(() {
        pickedImage = result.files.first;
      });

      if (kIsWeb) {
        setState(() {
          imageBytes = pickedImage!.bytes;
        });
      } else if (pickedImage!.path != null) {
        File file = File(pickedImage!.path!);
        setState(() {
          imageBytes = file.readAsBytesSync();
        });
      }
    }
  }

  /// Calls the AI API and then checks for allergy words in the returned text.
  Future<void> getdata() async {
    if (imageBytes == null) {
      setState(() {
        mytext = "No image selected.";
      });
      return;
    }

    setState(() {
      scanning = true;
      mytext = '';
    });

    try {
      String base64File = base64.encode(imageBytes!);

      final data = {
        "contents": [
          {
            "parts": [
              {"text": prompt.text},
              {
                "inlineData": {
                  "mimeType": "image/jpeg",
                  "data": base64File,
                }
              }
            ]
          }
        ],
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: header,
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        var resultJson = jsonDecode(response.body);
        String resultText = resultJson['candidates'][0]['content']['parts'][0]['text']
            .replaceAll('**', '');
        setState(() {
          mytext = resultText;
        });

        // Check for allergy words in the AI result text
        _foundAllergyWords = widget.allergyWords.where((word) =>
            resultText.toLowerCase().contains(word.toLowerCase())).toList();
        _hasAllergyWords = _foundAllergyWords.isNotEmpty;

        // Automatically save the AI result and allergy status
        addFileController.recognized_text.text = resultText;
        addFileController.result.text = _hasAllergyWords
            ? "Allergy Alert!\nFound potential allergens: ${_foundAllergyWords.join(', ')}"
            : "All Clear!\nNo detected allergens in the AI ingredient result";
        addFileController.filePath = widget.imagePath;
        addFileController.scan_type.text = "2";

        addFileController.addFile();
      } else {
        setState(() {
          mytext = 'Response status: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        mytext = 'Error occurred: ${e.toString()}';
      });
    } finally {
      setState(() {
        scanning = false;
      });
    }
  }

  /// Builds a card widget displaying the allergy status.
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
                      : "No detected allergens in the AI ingredient result",
                  style: const TextStyle(color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWithBack(
        title: "AI Ingredient Scanner",
        icon: Icons.smart_toy,
      ),
      drawer:  CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: scanning
            ? Center(
          child: Lottie.asset(
            AppImageAsset.loading,
            width: 250,
            height: 250,
          ),
        )
            : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Display the selected image (from file or memory)
              if (widget.imagePath != null)
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: FileImage(File(widget.imagePath!)),
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
                )
              else if (imageBytes != null)
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: MemoryImage(imageBytes!),
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
                )
              else
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xffF0F0F0),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Center(
                    child: Text(
                      'No Image Selected',
                      style: TextStyle(fontSize: 22, color: Colors.black),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              // 2. Display the allergy result card
              _buildAllergyStatusCard(),
              const SizedBox(height: 20),
              // 3. Display the AI ingredient result text
              Text(
                "AI Ingredient Result",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: AppColor.primaryColor),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(15),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                      color: AppColor.primaryColor, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: mytext == "Response status: 503"
                    ? Row(
                  children: [
                   const  Icon(Icons.error_outline, color: Colors.red, size: 30), // Error icon
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Sorry, try another one!",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade900, // Dark red for emphasis
                        ),
                      ),
                    ),
                  ],
                )
                    : Text(
                  mytext,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
