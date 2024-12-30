import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helper/indicator.dart';
import '../../../../main.dart';
import '../../../core/resources/managers/colors_manager.dart';
import '../../subjects/presentation/bloc/subjects_bloc.dart';
import '../../subjects/subject_post_model.dart';
import 'statistics_bloc.dart';
import 'statistics_event.dart';
import 'statistics_state.dart';

class ShowStatistics extends StatefulWidget {
  const ShowStatistics({super.key});

  @override
  State<ShowStatistics> createState() => _ShowStatisticsState();
}

class _ShowStatisticsState extends State<ShowStatistics> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => StatisticsBloc()..add(GetNumberOfUserEvent()),
        ),
        BlocProvider(create: (context) => SubjectsBloc()..add(GetSubjects())),
      ],
      child: Builder(builder: (context) {
        return Scaffold(
          //  backgroundColor: const Color(0xFFFBFAF5),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                left: screenHeight * 0.03,
                right: screenHeight * 0.03,
                top: screenHeight * 0.04,
              ),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        " الاحصائيات",
                        style: TextStyle(
                            color: Color(0xFF43584D),
                            fontSize: 16,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                  BlocConsumer<SubjectsBloc, SubjectsState>(
                    listener: (context, firstState) {
                      // TODO: implement listener
                    },
                    builder: (context, firstState) {
                      return BlocConsumer<StatisticsBloc, StatisticsState>(
                        listener: (context, secondstate) {
                          if (secondstate is FailureStatisticsState) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    "error occured //${secondstate.message}")));
                          }
                        },
                        builder: (context, secondstate) {
                          if (firstState is SubjectsLoading ||
                              secondstate is StatisticsLoading) {
                            return const Center(child: Indicator());
                          } else if (secondstate is SuccessGetNumberOfUser &&
                              firstState is SubjectsList) {
                            return Expanded(
                              child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  //   mainAxisSpacing: 10.4,
                                  crossAxisSpacing: 12,
                                  crossAxisCount: 2, // 2 items per row
                                  childAspectRatio:
                                      1, // Aspect ratio of each item
                                ),
                                itemCount: firstState.subjects.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: const Color(
                                              0xFF43584D), // Hex color for the border
                                          width: 0.5, // Border width
                                        ),
                                        borderRadius: BorderRadius.circular(8)),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 2, vertical: 10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          firstState.subjects[index].name,
                                          style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xFF4C6E5D)),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 13.0),
                                              child: Text(
                                                (secondstate).num.isEmpty
                                                    ? "0"
                                                    : (secondstate)
                                                        .num[index]
                                                        .userCount
                                                        .toString(),
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFF46584F)),
                                              ),
                                            ),
                                            Container(
                                              width: screenWidth * 0.09,
                                              height: screenHeight * 0.08,
                                              decoration: const BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        "assets/images/person.png")),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          } else {
                            return Text(
                                (firstState as FailureStatisticsState).message);
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
