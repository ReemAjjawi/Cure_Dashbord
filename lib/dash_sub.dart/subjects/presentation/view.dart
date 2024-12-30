import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helper/indicator.dart';
import '../../../../core/resources/managers/colors_manager.dart';

import '../../../../main.dart';
import '../../home.dart';
import '../../lectures/presentation/view.dart';
import 'bloc/subjects_bloc.dart';

class ShowSubjects extends StatefulWidget {
  const ShowSubjects({super.key});

  @override
  State<ShowSubjects> createState() => _ShowSubjectsState();
}

class _ShowSubjectsState extends State<ShowSubjects> {
  TextEditingController nameOfSubject = TextEditingController();
  bool isFirstChecked = false;
  bool isSecondChecked = false;

  void _onFirstCheckboxChanged(bool? value) {
    setState(() {
      isFirstChecked = value ?? false;
      isSecondChecked =
          !isFirstChecked; // Set opposite value for second checkbox
    });
  }

  TextEditingController subjectName = TextEditingController();

  void _onSecondCheckboxChanged(bool? value) {
    setState(() {
      isSecondChecked = value ?? false;
      isFirstChecked =
          !isSecondChecked; // Set opposite value for first checkbox
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SubjectsBloc()..add(GetSubjects()),
      child: Builder(builder: (context) {
        return Scaffold(
          //  backgroundColor: const Color(0xFFFBFAF5),
          body: SafeArea(
            child: BlocConsumer<SubjectsBloc, SubjectsState>(
              listener: (context, state) {
                if (state is FailureSubjectsState) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("error occured ${state.message}")));
                }
              },
              builder: (context, state) {
                if (state is SubjectsLoading) {
                  return const Center(child: Indicator());
                } else if (state is FailureSubjectsState) {
                  return Text((state).message);
                } else if (state is SubjectsList) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: screenHeight * 0.02,
                      right: screenHeight * 0.02,
                      top: screenHeight * 0.04,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                "المقررات",
                                style: TextStyle(
                                    color: ColorsManager.loginColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            //  Icon(Icons.menu)
                          ],
                        ),
                        SizedBox(height: 0.02 * screenHeight),
                        Expanded(
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return ShowLectures(
                                        subjectId: index + 1,
                                        subjectName:
                                            (state).subjects[index].name);
                                  }));
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Container(
                                    height: screenHeight / 9,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(9),
                                      border: Border.all(
                                          color: const Color(0xFF749081),
                                          width: 0.5),
                                    ),
                                    child: ListTile(
                                      trailing: Container(
                                        width: screenWidth * 0.09,
                                        height: screenHeight * 0.08,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/images/books.png")),
                                        ),
                                      ),
                                      title: Text(
                                        (state).subjects[index].name,
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            color: ColorsManager.primaryColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                          ' ${state.subjects[index].countOfLectures} عدد المحاضرات',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              color: ColorsManager.grayColor)),
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: (state).subjects.length,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(28.0),
                              child: Text(
                                "المقررات",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Icon(Icons.menu)
                          ],
                        ),
                        SizedBox(height: 0.02 * screenHeight),
                        Container(
                          height: screenHeight / 2.8,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/images/image.png")),
                          ),
                        ),
                        SizedBox(height: 0.10 * screenHeight),
                        Text(
                          'لا يوجد مقررات بعد , اضغط  "+"  لإضافة مقرر',
                          style: TextStyle(color: ColorsManager.blackColor),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: ColorsManager.priaryBColor,
            onPressed: () async {
              final shouldRefresh = await showDialog<bool>(
                context: context,
                builder: (_) {
                  bool localIsFirstChecked = isFirstChecked;
                  bool localIsSecondChecked = isSecondChecked;

                  return Dialog(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    insetPadding:
                        const EdgeInsets.all(12), // Removes default padding
                    child: StatefulBuilder(
                      builder: (_, StateSetter setState) {
                        return SizedBox(
                          width: MediaQuery.of(context)
                              .size
                              .width, // Full width of the screen
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.07,
                                    vertical:
                                        MediaQuery.of(context).size.height *
                                            0.04,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: Text(
                                          "إضافة مقرر",
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: ColorsManager.primaryColor,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: screenWidth * 0.09,
                                        height: screenHeight * 0.08,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/images/subject.png")),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.7,
                                      bottom: 6,
                                    ),
                                    child: Text(
                                      "اسم المقرر",
                                      style: TextStyle(
                                          color: ColorsManager.loginColor),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  height:
                                      MediaQuery.of(context).size.height * 0.07,
                                  child: TextFormField(
                                    controller: subjectName,
                                    //    textAlign: TextAlign.center,
                                    textDirection: TextDirection.rtl,
                                    cursorColor: ColorsManager.secondaryBColor,
                                    decoration: InputDecoration(
                                      hintTextDirection: TextDirection.rtl,
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: ColorsManager.loginColor,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: ColorsManager.BorderColor,
                                        ),
                                      ),
                                      hoverColor: ColorsManager.secondaryBColor,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical:
                                        MediaQuery.of(context).size.height *
                                            0.05,
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.04,
                                  ),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.15,
                                        ),
                                        child: Row(
                                          children: [
                                            const Text("الكتلة الثانية"),
                                            Checkbox(
                                              side: const BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 85, 78, 78)),
                                              activeColor: ColorsManager
                                                  .loginColor, // Ba
                                              value: localIsSecondChecked,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  localIsSecondChecked =
                                                      value ?? false;
                                                  localIsFirstChecked =
                                                      !localIsSecondChecked;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Spacer(),
                                      Row(
                                        children: [
                                          const Text("الكتلة الأولى"),
                                          Checkbox(
                                            side: const BorderSide(
                                                color: Color.fromARGB(
                                                    255, 85, 78, 78)),
                                            activeColor:
                                                ColorsManager.loginColor,
                                            value: localIsFirstChecked,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                localIsFirstChecked =
                                                    value ?? false;
                                                localIsSecondChecked =
                                                    !localIsFirstChecked;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context).size.height *
                                        0.05,
                                  ),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          ColorsManager.priaryBColor,
                                      minimumSize: Size(
                                        MediaQuery.of(context).size.width *
                                            0.85,
                                        MediaQuery.of(context).size.height *
                                            0.06,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context, true);
                                      context.read<SubjectsBloc>().add(
                                          AddSubject(
                                              name: subjectName.text,
                                              type:
                                                  localIsFirstChecked ? 1 : 2));
                                      subjectName.clear();

                                      // setState(() {
                                      //   localIsFirstChecked = false;
                                      //   localIsSecondChecked =a
                                      //       false; // Reset to initial value
                                      // });
                                    },
                                    child: Text(
                                      "التالي",
                                      style: TextStyle(
                                        color: ColorsManager.loginColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
              if (shouldRefresh == true) {
                setState(() {
                  context.read<SubjectsBloc>().add(GetSubjects());
                });
              }
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
            child: Icon(
              Icons.add,
              color: ColorsManager.loginColor,
              size: 38,
            ),
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    subjectName.dispose();
    super.dispose();
  }
}
