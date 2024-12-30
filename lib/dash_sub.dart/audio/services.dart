import 'package:cure/config/app_url.dart';
import 'package:dio/dio.dart';

import '../../config/header_config.dart';
import '../../subjects/handle_model.dart';
import 'model.dart';

abstract class Service {
  Dio dio = Dio();
  late Response response;
}

abstract class AudioService extends Service {
  Future<DataSuccessList<AudioModel>> getAudio();
  // You can add more methods for audio-related operations here, if needed.
}

class AudioServiceImp extends AudioService {
  @override
  Future<DataSuccessList<AudioModel>> getAudio() async {
    try {
      final response = await dio.get(AppUrl.baseUrl + AppUrl.audio, options: HeaderConfig.getHeader(useToken: true));
      print(response.data);
      print("iam in audio service");
      print(response.statusCode);
      List<AudioModel> audioSubjects = List.generate(
        response.data.length,
        (index) => AudioModel.fromJson(response.data[index]),
      );
      print(audioSubjects[0].fileUrl);
      return DataSuccessList<AudioModel>(data: audioSubjects);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }
}
