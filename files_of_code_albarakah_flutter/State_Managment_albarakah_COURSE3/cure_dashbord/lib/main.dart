import 'package:cure_dashbord/dash_sub.dart/auth/presentation/view.dart';
import 'package:cure_dashbord/dash_sub.dart/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'config/bloc_observe_config.dart';

final box = Hive.box('projectBox');
late final String? token;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();

  await Hive.initFlutter();
  await Hive.openBox('projectBox');

  runApp(const MyApp());
}

late double screenWidth;

late double screenHeight;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.sizeOf(context).width;
    screenHeight = MediaQuery.sizeOf(context).height;

    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: box.get('token') != null ?  HomePage() : const Login(),
    );
  }
}
