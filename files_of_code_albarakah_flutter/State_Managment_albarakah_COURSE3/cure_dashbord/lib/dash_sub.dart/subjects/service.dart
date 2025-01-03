import 'package:dio/dio.dart';

import '../../config/app_url.dart';
import '../../config/header_config.dart';
import '../../core/handle_model.dart';
import 'models/response/model.dart';
import 'models/request/subject_post_model.dart';

abstract class Service {
  Dio dio = Dio();
  late Response response;
}

abstract class SubjectService extends Service {
  Future<DataSuccessList<SubjectModelGet>> getSubjects();
  Future<SuccessSituation> addSubject(String name, int type);
}

class SubjectServiceImp extends SubjectService {
  @override
  Future<DataSuccessList<SubjectModelGet>> getSubjects() async {
    try {
      final response = await dio.get(AppUrl.baseUrl + AppUrl.showSubjects,
          options: HeaderConfig.getHeader(useToken: true));
      print("Received subjects data: ${response.data}");
      List<SubjectModelGet> subjects = List.generate(
        response.data.length,
        (index) => SubjectModelGet.fromMap(response.data[index]),
      );
      print(response.data);
      return DataSuccessList<SubjectModelGet>(data: subjects);
    } on DioException catch (e) {
      print("Error fetching subjects: ${e.message}");
      rethrow; // Rethrow the DioException
    }
  }

  @override
  Future<String> deleteSubject(int subjectId) async {
    try {
      print("${AppUrl.baseUrl}${AppUrl.addSubject}/$subjectId");
      response = await dio.delete(
        "${AppUrl.baseUrl}${AppUrl.addSubject}/$subjectId",
        options: HeaderConfig.getHeader(useToken: true),
      );

      if (response.statusCode == 204) {
        return "success";
      }
      return "failed";
    } on DioException catch (e) {
      rethrow;
    }
  }

  @override
  Future<SuccessSituation> addSubject(String name, int type) async {
    try {
      print("object");
      response = await dio.post(AppUrl.baseUrl + AppUrl.addSubject,
          options: HeaderConfig.getHeader(useToken: true),
          data: {"name": name, "type": type});
      print("hd777777777777777777777777777777");
      print(response.data);
      SubjectModel sub = SubjectModel.fromMap(response.data);
      return DataSuccessObject<SubjectModel>(data: sub);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }
}








//   @override
//   Future<SuccessSituation> createNewAniml(String name) async {
//     try {
//       response = await dio.post(baseurl, data: {"name": name});
//       AnimalModel animalModel = AnimalModel.fromMap(response.data);
//       return animalModel;
//     } catch (e) {
//       print(e);
//       return ExceptionModel();
//     }
//   }


//   @override
//       Future<SuccessSituation> getSubjectById(int id) async {
//     print(
//         '${AppUrl.baseUrl}/${AppUrl.getBicyclesByCategory}?category=$categoryName');

//     print("hiiiii");
//     try {
//       Response response = await dio.get(
//           '${AppUrl.baseUrl}/${AppUrl.getBicyclesByCategory}?category=$categoryName',
//           options: HeaderConfig.getHeader(useToken: true));
//       print("hiiiii");
//       List<BicycleModel> bicycles = List.generate(
//         response.data['body'].length,
//         (index) => BicycleModel.fromJson(response.data['body'][index]),
//       );
//       // List<BicycleEntity> bicycle =
//       //     bicycles.map<BicycleEntity>((bicycle) => bicycle).toList();
//       return DataSuccessList(data: bicycles);
//        } on DioException catch (e) {
//       throw ServerException(message: "try again");
//     }
   
  
//     }
     


//   Future <SuccessSituation> deleteSubject(int id)async{
// try { 
//   response = await dio.delete(baseurl);
// } catch (e) {
//   print(e); 
// }
//   }







  

// }





  // if (response.statusCode == 200) {
       
  //       List<BicycleListModel> bicycles = List.generate(
  //         response.data['body']['bicycleList'].length,
  //         (index) => BicycleListModel.fromJson(
  //             response.data['body']['bicycleList'][index]),
  //       );
  //       return DataSuccessList(data: bicycles);
  //     }
  //   } on DioException catch (e) {
  //         String? message = e.response?.data['message'];
  //   print("iam in catch");
  //   print(e.response?.data);

  //     if (message == 'Username already in use') {

  