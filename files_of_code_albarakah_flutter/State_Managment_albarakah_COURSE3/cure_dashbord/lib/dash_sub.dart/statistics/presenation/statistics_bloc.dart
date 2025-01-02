
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../subjects/handle_model.dart';

import '../model.dart';
import '../service.dart';
import 'statistics_event.dart';
import 'statistics_state.dart';

class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  StatisticsBloc() : super(StatisticsLoading()) {
    on<GetNumberOfUserEvent>((event, emit) async {

      try {
        SuccessSituation response =
            await numOfUserInSubjectServiceImp().getNumberOfUserInSubject();

        if (response is DataSuccessList<Datum>) {
          emit(SuccessGetNumberOfUser(num: response.data));
        }
      } on DioException catch (e) {
        emit(FailureStatisticsState(message: e.message!));
      }
    });
  }
}
