
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/handle_model.dart';
import '../../models/request/model.dart';
import '../../models/response/response_code_model.dart';
import '../../service.dart';
import 'code_event.dart';
import 'code_state.dart';

class CodeBloc extends Bloc<CodeEvent, CodeState> {
  CodeBloc() : super(CodeEmpty()) {
    on<GenerateCode>((event, emit) async {
      emit(CodeLoading());
         try { SuccessSituation response = await CodeServiceImp()
          .generateCode(event.numberOfCodes, event.subjectsNumber);
  
        if (response is DataSuccessList<CodeResponse>) {
          emit(SuccessGenerateCode(code: response.data));
        }
      } on DioException catch (e) {
        emit(FailureCodeState(message: e.message!));
      }
    });
  }
}
