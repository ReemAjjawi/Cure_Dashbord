import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:hive_flutter/adapters.dart';

import '../../../../subjects/handle_model.dart';
import '../../services.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LogInClassEvent, LogInClassState> {
  LoginBloc() : super(InitialStateLogIn()) {
    on<LogInEvent>((event, emit) async {
      var box = Hive.box('projectBox');
      emit(LogInLoadingState());
      try {
        SuccessSituation response = await AuthServiceImp().logIn(event.user);
        String? token = box.get('token');
        if (token != null && token.isNotEmpty) {
          emit(LogInSuccessState());
        } else {
          emit(LogInFailureState(message: "Token is empty or null."));
        }
      } on DioException catch (e) {
        emit(LogInFailureState(message: e.message!));
      }
    });
  }
}
