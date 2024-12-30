import 'package:bloc/bloc.dart';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:meta/meta.dart';

import '../../../../subjects/handle_model.dart';
import '../../lecture_response_model_pdf.dart';
import '../../model.dart';
import '../../services.dart';
import '../lecture_response_model_audio.dart';

part 'lectures_event.dart';
part 'lectures_state.dart';

class LecturesBloc extends Bloc<LecturesEvent, LecturesState> {
  LecturesBloc() : super(LecturesLoading()) {
    int x = 0;
    on<GetLecturess>((event, emit) async {
      try {
        SuccessSituation response =
            await LectureServiceImp().getLectures(event.subjectId);

        if (response is DataSuccessList<LectureModel>) {
          if (response.data.isEmpty) {
            emit(LecturesEmpty(numOfLectures: 0));
          } else
            emit(LecturesList(
                lectures: response.data, numOfLectures: response.data.length));
        }
      } on DioException catch (e) {
        emit(FailureLecturesState(message: e.message!));
      }
    });

    on<AddLecture>((event, emit) async {
      emit(LecturesLoading());
      late SuccessSituation response1, response2, response3;
      try {
        response1 =
            await LectureServiceImp().addLecture(event.name, event.subjectId);
        print("in bloc add lecture");

        if (response1 is DataSuccessObject<LectureModel>) {
          x = response1.data.id;
          print("success bloc add lecture");
          //  emit(SuccessAddLecture());
        }
      } on DioException catch (e) {
        emit(FailureLecturesState(message: e.message!));
      }
      print("in bloc add pdf");
      if (event.filePathPdf != null) {
        response2 = await LectureServiceImp().addPdf(event.filePathPdf, x);
        print(event.lectureNum);
        try {
          print("in bloc add pdf");

          emit(LecturesLoading());
          if (response2 is DataSuccessObject<PdfLecture>) {
            print("in success bloc add pdf");
          }
        } on DioException catch (e) {
          emit(FailureLecturesState(message: e.message!));
        }
      }
      try {
        response3 = await LectureServiceImp().addAudio(event.filePathAudio, x);
        print("in bloc add audio");

        emit(LecturesLoading());
        if (response3 is DataSuccessObject<AudioLecture>) {
          print("success bloc add audio");
        }
      } on DioException catch (e) {
        emit(FailureLecturesState(message: e.message!));
      }
      if (event.filePathPdf != null) {
        if (response1 is DataSuccessObject<LectureModel> &&
            response2 is DataSuccessObject<PdfLecture> &&
            response3 is DataSuccessObject<AudioLecture>) {
          emit(SuccessAddLecture());
        }
      } else {
        if (response1 is DataSuccessObject<LectureModel> &&
            response3 is DataSuccessObject<AudioLecture>) {
          emit(SuccessAddLecture());
        }
      }
    });
  }
}
