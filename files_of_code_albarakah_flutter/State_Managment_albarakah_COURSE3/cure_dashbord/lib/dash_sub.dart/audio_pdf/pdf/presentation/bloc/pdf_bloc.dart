import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import '../../../../../core/handle_model.dart';
import '../../model.dart';
import '../../service.dart';
import 'pdf_event.dart';
import 'pdf_state.dart';

class PdfBloc extends Bloc<PdfEvent, PdfState> {
  PdfBloc() : super(PdfLoading()) {
    on<GetPdf>((event, emit) async {
      try {
        SuccessSituation response = await PdfServiceImp().getPdf(event.index);
        if (response is DataSuccessObject<PdfModel>) {
          emit(PdfFile(pdf: response.data));
          print(response.data);
          print("success");
          var box = Hive.box('projectBox');
          final responsee = await http.get(Uri.parse(response.data.file_url),
              headers: {"Authorization": "Bearer ${box.get('token')}"});
          final bytes = responsee.bodyBytes;

          final dir = await getApplicationDocumentsDirectory();
          var file = File('${dir.path}/${response.data.file_name}');
          await file.writeAsBytes(bytes, flush: true);
          print('File saved at: ${file.path}');
          print(file);
          print('File exists: ${file.existsSync()}');

          emit(showpdf(pfile: file));
        }
      } on DioException catch (e) {
        print(e);
        emit(FailurePdfState(message: e.message!));
      }
    });
  }
}
