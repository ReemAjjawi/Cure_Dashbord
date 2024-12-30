import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/resources/managers/colors_manager.dart';
import '../../main.dart';
import '../core/helper/indicator.dart';
import 'codes/presenation/bloc/code_bloc.dart';
import 'codes/presenation/bloc/code_event.dart';
import 'codes/presenation/bloc/code_state.dart';
import 'subjects/presentation/bloc/subjects_bloc.dart';
import 'activation_codes.dart';

class ShowCodes extends StatefulWidget {
  const ShowCodes({super.key});
  @override
  State<ShowCodes> createState() => _ShowCodesState();
}

class _ShowCodesState extends State<ShowCodes> {
  List<bool> selectedItems = List.generate(20, (index) => false);

  bool floatingPressed = false;
  String? selectedValue;
  final List<String> dropdownItems = [' المواد', ' الكتل', ' تحديد الكل'];
  final List<String> dropdownItems2 = ['الكتلة الثانية', ' الكتلة الأولى'];
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CodeBloc(),
        ),
        BlocProvider(
          create: (context) => SubjectsBloc()..add(GetSubjects()),
        ),
      ],
      child: Builder(builder: (context) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                left: screenHeight * 0.02,
                right: screenHeight * 0.02,
                top: screenHeight * 0.04,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            child: const Text(
                              "فرز بحسب",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            onTap: () {
                              showMenu(
                                context: context,
                                position: const RelativeRect.fromLTRB(
                                    75.0, 75.0, 75.0, 75.0),
                                items: dropdownItems.map((String item) {
                                  return PopupMenuItem<String>(
                                    value: item,
                                    child: Column(
                                      children: [
                                        Text(item),
                                        // Add a Divider after each item except the last one
                                        if (item != dropdownItems.last)
                                          const Divider(),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ).then((String? selectedItem) {
                                if (selectedItem != null) {
                                  setState(() {
                                    selectedValue = selectedItem;
                                  });
                                  if (selectedItem == ' الكتل') {
                                    showMenu(
                                      context: context,
                                      position: const RelativeRect.fromLTRB(
                                          75.0, 75.0, 75.0, 75.0),
                                      items: dropdownItems2.map((String item) {
                                        return PopupMenuItem<String>(
                                          value: item,
                                          child: Column(
                                            children: [
                                              Text(item),
                                              // Add a Divider after each item except the last one
                                              if (item != dropdownItems2.last)
                                                const Divider(),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ).then((String? selectedItem) {
                                      if (selectedItem != null) {
                                        setState(() {
                                          selectedValue = selectedItem;
                                        });
                                      }
                                    });
                                  }
                                }
                              });
                            },
                          ),
                          Container(
                            height: screenHeight * 0.07,
                            width: screenWidth * 0.07,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/images/list.png")),
                            ),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          " الأكواد",
                          style: TextStyle(
                              color: ColorsManager.loginColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w900),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 0.02 * screenHeight),
                  BlocConsumer<CodeBloc, CodeState>(
                    listener: (context, state) {
                      if (state is SuccessGenerateCode) {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return ActivationCodes(codes: state.code);
                        }));
                      }
                    },
                    builder: (context, state) {
                      if (state is CodeLoading) {
                        return const Center(
                          child: Indicator(),
                        );
                      } else if (state is FailureCodeState) {
                        return Center(
                          child: Text(state.message),
                        );
                      } else if (state is CodeEmpty) {
                        return const SizedBox();
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                  BlocConsumer<SubjectsBloc, SubjectsState>(
                    listener: (context, state) {
                      // TODO: implement listener
                    },
                    builder: (context, state) {
                      if (state is SubjectsLoading) {
                        return const Indicator();
                      } else if (state is SubjectsList) {
                        return Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 12,

                              crossAxisCount: 2, // 2 items per row
                              childAspectRatio: 1, // Aspect ratio of each item
                            ),
                            itemCount: state.subjects.length,
                            itemBuilder: (context, index) {
                              if (selectedItems.length !=
                                  state.subjects.length) {
                                selectedItems = List.generate(
                                    state.subjects.length, (index) => false);
                              }
                              return Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color(
                                          0xFF749081), // Hex color for the border
                                      width: 0.5, // Border width
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(
                                            0xffcec7a580), // Hex color for the shadow with alpha
                                        offset: Offset(0, 2), // Shadow offset
                                        blurRadius: 3, // Blur radius
                                        spreadRadius: 0, // Spread radius
                                      ),
                                    ],
                                    color: selectedItems[index]
                                        ? const Color(0xFFEBEDEC)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(8)),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 2, vertical: 10),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: screenHeight * 0.02,
                                          vertical: screenHeight * 0.025),
                                      //  padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        (state).subjects[index].name,
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xFF557766)),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Checkbox(
                                        side: const BorderSide(
                                            color: Color.fromARGB(
                                                255, 85, 78, 78)),
                                        focusColor: const Color.fromARGB(
                                            255, 61, 59, 59),

                                        checkColor: const Color(
                                            0xFF767676), // Color of the check sign
                                        activeColor: const Color.fromARGB(
                                            255,
                                            238,
                                            150,
                                            150), //            checkColor: const Color(0xFF767676),
                                        //           activeColor: Colors.white,
                                        value: selectedItems[index],
                                        onChanged: (bool? value) {
                                          setState(() {
                                            selectedItems[index] = value!;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return Text((state as FailureSubjectsState).message);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: floatingPressed
                ? const Color.fromARGB(255, 151, 211, 179)
                : const Color(0xFFC4DDCF),
            onPressed: () {
              setState(() {
                floatingPressed == true
                    ? floatingPressed = false
                    : floatingPressed = true;
              });

              List<int> trueIndices = selectedItems
                  .asMap()
                  .entries
                  .where((entry) =>
                      entry.value) // Filter entries where value is true
                  .map((entry) =>
                      entry.key) // Get the index (key) of those entries
                  .toList(); // Convert to list
              for (int i = 0; i < trueIndices.length; i++) {
                trueIndices[i] = trueIndices[i] + 1;
              }
              context.read<CodeBloc>().add(GenerateCode(
                  numberOfCodes: 100, subjectsNumber: trueIndices));
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(65),
                side: BorderSide(
                    color: floatingPressed
                        ? const Color(0xFF597064)
                        : const Color.fromARGB(255, 255, 255, 255),
                    width: floatingPressed ? 1 : 0)),
            child: Container(
              height: screenHeight * 0.04,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/magic.png")),
              ),
            ),
          ),
        );
      }),
    );
  }
}
