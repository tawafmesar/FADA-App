import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constant/color.dart';
import '../../core/constant/imageasset.dart';
import '../../core/localization/changelocal.dart';



class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 4400), () {
      Get.find<LocaleController>().changeLang("en");
      Get.offNamed("/");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundcolor,
      body: Center(
        child: Container(
          child: Image.asset(
            AppImageAsset.splash,
          ),
        ),
      ),
    );
  }
}

