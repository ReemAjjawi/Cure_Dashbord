import 'package:flutter/material.dart';

import '../../lecture_information_model.dart';

@immutable
sealed class GetInformationLectureState {}

final class SuccessGet extends GetInformationLectureState {
  LectureInformationModel xx;
    SuccessGet({required this.xx});

}

final class FailureGet extends GetInformationLectureState {
  String message;
  FailureGet({required this.message});
}

final class Loading extends GetInformationLectureState {}
