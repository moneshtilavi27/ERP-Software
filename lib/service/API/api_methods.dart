import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class APIMethods {
  final _dio = Dio();
  late String demoJwt =
      "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VybmFtZSI6ImFkbWluIiwicGFzc3dvcmQiOiIxYTFkYzkxYzkwNzMyNWM2OTI3MWRkZjBjOTQ0YmM3MiIsInR5cGUiOiJhZG1pbiJ9.4WftTNRu8ZP2nxZECN7wFMMeYYPl4NgMbuXygTDbPFs";

  Future<Response> getData(String uri, dynamic data) async {
    // SharedPreferences sp = await SharedPreferences.getInstance();
    // jwt = sp.getString('auth_key');
    try {
      Response response = await _dio.get(uri,
          queryParameters: {'cow_id': 1684150776896},
          options: Options(headers: {'Authorization': 'Bearer $demoJwt'}));
      // print(response.data.toString());
      return response;
    } catch (e) {
      print("error: $e");
      throw Exception("error: $e");
    }
  }

  Future<Response> postData(String uri, dynamic data) async {
    try {
      print(data);
      SharedPreferences sp = await SharedPreferences.getInstance();
      String jwt = sp.getString("auth_key") ?? demoJwt;
      FormData formData = FormData.fromMap(data);
      // _dio.options.contentType = 'x-www-form-urlencoded';
      _dio.options.headers['Content-Type'] = 'multipart/form-data;';
      Response response = await _dio.post(uri,
          data: formData,
          options: Options(headers: {'Authorization': 'Bearer $jwt'}));
      return response;
    } on DioError catch (e) {
      throw Exception(e.response!.data.toString());
    }
  }
}
