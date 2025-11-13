import 'package:check_around_me/core/widget/text_holder.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'appbar.dart';
import 'button.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppbar(showBackButton: false,),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Image.asset("assets/images/success.png",height: 300,width: 300,),
                  Gap(20),
                  TextHolder(title: "Congrats! Verification Successful",size: 32,fontWeight: FontWeight.w600,align: TextAlign.center,),
                  TextHolder(title: "Your profile is almost ready. Now, let’s get you started with good deals.",size: 16,fontWeight: FontWeight.w400,align: TextAlign.center,),
                ],
              ),
              Column(
                children: [
                  CustomButton(title: "Set Up Account",onTap: (){
                    // router.push(LoginScreen());
                  },),
                ],
              )
            ],
          ),
        ),
      )
    );
  }
}
