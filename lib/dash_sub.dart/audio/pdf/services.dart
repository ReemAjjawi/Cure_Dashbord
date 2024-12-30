import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import '../../../config/app_url.dart';
import '../../../config/header_config.dart';
import '../../../subjects/handle_model.dart';
import 'model.dart';

abstract class Service {
  Dio dio = Dio();
  late Response response;
}

abstract class PdfService extends Service {
  Future<DataSuccessObject<PdfModel>> getPdf(int id);
}

class PdfServiceImp extends PdfService {
  @override
  Future<DataSuccessObject<PdfModel>> getPdf(int? id) async {
    try {
      final response = await dio.get("${AppUrl.baseUrl}${AppUrl.pdf}$id",
          options: HeaderConfig.getHeader(useToken: true));
      print("${AppUrl.baseUrl}${AppUrl.pdf}$id");
      print(response.statusCode);
      print(response.data);
      PdfModel pdfs = PdfModel.fromMap(response.data);
      print(pdfs);
      return DataSuccessObject<PdfModel>(data: pdfs);
    } on DioException catch (e) {
      rethrow;
    }
  }
}
