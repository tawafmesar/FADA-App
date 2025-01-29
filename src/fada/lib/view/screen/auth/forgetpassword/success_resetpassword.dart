import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controller/forgetpassword/successresetpassword_controller.dart';
import '../../../../core/constant/color.dart';
import '../../../widget/auth/custombuttonauth.dart';
import '../../../widget/custom_elevated_button.dart';

class SuccessResetPassword extends StatelessWidget {
  const SuccessResetPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SuccessResetPasswordControllerImp controller =
    Get.put(SuccessResetPasswordControllerImp());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColor.backgroundcolor,
        elevation: 3.0,
        title: Text(
          'Success Reset Password',
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
          Text(
            "Congratulations",
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontSize: 30),
          ),
          Text("Password reset successfully"),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: CustomElevatedButton(text: 'Go to Login',
              onPressed: controller.goToPageLogin,
              icon: Icons.navigate_next,)
          ),
          SizedBox(height: 30)
        ]),
      ),
    );
  }
}
