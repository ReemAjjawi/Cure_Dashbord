// import 'package:cure/core/helper/indicator.dart';
// import 'package:cure/dash_sub.dart/home.dart';
// import 'package:cure/main.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:just_audio/just_audio.dart';
// import '../../../core/resources/managers/colors_manager.dart';
// import '../bloc/lec_bloc.dart';
// import '../bloc/lec_event.dart';
// import '../bloc/lec_state.dart';
// import '../pdf/presentation/bloc/pdf_event.dart';
// import '../pdf/presentation/bloc/pdf_state.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import '../pdf/presentation/bloc/pdf_bloc.dart';

// class PdfAudioPage extends StatefulWidget {
//   PdfAudioPage(
//       {super.key,
//       required this.lectureName,
//       required this.subjectName,
//       required this.index});
//   int index;
//   String lectureName;
//   String subjectName;
//   @override
//   State<PdfAudioPage> createState() => _PdfAudioPageState();
// }

// class _PdfAudioPageState extends State<PdfAudioPage> {
//   Duration duration = Duration.zero;
//   late bool noPdf = true;
//   Duration position = Duration.zero;
//   AudioPlayer player = AudioPlayer();
//   double currentSpeed = 1.0;
//   void handlePlayPause() {
//     print("object");
//     if (player.playing) {
//       player.pause();
//     } else {
//       player.play();
//     }
//   }

//   void handleSeek(double value) {
//     player.seek(Duration(seconds: value.toInt()));
//   }

//   void changeSpeed(double speed) {
//     setState(() {
//       currentSpeed = speed;
//     });
//     player.setSpeed(speed);
//   }

//   void _seturl() {}
//   @override
//   void initState() {
//     super.initState(); // Don't forget to call super.initState()
//     _seturl();
//     _setAudioSource(); // Call the method to set audio source

//     player.positionStream.listen((p) {
//       setState(() => position = p);
//     });

//     player.durationStream.listen((d) {
//       setState(() => duration = d ?? Duration.zero); // Handle null duration
//     });

//     player.playerStateStream.listen((state) {
//       if (state.processingState == ProcessingState.completed) {
//         setState(() {
//           position = Duration.zero;
//         });
//         player.pause();
//         player.seek(position);
//       }
//     });
//   }

//   Future<void> _setAudioSource() async {
//     try {
//       print("llllllll");
//       var box = Hive.box('projectBox');
//       await player.setUrl(
//           "http://199.192.19.220:8000/api/v1/lectures/audio-lectures/download/${widget.index}",
//           headers: {"Authorization": "Bearer ${box.get('token')}"});

//       // player.positionStream.listen((p) {
//       //   setState(() => position = p);
//       // });
//       // player.durationStream.listen((d) {
//       //   setState(() => duration = d ?? Duration.zero); // Handle null duration
//       // });
//     } catch (e) {
//       print("Error setting audio source: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     screenWidth = MediaQuery.sizeOf(context).width;
//     screenHeight = MediaQuery.sizeOf(context).height;

//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(
//           create: (context) => LectureInformationBloc()
//             ..add(GetInfoLecture(lectureId: widget.index)),

