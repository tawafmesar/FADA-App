import 'package:flutter/material.dart';
import '../../../controller/auth/successsignup_controller.dart';
import 'package:get/get.dart';

import '../../../core/constant/color.dart';
import '../../widget/auth/custombuttonauth.dart';
import '../../widget/custom_elevated_button.dart';

class SuccessSignUp extends StatelessWidget {
  const SuccessSignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SuccessSignUpControllerImp controller =
    Get.put(SuccessSignUpControllerImp());
    return Scaffold(

      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColor.backgroundcolor,
        elevation: 3.0,
        title: Text(
          'Success Registration',
          style: Theme.of(context)
              .textTheme.headlineMedium!
              .copyWith(color: AppColor.text),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Column(children: [
          const Center(
              child: Icon(
                Icons.check_circle_outline,
                size: 200,
                color: AppColor.primaryColor,
              )),
          Text("Congratulations",
              style: Theme.of(context)
                  .textTheme
                  .displayMedium!
                  .copyWith(fontSize: 30)),
          Text("Account created successfully"),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child:  CustomElevatedButton(text: 'Go to Login',
              onPressed: controller.goToPageLogin,
              icon: Icons.navigate_next,),

          ),
          const SizedBox(height: 30)
        ]),
      ),
    );
  }
}
