import 'dart:io';

import 'package:cure/core/helper/indicator.dart';
import 'package:cure/main.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/resources/managers/colors_manager.dart';
import '../../home.dart';
import '../bloc/lec_bloc.dart';
import '../bloc/lec_event.dart';
import '../bloc/lec_state.dart';
import '../pdf/presentation/bloc/pdf_bloc.dart';
import '../pdf/presentation/bloc/pdf_event.dart';
import '../pdf/presentation/bloc/pdf_state.dart';

class PdfAudioPage extends StatefulWidget {
  PdfAudioPage(
      {super.key,
      required this.lectureName,
      required this.subjectName,
      required this.index});
  int index;
  String lectureName;
  String subjectName;
  @override
  State<PdfAudioPage> createState() => _PdfAudioPageState();
}

class _PdfAudioPageState extends State<PdfAudioPage> {
  Duration duration = Duration.zero;
  String lectureNameHack = '';

  late bool noPdf = true;

  Duration position = Duration.zero;
  double currentSpeed = 1.0;
  int? id = 0;
  bool isLoading = false;
  bool isDownloaded = false;
  late AudioPlayer player;

  String transliterateToEnglish(String arabicText) {
    // Regular expression to match Arabic characters
    final arabicPattern = RegExp(r'[\u0600-\u06FF]');
    bool x = arabicPattern.hasMatch(arabicText);
    if (x == true) {
      final arabicToLatin = {
        'ا': 'a',
        'ب': 'b',
        'ت': 't',
        'ث': 'th',
        'ج': 'j',
        'ح': 'h',
        'خ': 'kh',
        'د': 'd',
        'ذ': 'dh',
        'ر': 'r',
        'ز': 'z',
        'س': 's',
        'ش': 'sh',
        'ص': 's',
        'ض': 'd',
        'ط': 't',
        'ظ': 'z',
        'ع': 'aa',
        'غ': 'gh',
        'ف': 'f',
        'ق': 'q',
        'ك': 'k',
        'ل': 'l',
        'م': 'm',
        'ن': 'n',
        'ه': 'h',
        'و': 'w',
        'ي': 'y'
      };

      String result = '';
      for (int i = 0; i < arabicText.length; i++) {
        String char = arabicText[i];
        result += arabicToLatin[char] ??
            char; // Keep the character if no mapping exists
      }
      return result;
    }
    return arabicText;
  }