//           //   BlocProvider(create: (context) => AudioBloc()..add(GetAudio())),
//         ),
//         BlocProvider(
//           create: (context) => PdfBloc(),
//         ),
//       ],
//       child: Builder(builder: (context) {
//         return Scaffold(
//           body:
//               BlocConsumer<LectureInformationBloc, GetInformationLectureState>(
//             listener: (context, state) {
//               if (state is SuccessGet) {
//                 if (state.xx.pdfLectureId == null &&
//                     state.xx.pdfLectureDownloadLink == null &&
//                     state.xx.audioLectureDownloadLink == null &&
//                     state.xx.audioLectureId == null) {
//                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//                       duration: Duration(seconds: 3),
//                       content: Text("لا يوجد تسجيل صوتي لهذه المحاضرة بعد")));
//                   Navigator.pushReplacement(context,
//                       MaterialPageRoute(builder: (context) {
//                     return const HomePage();
//                   }));
//                 }
//                 if (state.xx.pdfLectureId != null) {
//                   context
//                       .read<PdfBloc>()
//                       .add(GetPdf(index: state.xx.pdfLectureId));
//                   setState(() {
//                     noPdf = false;
//                   });
//                 } else {
//                   setState(() => noPdf = true);
//                 }
//               }
//             },
//             builder: (context, state) {
//               if (state is SuccessGet) {
//                 return SafeArea(
//                   child: noPdf == false
//                       ? BlocConsumer<PdfBloc, PdfState>(
//                           listener: (context, state) {
//                             if (state is FailurePdfState) {
//                               ScaffoldMessenger.of(context)
//                                   .showSnackBar(SnackBar(
//                                 content: Text(state.message),
//                                 duration: const Duration(seconds: 5),
//                               ));
//                             }
//                           },
//                           builder: (context, state) {
//                             if (state is showpdf) {
//                               return Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Column(
//                                   children: [
//                                     Row(
//                                       mainAxisAlignment: MainAxisAlignment.end,
//                                       children: [
//                                         Padding(
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 16.0, vertical: 20),
//                                           child: Text(
//                                             widget.subjectName,
//                                             style: TextStyle(
//                                                 color: ColorsManager.loginColor,
//                                                 fontSize: 18,
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: SizedBox(
//                                         height: screenHeight / 1.85,
//                                         child: Center(
//                                           child: PDFView(
//                                             filePath: state.pfile.path,
//                                             //  filePath: (state).pdf[0].fileUrl,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     Expanded(
//                                       child: Container(
//                                         //    height: screenHeight / 5,
//                                         decoration: BoxDecoration(
//                                             color: ColorsManager.secondaryColor,
//                                             borderRadius:
//                                                 const BorderRadius.only(
//                                                     topLeft:
//                                                         Radius.circular(20),
//                                                     topRight:
//                                                         Radius.circular(20))),
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(20.0),
//                                           child: Column(
//                                             children: [
//                                               Row(
//                                                 children: [
//                                                   Text(
//                                                     widget.lectureName,
//                                                     style: const TextStyle(
//                                                         color:
//                                                             Color(0xFF844134),
//                                                         fontSize: 20,
//                                                         fontWeight:
//                                                             FontWeight.bold),
//                                                   ),
//                                                   const Spacer(),
//                                                   InkWell(
//                                                     onTap: () {
//                                                       currentSpeed == 1.0
//                                                           ? changeSpeed(1.5)
//                                                           : currentSpeed == 1.5
//                                                               ? changeSpeed(2.0)
//                                                               : changeSpeed(
//                                                                   1.0);
//                                                     },
//                                                     child: Container(
//                                                       width: 60,
//                                                       decoration: BoxDecoration(
//                                                           border: Border.all(
//                                                             color: const Color(
//                                                                 0xFF844134),
//                                                           ),
//                                                           borderRadius:
//                                                               BorderRadius
//                                                                   .circular(
//                                                                       12)),
//                                                       child: const Center(
//                                                         child: Text(
//                                                           '',
//                                                           style: TextStyle(
//                                                               color:
//                                                                   Colors.white,
//                                                               fontSize: 15),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   )
//                                                 ],
//                                               ),
//                                               Slider(
//                                                   min: 0,
//                                                   activeColor: Colors.white,
//                                                   max: duration.inSeconds
//                                                       .toDouble(),
//                                                   value: position.inSeconds
//                                                       .toDouble(),
//                                                   onChanged: handleSeek),
//                                               Row(
//                                                 children: [
//                                                   Text(
//                                                     formatDuration(position),
//                                                     style: const TextStyle(
//                                                       color: Color(0xFF844134),
//                                                     ),
//                                                   ),
//                                                   const Spacer(),
//                                                   Text(
//                                                     formatDuration(duration),
//                                                     style: const TextStyle(
//                                                       color: Color(0xFF844134),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                               Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment
//                                                         .spaceAround,
//                                                 children: [
//                                                   const Icon(
//                                                     Icons.skip_previous,
//                                                     color: Colors.white,
//                                                     size: 50,
//                                                     // Icons.skip_next
//                                                   ),
//                                                   IconButton(
//                                                       onPressed:
//                                                           handlePlayPause,
//                                                       icon: Icon(
//                                                         player.playing
//                                                             ? Icons.pause
//                                                             : Icons
//                                                                 .play_circle_fill,
//                                                         size: 55,
//                                                         color: Colors.white,
//                                                       )),
//                                                   const Icon(
//                                                     Icons.skip_next,
//                                                     color: Colors.white,
//                                                     size: 50,
//                                                     // Icons.skip_next
//                                                   )
//                                                 ],
//                                               )
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             } else if (state is FailurePdfState) {
//                               return Text((state).message);
//                             } else {
//                               return const Padding(
//                                 padding: EdgeInsets.all(8.0),
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Center(child: Indicator()),
//                                   ],
//                                 ),
//                               );
//                             }
//                           },
//                         )
//                       : Align(
//                           alignment: Alignment.bottomCenter,
//                           child: Container(
//                             height: screenHeight / 3,
//                             decoration: BoxDecoration(
//                                 color: ColorsManager.secondaryColor,
//                                 borderRadius: const BorderRadius.only(
//                                     topLeft: Radius.circular(20),
//                                     topRight: Radius.circular(20))),
//                             child: Padding(
//                               padding: const EdgeInsets.all(20.0),
//                               child: Column(
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Text(
//                                         widget.lectureName,
//                                         style: const TextStyle(
//                                             color: Color(0xFF844134),
//                                             fontSize: 20,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                       const Spacer(),
//                                       InkWell(
//                                         onTap: () {
//                                           currentSpeed == 1.0
//                                               ? changeSpeed(1.5)
//                                               : currentSpeed == 1.5
//                                                   ? changeSpeed(2.0)
//                                                   : changeSpeed(1.0);
//                                         },
//                                         child: Container(
//                                           width: 60,
//                                           decoration: BoxDecoration(
//                                               border: Border.all(
//                                                 color: const Color(0xFF844134),
//                                               ),
//                                               borderRadius:
//                                                   BorderRadius.circular(12)),
//                                           child: Center(
//                                             child: Text(
//                                               '$currentSpeed',
//                                               style: const TextStyle(
//                                                   color: Colors.white,
//                                                   fontSize: 15),
//                                             ),
//                                           ),
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                   Slider(
//                                       min: 0,
//                                       activeColor: Colors.white,
//                                       max: duration.inSeconds.toDouble(),
//                                       value: position.inSeconds.toDouble(),
//                                       onChanged: handleSeek),
//                                   Row(
//                                     children: [
//                                       Text(
//                                         formatDuration(position),
//                                         style: const TextStyle(
//                                           color: Color(0xFF844134),
//                                         ),
//                                       ),
//                                       const Spacer(),
//                                       Text(
//                                         formatDuration(duration),
//                                         style: const TextStyle(
//                                           color: Color(0xFF844134),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceAround,
//                                     children: [
//                                       const Icon(
//                                         Icons.skip_previous,
//                                         color: Colors.white, size: 50,
//                                         // Icons.skip_next
//                                       ),
//                                       IconButton(
//                                           onPressed: handlePlayPause,
//                                           icon: Icon(
//                                             player.playing
//                                                 ? Icons.pause
//                                                 : Icons.play_circle_fill,
//                                             size: 55,
//                                             color: Colors.white,
//                                           )),
//                                       const Icon(
//                                         Icons.skip_next,
//                                         color: Colors.white,
//                                         size: 50,
//                                         // Icons.skip_next
//                                       )
//                                     ],
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                 );
//               } else if (state is Loading) {
//                 return const Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Center(child: Indicator()),
//                     ],
//                   ),
//                 );
//               } else {
//                 return Text((state as FailureGet).message);
//               }
//             },
//           ),
//         );
//       }),
//     );
//   }

//   String formatDuration(Duration d) {
//     final minutes = d.inMinutes.remainder(60);
//     final seconds = d.inSeconds.remainder(60);
//     return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
//   }
// }
