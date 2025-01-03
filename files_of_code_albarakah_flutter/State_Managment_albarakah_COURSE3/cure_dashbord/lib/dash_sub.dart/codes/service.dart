import 'package:dio/dio.dart';

import '../../../config/app_url.dart';
import '../../../config/header_config.dart';
import '../../core/handle_model.dart';
import 'models/request/model.dart';
import 'models/response/response_code_model.dart';

abstract class Service {
  Dio dio = Dio();
  late Response response;
}

abstract class CodeService extends Service {
  Future<DataSuccessList<CodeResponse>> generateCode(
      int numberOfCodes, List<int> subjects);
}

class CodeServiceImp extends CodeService {
  @override
  Future<DataSuccessList<CodeResponse>> generateCode(
      int numberOfCodes, List<int> subjects) async {
    print("hi");
    print(subjects);
    print(numberOfCodes);
    try {
      final response = await dio.post(
        AppUrl.baseUrl + AppUrl.addCode,
        options: HeaderConfig.getHeader(useToken: true),
        data: CodeGeneration(number_of_codes: numberOfCodes, subjects: subjects)
            .toMap(),
      );
      print(
        AppUrl.baseUrl + AppUrl.addCode,
      );
      List<CodeResponse> code = List.generate(
        response.data.length,
        (index) => CodeResponse.fromMap(response.data[index]),
      );
      return DataSuccessList<CodeResponse>(data: code);
    } on DioException catch (e) {
      rethrow;
    }
  }
}
