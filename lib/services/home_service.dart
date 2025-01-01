import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/config_url.dart';

class HomeService {
  static Future<Map<String, dynamic>> fetchUserInfo() async {
    final String apiUrl = "${Config_URL.baseUrl}user/me";

    try {
      // Lấy token từ SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt_token');

      if (token == null || token.isEmpty) {
        throw Exception('Token không tồn tại hoặc rỗng');
      }

      // Gọi API với token
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Xử lý phản hồi JSON
        if (response.body.isNotEmpty) {
          final data = jsonDecode(response.body);
          if (data is Map<String, dynamic>) {
            return data; // Trả về dữ liệu người dùng
          } else {
            throw Exception('Dữ liệu phản hồi không đúng định dạng Map');
          }
        } else {
          throw Exception('Phản hồi từ API rỗng');
        }
      } else {
        throw Exception(
            'Failed to fetch user info. HTTP status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user info: $e');
      return {}; // Trả về map rỗng nếu có lỗi
    }
  }
}
