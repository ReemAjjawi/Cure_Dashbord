part of 'lectures_bloc.dart';

@immutable
sealed class LecturesState {}

final class LecturesLoading extends LecturesState {}

final class LecturesList extends LecturesState {
  List<LectureModel> lectures;
  int numOfLectures;

  LecturesList({required this.lectures,required this.numOfLectures});
}

final class LecturesEmpty extends LecturesState {
  int numOfLectures;
    LecturesEmpty({required this.numOfLectures});

}

final class SuccessAddLecture extends LecturesState {}

class FailureLecturesState extends LecturesState {
  final String message;

  FailureLecturesState({required this.message});
}
