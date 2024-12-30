import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/resources/managers/colors_manager.dart';
import '../../../core/helper/indicator.dart';
import '../../../main.dart';
import '../../audio/presentation/view.dart';
import '../../home.dart';
import 'bloc/lectures_bloc.dart';

class ShowLectures extends StatefulWidget {
  const ShowLectures(
      {super.key, required this.subjectName, required this.subjectId});
  final String subjectName;
  final int subjectId;
  @override
  State<ShowLectures> createState() => _ShowLecturesState();
}

class _ShowLecturesState extends State<ShowLectures> {
  // int _selectedIndex = 0;
  // TextEditingController nameOfSubject = TextEditingController();

  TextEditingController nameOfLecture = TextEditingController();
  late int numOfLectures;
  TextEditingController pdfController = TextEditingController();
  TextEditingController audioController = TextEditingController();
  ValueNotifier<String?> pdfFilePath = ValueNotifier<String?>(null);
  ValueNotifier<String?> audioFilePath = ValueNotifier<String?>(null);

  Future<void> pickFilePdf(ValueNotifier<String?> notifier, String type) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: type == 'pdf' ? ['pdf'] : null,
    );

    if (result != null && result.files.single.path != null) {
      notifier.value = result.files.single.path;
      pdfController.text = result.files.single.name;
    }
  }

  Future<void> pickFileAudio(
      ValueNotifier<String?> notifier, String type) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowedExtensions: type == 'pdf' ? ['pdf'] : null,
    );

    if (result != null && result.files.single.path != null) {
      notifier.value = result.files.single.path;

      audioController.text = result.files.single.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LecturesBloc()..add(GetLecturess(subjectId: widget.subjectId)),
      child: Builder(builder: (context) {
        return Scaffold(
          //   backgroundColor: const Color(0xFFFBFAF5),
          body: SafeArea(
            child: BlocConsumer<LecturesBloc, LecturesState>(
              listener: (context, state) {
                if (state is SuccessAddLecture) {
                  _showSuccessDialog(context).then((_) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShowLectures(
                          subjectId: widget.subjectId,
                          subjectName: widget.subjectName,
                        ),
                      ),
                    );
                  });
                } else if (state is LecturesList) {
                  numOfLectures = state.numOfLectures;
                } else if (state is FailureLecturesState) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("error occured ${state.message}")));
                }
                if (state is LecturesEmpty) {
                  numOfLectures = state.numOfLectures;
                }
              },
              builder: (context, state) {
                if (state is SuccessAddLecture) {
                  return const SizedBox();
                } else if (state is LecturesLoading) {
                  return const Center(child: Indicator());
                } else if (state is FailureLecturesState) {
                  return Text(state.message);
                } else if (state is LecturesList) {
                  return SafeArea(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: screenHeight * 0.02,
                        right: screenHeight * 0.02,
                        top: screenHeight * 0.03,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  widget.subjectName,
                                  style: TextStyle(
                                      color: ColorsManager.loginColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              //    const Icon(Icons.menu)
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
                                      return PdfAudioPage(
                                          lectureName:
                                              (state).lectures[index].name,
                                          subjectName: widget.subjectName,
                                          index: (state).lectures[index].id);
                                    }));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Container(
                                      height: screenHeight / 10,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(9),
                                        border: Border.all(
                                            color: const Color(0xFF749081),
                                            width: 0.5),
                                        // boxShadow: const [
                                        //   BoxShadow(
                                        //       blurRadius: 3,
                                        //         offset: Offset(0, 2),
                                        //       color: Color(0xffcec7a580))
                                        // ]
                                      ),
                                      child: ListTile(
                                        trailing: const Icon(
                                          Icons.play_arrow_outlined,
                                          color: Colors.red,
                                          size: 40,
                                        ),
                                        leading: Icon(Icons.download_outlined,
                                            size: 31,
                                            color: ColorsManager.primaryColor),
                                        title: Text(
                                          (state).lectures[index].name,
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              color: ColorsManager.primaryColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: screenWidth * 0.09),
                                                child: Text("ميغا",
                                                    style: TextStyle(
                                                        color: ColorsManager
                                                            .grayColor)),
                                              ),
                                              const Spacer(),
                                              Text(" ساعات",
                                                  style: TextStyle(
                                                      color: ColorsManager
                                                          .grayColor)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              itemCount: (state).lectures.length,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                "المحاضرات",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Icon(Icons.menu)
                          ],
                        ),
                        SizedBox(height: 0.02 * screenHeight),
                        Container(
                          height: screenHeight / 4,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/images/image.png")),
                          ),
                        ),
                        SizedBox(height: 0.16 * screenHeight),
                        Text(
                          'لا يوجد محاضرات بعد , اضغط  "+"  لإضافة محاضرة',
                          style: TextStyle(color: ColorsManager.blackColor),
                        ),
                        SizedBox(height: 0.17 * screenHeight),
                      ],
                    ),
                  );
                }
              },
            ),
          ),

          floatingActionButton: FloatingActionButton(
            backgroundColor: ColorsManager.priaryBColor,
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) {
                  return Dialog(
                    insetPadding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        //    crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenHeight * 0.05,
                                vertical: screenHeight * 0.013),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: screenHeight * 0.01,
                                      vertical: screenHeight * 0.04),
                                  child: Text(
                                    "إضافة محاضرة",
                                    style: TextStyle(
                                        fontSize: 17,
                                        color:
                                            ColorsManager.BorderStudentColor),
                                  ),
                                ),
                                Container(
                                  height: screenHeight * 0.06,
                                  width: screenWidth * 0.08,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            "assets/images/page.png")),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Align(
                            // alignment: Alignment.,
                            child: Padding(
                              padding: EdgeInsets.only(left: screenWidth * 0.6),
                              child: Text(
                                " الملف الصوتي",
                                style: TextStyle(
                                    color:
                                        ColorsManager.textFieldDialougeColor),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 0.02 * screenHeight,
                          ),
                          SizedBox(
                            height: 0.07 * screenHeight,
                            width: 0.76 * screenWidth,
                            child: ValueListenableBuilder<String?>(
                              valueListenable: audioFilePath,
                              builder: (_, value, child) {
                                return TextFormField(
                                  readOnly: true,
                                  controller: audioController,
                                  onTap: () {
                                    pickFileAudio(audioFilePath, 'audio');
                                  },
                                  cursorColor:
                                      ColorsManager.textFieldDialougeColor,
                                  textDirection: TextDirection.rtl,
                                  decoration: InputDecoration(
                                    suffixIcon: Container(
                                      height: screenHeight * 0.06,
                                      width: screenWidth * 0.08,
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                "assets/images/headphone.png")),
                                      ),
                                    ),
                                    border:
                                        const OutlineInputBorder(), // Default border
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: ColorsManager
                                              .textFieldDialougeColor,
                                          width: 2.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          color: ColorsManager
                                              .textFieldDialougeColor,
                                          width: 2.0),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Align(
                            // alignment: Alignment.,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: screenWidth * 0.6,
                                  top: screenHeight * 0.02),
                              child: Text(
                                "الملف النصي",
                                style: TextStyle(
                                    color:
                                        ColorsManager.textFieldDialougeColor),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 0.02 * screenHeight,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: SizedBox(
                              height: 0.07 * screenHeight,
                              width: 0.76 * screenWidth,
                              child: ValueListenableBuilder<String?>(
                                  valueListenable: pdfFilePath,
                                  builder: (_, value, child) {
                                    return TextFormField(
                                      cursorColor:
                                          ColorsManager.textFieldDialougeColor,
                                      readOnly: true,
                                      controller: pdfController,
                                      onTap: () {
                                        pickFilePdf(pdfFilePath, 'pdf');
                                      },
                                      textDirection: TextDirection.rtl,
                                      decoration: InputDecoration(
                                        suffixIcon: Container(
                                          height: screenHeight * 0.06,
                                          width: screenWidth * 0.08,
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    "assets/images/file.png")),
                                          ),
                                        ),
                                        border:
                                            const OutlineInputBorder(), // Default border
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: ColorsManager
                                                  .textFieldDialougeColor,
                                              width: 2.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                              color: ColorsManager
                                                  .textFieldDialougeColor,
                                              width: 2.0),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: screenWidth * 0.6),
                            child: Text(
                              " اسم المحاضرة ",
                              style: TextStyle(
                                  color: ColorsManager.textFieldDialougeColor),
                            ),
                          ),
                          SizedBox(
                            height: 0.02 * screenHeight,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: SizedBox(
                              height: 0.07 * screenHeight,
                              width: 0.76 * screenWidth,
                              child: TextFormField(
                                cursorColor:
                                    ColorsManager.textFieldDialougeColor,
                                controller: nameOfLecture,
                                textDirection: TextDirection.rtl,
                                decoration: InputDecoration(
                                  border:
                                      const OutlineInputBorder(), // Default border
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: ColorsManager
                                            .textFieldDialougeColor,
                                        width: 2.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        color: ColorsManager
                                            .textFieldDialougeColor,
                                        width: 2.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.05),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorsManager.priaryBColor,
                                side: const BorderSide(
                                    color: Color(0xFF597064), width: 1),
                                minimumSize: Size(
                                  0.85 * screenWidth,
                                  0.06 * screenHeight,
                                ), // Set minimum width and height
                                // primary: Colors.blue, // Background color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Change the radius here
                                ),
                              ),
                              onPressed: () {
                                context.read<LecturesBloc>().add(AddLecture(
                                    name: nameOfLecture.text,
                                    subjectId: widget.subjectId,
                                    filePathPdf: pdfFilePath.value,
                                    filePathAudio: audioFilePath.value!,
                                    lectureNum: numOfLectures + 1));
                                nameOfLecture.clear();
                                audioController.clear();
                                pdfController.clear();
                                Navigator.pop(context);
                              },
                              child: Text(
                                "اضافة",
                                style:
                                    TextStyle(color: ColorsManager.loginColor),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );

              // Your onPressed action here
            },
            // Your onPressed action here

            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(65)),
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 38,
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.book), label: 'مقررات'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.qr_code_sharp), label: 'أكواد'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: 'المستخدمين'),
              ],

              selectedItemColor: Colors.white, // Color for selected item
              unselectedItemColor: Colors.white, // Color for unselected items

              backgroundColor: ColorsManager.secondaryColor,
              currentIndex: 0, // Set to the appropriate index
              onTap: (index) {
                // Handle navigation
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const HomePage()), // Navigate back to Home
                );
              },
            ),
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    pdfController.dispose();
    audioController.dispose();
    super.dispose();
  }
}

Future<void> _showSuccessDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        insetPadding: const EdgeInsets.all(16),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        content: SingleChildScrollView(
          child: Column(
            //     mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenHeight * 0.02,
                    vertical: screenHeight * 0.013),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenHeight * 0.01,
                          vertical: screenHeight * 0.04),
                      child: Text(
                        "إضافة محاضرة",
                        style: TextStyle(
                            fontSize: 17,
                            color: ColorsManager.BorderStudentColor),
                      ),
                    ),
                    Container(
                      height: screenHeight * 0.06,
                      width: screenWidth * 0.08,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/page.png")),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: screenHeight / 4,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/success.png")),
                ),
              ),
              Text(
                "تم رفع المحاضرة بنجاح !",
                style: TextStyle(color: ColorsManager.loginColor),
              )
            ],
          ),
        ),
      );
    },
  );
}
