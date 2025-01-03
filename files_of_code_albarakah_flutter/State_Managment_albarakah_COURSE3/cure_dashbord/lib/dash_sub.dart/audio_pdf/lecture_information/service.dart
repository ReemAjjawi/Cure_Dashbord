import 'package:dio/dio.dart';

import '../../../config/app_url.dart';
import '../../../config/header_config.dart';
import '../../../core/handle_model.dart';
import 'lecture_information_model.dart';
import '../../lectures/models/request/model.dart';

abstract class Service {
  Dio dio = Dio();
  late Response response;
}

abstract class LectureService extends Service {
  Future<DataSuccessObject<LectureInformationModel>> getInfoLecture(
      int lectureId);
}

class LectureServiceInfoImp extends LectureService {
  @override
  Future<DataSuccessObject<LectureInformationModel>> getInfoLecture(
      int lectureId) async {
    try {
      print(lectureId);
      response = await dio.get(
          "${AppUrl.baseUrl}${AppUrl.lectureInfo}$lectureId",
          options: HeaderConfig.getHeader(useToken: true));
      print(response.statusCode);
      print("hi");
      LectureInformationModel lectureInfo =
          LectureInformationModel.fromMap(response.data);
      return DataSuccessObject<LectureInformationModel>(data: lectureInfo);
    } on DioException catch (e) {
      throw e;
    }
  }
}
