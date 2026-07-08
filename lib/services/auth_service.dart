import 'package:dio/dio.dart';
import 'package:stock_app/api/api_client.dart';

class AuthService {
  Future<String?> login({
    required String username,
    required String password,
  }) async {
    try {
      // final response = await ApiClient.dio.post(
      //   "/login",
      //   data: {
      //     "username": username,
      //     "password": password,
      //   },
      // );

      // if (response.statusCode == 200) {
      //   return response.data["token"];
      // }

      // return null;
      
      return 'yes';
    } on DioException catch (e) {
      print(e.response?.data);
      return null;
    }
  }
}