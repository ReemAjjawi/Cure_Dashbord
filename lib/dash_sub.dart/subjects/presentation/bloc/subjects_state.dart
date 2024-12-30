part of 'subjects_bloc.dart';

@immutable
sealed class SubjectsState {}

final class SubjectsLoading extends SubjectsState {}

final class SubjectsList extends SubjectsState {
  List<SubjectModelGet> subjects;
  SubjectsList({required this.subjects});
}

final class SubjectsEmpty extends SubjectsState {}

//final class SuccessAddSubject extends SubjectsState {}

class FailureSubjectsState extends SubjectsState {
  final String message;

  FailureSubjectsState({required this.message});
}
