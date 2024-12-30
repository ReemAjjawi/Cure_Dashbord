// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'lectures_bloc.dart';

@immutable
sealed class LecturesEvent {}

class GetLecturess extends LecturesEvent {
  int subjectId;
  GetLecturess({
    required this.subjectId,
  });
}

class AddLecture extends LecturesEvent {
  String name;
  int subjectId;
  String? filePathPdf;
  String filePathAudio;
  int lectureNum;
  AddLecture({
    required this.name,
    required this.subjectId,
    required this.filePathPdf,
    required this.filePathAudio,
    required this.lectureNum,
  });
}
