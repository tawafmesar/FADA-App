import 'package:fada/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get/get.dart';
import 'bindings/intialbindings.dart';
import 'core/constant/routes.dart';
import 'core/localization/changelocal.dart';
import 'core/localization/translation.dart';
import 'core/services/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialServices();
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    LocaleController controller = Get.put(LocaleController());

    return GetMaterialApp(
      title: 'Food Allergy Detection & Analysis Application - FADA',
      translations: MyTranslation(),
      debugShowCheckedModeBanner: false,
      locale: controller.language,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialBinding: initialBindings(),
      initialRoute: AppRoute.splash,
      getPages: routes,
      builder: (context, child) {
        return PopScope(
          canPop: false, // Disable back navigation globally
          onPopInvoked: (bool canPop) {
            // Optional: Add any action you want when a pop is attempted
            // For example, show a toast or log the event
            print("Back navigation attempted but disabled.");
          },
          child: child!,
        );
      },
    );
  }
}