  @override
  void initState() {
    super.initState();

// Example usage
    lectureNameHack = transliterateToEnglish(widget.lectureName);
    print(widget.lectureName); // Converts the Arabic text into English letters

    player = AudioPlayer(); // Initialize the audio player

    // Listen to position updates
    player.positionStream.listen((p) {
      setState(() => position = p);
    });

    // Listen to duration updates
    player.durationStream.listen((d) {
      setState(() => duration = d ?? Duration.zero); // Handle null duration
    });

    // Listen to player state updates
    player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        setState(() {
          position = Duration.zero;
        });
        player.pause();
        player.seek(position); // Seek back to start when finished
      }
    });

    _checkFile(); // Check if audio file is available
  }

  // Play or pause audio based on current state
  void handlePlayPause() {
    if (player.playing) {
      player.pause();
    } else {
      player.play();
    }
  }

  // Seek to a specific position
  void handleSeek(double value) {
    player.seek(Duration(seconds: value.toInt()));
  }

  // Change playback speed
  void changeSpeed(double speed) {
    setState(() {
      currentSpeed = speed;
    });
    player.setSpeed(speed);
  }

  // Check if the audio file is available on the device
  Future<void> _checkFile() async {
    final available = await isAudioFileAvailable("$lectureNameHack.mp3");
    setState(() => isDownloaded = available);
  }

  Future<void> downloadAudio() async {
    setState(() => isLoading = true);
    try {
      final url =
          "http://199.192.19.220:8000/api/v1/lectures/audio-lectures/download/$id";
      print(url);
      print("id");
      print(id);

      await _downloadAudioFile(url, "$lectureNameHack.mp3");

      setState(() {
        isLoading = false;
        isDownloaded = true;
      });
    } catch (e) {
      setState(() => isLoading = false);
      print("Download failed: $e");
    }
  }

  // Check if the audio file exists on the device
  Future<bool> isAudioFileAvailable(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';
    return File(filePath).exists();
  }

  // Play the audio from the device
  Future<void> playAudio() async {
    final directory = await getApplicationDocumentsDirectory();
// Encode the lecture name
    final filePath = '${directory.path}/$lectureNameHack.mp3';

    try {
      final file = File(filePath);
      if (!await file.exists()) {
        print("Audio file does not exist at path: $filePath");
        return;
      }

      await player.setFilePath(filePath); // Set the file path

      if (player.playing) {
        await player.pause();
      } else {
        await player.play(); // Start playing the audio
      }
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  // Download the audio file from the network
  Future<File> _downloadAudioFile(String url, String fileName) async {
    var box = Hive.box('projectBox');
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';
    final file = File(filePath);

    if (await file.exists()) return file; // Return if file already exists

    try {
      Dio dio = Dio();
      await dio.download(url, filePath,
          options: Options(
            headers: {"Authorization": "Bearer ${box.get('token')}"},
          ));
    } catch (e) {
      print("Error downloading audio: $e");
    }
    return file;
  }

  @override
  void dispose() {
    player.dispose(); // Dispose of the player when no longer needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.sizeOf(context).width;
    screenHeight = MediaQuery.sizeOf(context).height;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LectureInformationBloc()
            ..add(GetInfoLecture(lectureId: widget.index)),

          //   BlocProvider(create: (context) => AudioBloc()..add(GetAudio())),
        ),
        BlocProvider(
          create: (context) => PdfBloc(),
        ),
      ],
      child: Builder(builder: (context) {
        return Scaffold(
          body:
              BlocConsumer<LectureInformationBloc, GetInformationLectureState>(
            listener: (context, state) {
              if (state is SuccessGet) {
                if (state.xx.pdfLectureId == null &&
                    state.xx.pdfLectureDownloadLink == null &&
                    state.xx.audioLectureDownloadLink == null &&
                    state.xx.audioLectureId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      duration: Duration(seconds: 3),
                      content: Text("لا يوجد تسجيل صوتي لهذه المحاضرة بعد")));
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return const HomePage();
                  }));
                }

                setState(() {
                  id = state.xx.audioLectureId;
                });
                print("hiiiii");
                if (state.xx.pdfLectureId != null) {
                  context
                      .read<PdfBloc>()
                      .add(GetPdf(index: state.xx.pdfLectureId));
                  setState(() {
                    noPdf = false;
                  });
                } else {
                  setState(() => noPdf = true);
                }
              }
            },
            builder: (context, state) {
              if (state is SuccessGet && id != 0) {
                return SafeArea(
                  child: noPdf == false
                      ? BlocConsumer<PdfBloc, PdfState>(
                          listener: (context, state) {
                            if (state is FailurePdfState) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(state.message),
                                duration: const Duration(seconds: 5),
                              ));
                            }
                          },
                          builder: (context, state) {
                            if (state is showpdf) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0, vertical: 20),
                                          child: Text(
                                            widget.subjectName,
                                            style: TextStyle(
                                                color: ColorsManager.loginColor,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        height: screenHeight / 1.85,
                                        child: Center(
                                          child: PDFView(
                                            filePath: state.pfile.path,
                                            //  filePath: (state).pdf[0].fileUrl,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        //    height: screenHeight / 5,
                                        decoration: BoxDecoration(
                                            color: ColorsManager.secondaryColor,
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(20),
                                                    topRight:
                                                        Radius.circular(20))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    widget.lectureName,
                                                    style: const TextStyle(
                                                        color:
                                                            Color(0xFF844134),
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const Spacer(),
                                                  InkWell(
                                                    onTap: () {
                                                      currentSpeed == 1.0
                                                          ? changeSpeed(1.5)
                                                          : currentSpeed == 1.5
                                                              ? changeSpeed(2.0)
                                                              : changeSpeed(
                                                                  1.0);
                                                    },
                                                    child: Container(
                                                      width: 60,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                            color: const Color(
                                                                0xFF844134),
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12)),
                                                      child: Center(
                                                        child: Text(
                                                          '$currentSpeed',
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 15),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Slider(
                                                  min: 0,
                                                  activeColor: Colors.white,
                                                  max: duration.inSeconds
                                                      .toDouble(),
                                                  value: position.inSeconds
                                                      .toDouble(),
                                                  onChanged: handleSeek),
                                              Row(
                                                children: [
                                                  Text(
                                                    formatDuration(position),
                                                    style: const TextStyle(
                                                      color: Color(0xFF844134),
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  Text(
                                                    formatDuration(duration),
                                                    style: const TextStyle(
                                                      color: Color(0xFF844134),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  const Icon(
                                                    Icons.skip_previous,
                                                    color: Colors.white,
                                                    size: 50,
                                                    // Icons.skip_next
                                                  ),
                                                  IconButton(
                                                      onPressed: isDownloaded
                                                          ? playAudio
                                                          : downloadAudio,
                                                      icon: Icon(
                                                        isDownloaded
                                                            ? player.playing
                                                                ? Icons.pause
                                                                : Icons
                                                                    .play_circle_fill
                                                            : isLoading
                                                                ? Icons
                                                                    .circle_notifications
                                                                : Icons
                                                                    .download,
                                                        size: 55,
                                                        color: Colors.white,
                                                      )),
                                                  const Icon(
                                                    Icons.skip_next,
                                                    color: Colors.white,
                                                    size: 50,
                                                    // Icons.skip_next
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else if (state is FailurePdfState) {
                              return Text((state).message);
                            } else {
                              return const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(child: Indicator()),
                                  ],
                                ),
                              );
                            }
                          },
                        )
                      : Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: screenHeight / 3,
                            decoration: BoxDecoration(
                                color: ColorsManager.secondaryColor,
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20))),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        widget.lectureName,
                                        style: const TextStyle(
                                            color: Color(0xFF844134),
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Spacer(),
                                      InkWell(
                                        onTap: () {
                                          currentSpeed == 1.0
                                              ? changeSpeed(1.5)
                                              : currentSpeed == 1.5
                                                  ? changeSpeed(2.0)
                                                  : changeSpeed(1.0);
                                        },
                                        child: Container(
                                          width: 60,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: const Color(0xFF844134),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: Center(
                                            child: Text(
                                              '$currentSpeed',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Slider(
                                      min: 0,
                                      activeColor: Colors.white,
                                      max: duration.inSeconds.toDouble(),
                                      value: position.inSeconds.toDouble(),
                                      onChanged: handleSeek),
                                  Row(
                                    children: [
                                      Text(
                                        formatDuration(position),
                                        style: const TextStyle(
                                          color: Color(0xFF844134),
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        formatDuration(duration),
                                        style: const TextStyle(
                                          color: Color(0xFF844134),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      const Icon(
                                        Icons.skip_previous,
                                        color: Colors.white, size: 50,
                                        // Icons.skip_next
                                      ),
                                      IconButton(
                                          onPressed: isDownloaded
                                              ? playAudio
                                              : downloadAudio,
                                          icon: Icon(
                                            isDownloaded
                                                ? player.playing
                                                    ? Icons.pause
                                                    : Icons.play_circle_fill
                                                : isLoading
                                                    ? Icons.circle_notifications
                                                    : Icons.download,
                                            size: 55,
                                            color: Colors.white,
                                          )),
                                      const Icon(
                                        Icons.skip_next,
                                        color: Colors.white,
                                        size: 50,
                                        // Icons.skip_next
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                );
              } else if (state is FailureGet) {
                return Text(state.message);
              } else {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(child: Indicator()),
                    ],
                  ),
                );
              }
            },
          ),
        );
      }),
    );
  }

  String formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }
}
