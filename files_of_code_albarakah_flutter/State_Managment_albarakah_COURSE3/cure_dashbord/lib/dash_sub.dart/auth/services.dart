import 'package:dio/dio.dart';
import 'package:hive_flutter/adapters.dart';
import '../../../config/app_url.dart';
import '../../subjects/handle_model.dart';
import 'model.dart';

abstract class service {
  late Response response;

  Dio dio = Dio();
}

abstract class AuthService extends service {
  Future<SuccessSituation> logIn(LogInModelAdmin logn);
}

class AuthServiceImp extends AuthService {
  @override
  Future<SuccessSituation> logIn(LogInModelAdmin logn) async {
    try {
      print(logn.toMap());
      print('${AppUrl.baseUrl}${AppUrl.logInAdmin}');
      final data = logn.toMap();
      Response response = await dio
          .post('${AppUrl.baseUrl}${AppUrl.logInAdmin}', data: logn.toJson());
      print('${AppUrl.baseUrl}${AppUrl.logInAdmin}');

      print(response.data);

      String token = response.data['token'];
      var box = Hive.box('projectBox');

      box.put('token', token);

      return DataSuccessObject(data: response);
    } on DioException catch (e) {
      rethrow;
    }
  }
}
