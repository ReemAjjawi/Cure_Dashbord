// ignore_for_file: public_member_api_docs, sort_constructors_first

import '../../model.dart';

sealed class LogInClassEvent {}

class LogInEvent extends LogInClassEvent {
  LogInModelAdmin user;
  LogInEvent({
    required this.user,
  });
 
}
