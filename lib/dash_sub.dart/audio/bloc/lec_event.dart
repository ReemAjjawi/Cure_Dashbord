// ignore_for_file: public_member_api_docs, sort_constructors_first
sealed class GetInformationLectureEvent {}

class GetInfoLecture extends GetInformationLectureEvent {
  int lectureId;
  GetInfoLecture({
    required this.lectureId,
  });
}
