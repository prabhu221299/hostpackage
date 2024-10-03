import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // String ip = '192.168.10.143:7097';

  // prod
  // String url = "https://dev-hrms-backend.azurewebsites.net";
  // dev
  String url = "https://mms-demo-backend.azurewebsites.net";

  // String url = "http://localhost:8089";

  var port = '7097';

  static final ApiService _instance = ApiService._internal();
  final dio = Dio();
  factory ApiService() {
    return _instance;
  }
  ApiService._internal();
  //
  // Future<dynamic> post(String api, Map<String, dynamic> data) async {
  //   try {
  //     print("$url$api");
  //     final response = await dio.post('$url$api', data: data);
  //     if (response.statusCode == 200) {
  //       return _handleResponse(response.data); // Handle both List and Map
  //     } else {
  //       throw Exception('Something went wrong');
  //     }
  //   } on DioError catch (e) {
  //     if (e.response == null) {
  //       // Network error (e.g., no internet connection)
  //       return {'Network Connection Error'};
  //     } else {
  //       // Non-network error (e.g., 4xx or 5xx status code)
  //       // Handle the error here if needed
  //       throw Exception('Error: ${e.response}');
  //     }
  //   }
  // }



  post(String apiString,dynamic data) async {
    var response;
    print("$url$apiString");
    try {
      response = await http.post(
        Uri.parse('$url$apiString'),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200 || response.statusCode==201) {
        var responsebody = jsonDecode(utf8.decode(response.bodyBytes));
        return responsebody;
      } else if(response.statusCode==500){
        var responsebody = jsonDecode(utf8.decode(response.bodyBytes));
        return responsebody;
      }
      else {
        throw Exception('Server Failure');
      }
    } catch (e) {
    }
  }




  auth(String apiString,dynamic data) async {
    var response;
    print("$apiString");
    try {
      response = await http.post(
        Uri.parse('$apiString'),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        var responsebody = jsonDecode(utf8.decode(response.bodyBytes));
        return responsebody;
      } else {
        throw Exception('Server Failure');
      }
    } catch (e) {
      print("HTTP Request Error: $e");
    }
  }

  postPatient(String apiString,dynamic data) async {
    var response;
    print("$url$apiString");
    try {
      response = await http.post(
        Uri.parse('$url$apiString'),
        headers: {
          "Content-Type": "application/json",
        },
        body:data,
      );
      if (response.statusCode == 200) {
        var responsebody = jsonDecode(utf8.decode(response.bodyBytes));
        return responsebody;
      } else {
        throw Exception('Server Failure');
      }
    } catch (e) {
      print("HTTP Request Error: $e");
    }
  }

  Future<dynamic> get(String api, Map<String, dynamic> data) async {
    try {
      print("$url$api");
      final response = await dio.get('$url$api', queryParameters: data);
      if (response.statusCode == 200) {
        return _handleResponse(response.data); // Handle both List and Map
      } else {
        throw Exception('Server down');
      }
    } on DioError catch (e) {
      if (e.response == null) {
        return {'msg': 'Server was down'};
      } else {
        throw Exception('Error: ${e.response}');
      }
    }
  }



  Future<dynamic> update(String api, Map<String, dynamic> data) async {
    try {
      print("$url$api");
      final response = await dio.put('$url$api', data: data);
      if (response.statusCode == 200) {
        return _handleResponse(response.data); // Handle both List and Map
      } else {
        throw Exception('Something went wrong');
      }
    } on DioError catch (e) {
      if (e.response == null) {
        // Network error (e.g., no internet connection)
        return {'Network Connection Error'};
      } else {
        // Non-network error (e.g., 4xx or 5xx status code)
        // Handle the error here if needed
        throw Exception('Error: ${e.response}');
      }
    }
  }

  dynamic _handleResponse(dynamic response) {
    if (response is List) {
      return response;
    } else if (response is Map) {
      return response;
    } else {
      throw Exception('Unexpected response format');
    }
  }


}
