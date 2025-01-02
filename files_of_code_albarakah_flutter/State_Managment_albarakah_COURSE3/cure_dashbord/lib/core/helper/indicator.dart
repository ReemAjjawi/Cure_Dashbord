import 'package:flutter/material.dart';

import '../resources/managers/colors_manager.dart';

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
