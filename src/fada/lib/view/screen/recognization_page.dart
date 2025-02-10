import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:fada/core/constant/color.dart';

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

  @override
  void initState() {
    super.initState();
    final inputImage = InputImage.fromFilePath(widget.path!);
    processImage(inputImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWithBack(
        title: "Recognized Text",
        icon: Icons.text_fields,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => processImage(InputImage.fromFilePath(widget.path!)),
          ),
        ],
      ),
      drawer: CustomDrawer(),
      body: _isBusy
          ? const Center(child: CircularProgressIndicator(color: AppColor.primaryColor))
          : Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              maxLines: null,
              controller: controller,
              style: Theme.of(context).textTheme.bodyLarge,
              decoration: InputDecoration(
                labelText: "Recognized Text",
                hintText: "Text will appear here...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: AppColor.primaryColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: AppColor.primaryColor, width: 2),
                ),
                contentPadding: const EdgeInsets.all(20),
              ),
            ),
            const SizedBox(height: 20),
            _buildAllergyStatusCard(),
          ],
        ),
      ),
    );
  }

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
                if (_hasAllergyWords)
                  Text(
                    "Found potential allergens: ${_foundAllergyWords.join(', ')}",
                    style: const TextStyle(color: Colors.black87),
                  )
                else
                  const Text(
                    "No detected allergens in the scanned text",
                    style: TextStyle(color: Colors.black87),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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

      textRecognizer.close();
    } catch (e) {
      setState(() => _isBusy = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error processing image: ${e.toString()}")),
      );
    }
  }
}