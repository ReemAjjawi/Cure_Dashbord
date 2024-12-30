import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helper/indicator.dart';
import '../../../core/resources/managers/colors_manager.dart';
import '../../home.dart';
import '../model.dart';
import 'bloc/login_bloc.dart';
import 'bloc/login_event.dart';
import 'bloc/login_state.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController name = TextEditingController();
  TextEditingController password = TextEditingController();
  final formKey = GlobalKey<FormState>(); // Define a GlobalKey for the Form

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: Builder(builder: (context) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenHeight * 0.05,
                  vertical: screenHeight * 0.05),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //      crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          "تسجيل الدخول",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 0.02 * screenHeight),
                      Container(
                        height: screenHeight / 4,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/dash.png")),
                        ),
                      ),
                      SizedBox(height: 0.06 * screenHeight),
                      SizedBox(
                        height: 0.06 * screenHeight,
                        child: TextFormField(
                          controller: name,
                          //   textDirection: TextDirection.rtl,
                          cursorColor: ColorsManager.secondaryBColor,
                          decoration: InputDecoration(
                              //  textDirection: TextDirection.rtl,
                              hintTextDirection: TextDirection.rtl,
                              hintText: "اسم المستخدم",
                              hintStyle:
                                  TextStyle(color: ColorsManager.hintColor),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: ColorsManager.BorderColor,
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: ColorsManager.BorderColor,
                                  )),
                              hoverColor: ColorsManager.secondaryBColor),
                        ),
                      ),
                      SizedBox(height: 0.06 * screenHeight),
                      SizedBox(
                        height: 0.06 * screenHeight,
                        child: TextFormField(
                          controller: password,
                          //  textDirection: TextDirection.rtl,
                          cursorColor: ColorsManager.secondaryBColor,
                          decoration: InputDecoration(
                              //  textDirection: TextDirection.rtl,
                              hintTextDirection: TextDirection.rtl,
                              hintText: "كلمة المرور",
                              hintStyle:
                                  TextStyle(color: ColorsManager.hintColor),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: ColorsManager.BorderColor,
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: ColorsManager.BorderColor,
                                  )),
                              hoverColor: ColorsManager.secondaryBColor),
                        ),
                      ),
                      SizedBox(height: 0.23 * screenHeight),
                      BlocConsumer<LoginBloc, LogInClassState>(
                        listener: (context, state) {
                          if (state is LogInSuccessState) {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) {
                              return const HomePage();
                            }));
                          } else if (state is LogInFailureState) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content:
                                    Text("error occured ${state.message}")));
                          }
                        },
                        builder: (context, state) {
                          if (state is InitialStateLogIn) {
                            return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorsManager.secondaryColor,
                                  minimumSize: Size(
                                    0.8 * screenWidth,
                                    0.06 * screenHeight,
                                  ), // Set minimum width and height
                                  // primary: Colors.blue, // Background color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10.0), // Change the radius here
                                  ),
                                ),
                                onPressed: () async {
                                  context.read<LoginBloc>().add(LogInEvent(
                                      user: LogInModelAdmin(
                                          phone_number: name.text,
                                          password: password.text)));
                                },
                                child: Text("تسجيل الدخول",
                                    style: TextStyle(
                                      color: ColorsManager.loginColor,
                                    )));
                          } else if (state is LogInLoadingState) {
                            return const Indicator();
                          } else if (state is LogInSuccessState) {
                            return const SizedBox();
                          } else {
                            return 
                            
                            
                            SizedBox(
                        height: 300,
                        child: Column(
                          children: [
                            ElevatedButton(
                               style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorsManager.secondaryColor,
                                  minimumSize: Size(
                                    0.8 * screenWidth,
                                    0.06 * screenHeight,
                                  ), // Set minimum width and height
                                  // primary: Colors.blue, // Background color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10.0), // Change the radius here
                                  ),
                                ),
                                onPressed: () {
                                  context.read<LoginBloc>().add(LogInEvent(
                                      user: LogInModelAdmin(
                                          phone_number: name.text,
                                          password: password.text)));
                                },
                                child:  Text("تسجيل الدخول",
                                    style: TextStyle(
                                      color: ColorsManager.loginColor,
                                    ))),
                                                    //   Text((state as LogInFailureState).message);

                          ],
                        ),
                      );
                    } 
                            
                            
                          
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}









