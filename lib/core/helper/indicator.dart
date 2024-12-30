import 'package:cure/core/resources/managers/colors_manager.dart';
import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  const Indicator({super.key});

  @override
  Widget build(BuildContext context) {
    return  CircularProgressIndicator.adaptive(
       valueColor: AlwaysStoppedAnimation<Color>(ColorsManager.loginColor),
      backgroundColor: Colors.grey,
    );
  }
}
