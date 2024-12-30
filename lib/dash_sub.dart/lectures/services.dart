import 'dart:io';

import 'package:dio/dio.dart';

import '../../../config/header_config.dart';
import '../../config/app_url.dart';
import '../../subjects/handle_model.dart';
import 'lecture_post_model.dart';
import 'lecture_response_model_pdf.dart';
import 'model.dart';
import 'presentation/lecture_response_model_audio.dart';

abstract class Service {
  Dio dio = Dio();
  late Response response;
}

abstract class LectureService extends Service {
  Future<DataSuccessList<LectureModel>> getLectures(int subjectId);
  Future<DataSuccessObject<LectureModel>> addLecture(
      String name, int subjectId);

  Future<DataSuccessObject<PdfLecture>> addPdf(String filePath, int lectureNum);

  Future<DataSuccessObject<AudioLecture>> addAudio(
      String filePath, int lectureNum);
}

class LectureServiceImp extends LectureService {
  @override
  Future<DataSuccessList<LectureModel>> getLectures(int subjectId) async {
    try {
      print(subjectId);
      response = await dio.get("${AppUrl.baseUrl}${AppUrl.lectures}$subjectId",
          options: HeaderConfig.getHeader(useToken: true));

      List<LectureModel> lectures = List.generate(
        response.data.length,
        (index) => LectureModel.fromMap(response.data[index]),
      );
      return DataSuccessList<LectureModel>(data: lectures);
    } on DioException catch (e) {
      rethrow;
    }
  }

  @override
  Future<DataSuccessObject<LectureModel>> addLecture(
      String name, int subjectId) async {
    try {
      LectureAdd lecture = LectureAdd(name: name, subject_id: subjectId);
      response = await dio.post(AppUrl.baseUrl + AppUrl.addLectures,
          options: HeaderConfig.getHeader(useToken: true),
          data: lecture.toMap());
      LectureModel lec = LectureModel.fromMap(response.data);
      return DataSuccessObject<LectureModel>(data: lec);
    } on DioException catch (e) {
      rethrow;
    }
  }

  @override
  Future<DataSuccessObject<PdfLecture>> addPdf(
      String? filePath, int lectureNum) async {
    File file = File(filePath!);
    print(file.path);
    print("in service");
    // Create Dio instance
    Dio dio = Dio();

    try {
      FormData formData = FormData.fromMap({
        'pdf_file': await MultipartFile.fromFile(file.path,
            filename: file.uri.pathSegments.last),
      });
      print("object");
      print(lectureNum);
      // Send the request
      Response response = await dio.post(
          '${AppUrl.baseUrl + AppUrl.addPdf}$lectureNum/pdf-lectures',
          data: formData,
          options: HeaderConfig.getHeader(useToken: true));
      print("object");
      if (response.statusCode == 201) {
        print('File uploaded successfully');
        print("hi");
        PdfLecture pdf = PdfLecture.fromMap(response.data);
        print("hi");

        return DataSuccessObject(data: pdf);
      } else {
        throw Exception('File upload failed: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('Error uploading file: $e');
      rethrow;
    }
  }

  @override
  Future<DataSuccessObject<AudioLecture>> addAudio(
      String filePath, int lectureNum) async {
    File file = File(filePath);
    print(file.path);
    print("in service");
    // Create Dio instance
    Dio dio = Dio();

    try {
      FormData formData = FormData.fromMap({
        'audio_file': await MultipartFile.fromFile(file.path,
            filename: file.uri.pathSegments.last),
      });
      print("object");

      // Send the request
      Response response = await dio.post(
        '${AppUrl.baseUrl + AppUrl.addAudio}$lectureNum/audio-lectures',
        options: HeaderConfig.getHeader(useToken: true),
        data: formData,
      );
      print("object");
      if (response.statusCode == 201) {
        print('File uploaded successfully');
        AudioLecture audio = AudioLecture.fromMap(response.data);
        print(audio);
        return DataSuccessObject(data: audio);
      } else {
        throw Exception('File upload failed: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('Error uploading file: $e');
      rethrow;
    }
  }
}
