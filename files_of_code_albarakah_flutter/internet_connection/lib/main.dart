import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection/connection_status/bloc_network_.dart';
import 'package:internet_connection/view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(

  create: (context) => InternetBloc(),


      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
        // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home:HomePage() ,
      ),
    );
  }
}
