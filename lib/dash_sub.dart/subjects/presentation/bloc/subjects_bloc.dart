import 'package:bloc/bloc.dart';

import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../../../../subjects/handle_model.dart';
import '../../model.dart';
import '../../services.dart';
import '../../subject_post_model.dart';

part 'subjects_event.dart';
part 'subjects_state.dart';

class SubjectsBloc extends Bloc<SubjectsEvent, SubjectsState> {
  SubjectsBloc() : super(SubjectsLoading()) {
    on<GetSubjects>((event, emit) async {
      try {
        print("Fetching subjects...");
        SuccessSituation response = await SubjectServiceImp().getSubjects();
        print(response);
        if (response is DataSuccessList<SubjectModelGet>) {
          if (response.data.isEmpty) {
            emit(SubjectsEmpty());
          } else {
            print("success subjecct");
            emit(SubjectsList(subjects: response.data));
          }
        }
      } on DioException catch (e) {
        print("Error occurred: ${e.message}");
        emit(FailureSubjectsState(message: e.message!));
      } catch (e) {
        // Optionally handle other exceptions
        print("Unhandled error: $e");
        emit(FailureSubjectsState(message: "An unexpected error occurred."));
      }
    });

    on<AddSubject>((event, emit) async {
      print("reem");
      emit(SubjectsLoading());

      try {  SuccessSituation response =
          await SubjectServiceImp().addSubject(event.name, event.type);
    
        print("hi");
        if (response is DataSuccessObject<SubjectModel>) {
          
            print("Fetching subjects...");
            SuccessSituation responsee =
                await SubjectServiceImp().getSubjects();
            print(response);

            if (responsee is DataSuccessList<SubjectModelGet>) {
              print("success subjecct");
              emit(SubjectsList(subjects: responsee.data));
            }}
          } on DioException catch (e) {
        emit(FailureSubjectsState(message: e.message!));
      }
  });
  }
}
