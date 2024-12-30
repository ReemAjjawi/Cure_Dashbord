// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'subjects_bloc.dart';

@immutable
sealed class SubjectsEvent {}

class GetSubjects extends SubjectsEvent {}

class AddSubject extends SubjectsEvent {
  String name;
  int type;

  AddSubject({
    required this.name,
    required this.type,
  });
}
