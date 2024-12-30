import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../subjects/handle_model.dart';
import '../../model.dart';
import '../../services.dart';
import 'audio_event.dart';
import 'audio_state.dart';

class AudioBloc extends Bloc<AudioBEvent, AudioState> {
 AudioBloc() : super(AudioLoading()) {
    on<GetAudio>((event, emit) async {
//     try {
//         if (response is DataSuccessObject <PdfModel>) {
//         emit(  SuccessPdfState(pdf: response));
//       }

//     }on DioException catch (e) {
// emit(FailurePdfState(message:e.message! ));
//           }
//     });
//   }
// }

      try {      SuccessSituation response = await AudioServiceImp().getAudio();

        if (response is DataSuccessList<AudioModel>) {
          emit(AudioList(audio: response.data));
          print(response.data);

          final responsee = await http.get(Uri.parse(response.data[0].fileUrl));
          
        }
      } on DioException catch (e) {
        emit(FailureAudioState(message: e.message!));
      }
    });
  }
}

