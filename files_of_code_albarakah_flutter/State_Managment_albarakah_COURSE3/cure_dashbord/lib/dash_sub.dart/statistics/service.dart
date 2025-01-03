import 'package:dio/dio.dart';

import '../../config/app_url.dart';
import '../../config/header_config.dart';
import '../../core/handle_model.dart';
import 'model.dart';

abstract class Service {
  Dio dio = Dio();
  late Response response;
}

abstract class numOfUserInSubjectService extends Service {
  Future<DataSuccessList<Datum>> getNumberOfUserInSubject();
}

class numOfUserInSubjectServiceImp extends numOfUserInSubjectService {
  @override
  Future<DataSuccessList<Datum>> getNumberOfUserInSubject() async {
  try {
    final response = await dio.get(
      AppUrl.baseUrl + AppUrl.numberOfUserInSubject,
      options: HeaderConfig.getHeader(useToken: true),
    );
    print("Received subjects data: ${response.data}");

    final List<Datum> num = List<Datum>.from(
      (response.data['data'] as List<dynamic>)
          .map((item) => Datum.fromMap(item)),
    );

    print(response.data);
    print(response.statusCode);
    return DataSuccessList<Datum>(data: num);
  } on DioException catch (e) {
    print("Error fetching number of user in subjects: ${e.message}");
    rethrow; // Rethrow the DioException
  }
}


}
