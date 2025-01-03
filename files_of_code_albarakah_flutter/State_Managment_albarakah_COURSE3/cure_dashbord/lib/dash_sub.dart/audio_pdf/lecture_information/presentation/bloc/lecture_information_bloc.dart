import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/handle_model.dart';

import '../../lecture_information_model.dart';
import 'lecture_information_event.dart';
import 'lecture_information_state.dart';
import '../../service.dart';

class LectureInformationBloc
    extends Bloc<GetInformationLectureEvent, GetInformationLectureState> {
  LectureInformationBloc() : super(Loading()) {
    on<GetInfoLecture>((event, emit) async {
      try {
        SuccessSituation response =
            await LectureServiceInfoImp().getInfoLecture(event.lectureId);

        if (response is DataSuccessObject<LectureInformationModel>) {
          emit(SuccessGet(xx: response.data));
          print(response.data);
        }
      } on DioException catch (e) {
        emit(FailureGet(message: e.message!));
      }
    });
  }
}
