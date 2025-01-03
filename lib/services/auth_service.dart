import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../config/config_url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthService {
  // đường dẫn tới API login
  String get apiUrl => "${Config_URL.baseUrl}Authenticate/login";
  // đuường dẫn tới API updatePassword
  String get updatePasswordUrl => "${Config_URL.baseUrl}user/update-password";

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        //Lấy thông tin tên đăng nhập và password
        body: jsonEncode({
          "username": username,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        bool status = data['status'];
        if (!status) {
          return {"success": false, "message": data['message']};
        }
        //lấy token trả về
        String token = data['token'];
        // Decode token để lấy các thông tin đăng nhập: tên đăng nhập, role...
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

        // Lưu token vào SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('jwt_token', token);  // Lưu token

        return {
          "success": true,
          "token": token,
          "decodedToken": decodedToken,
        };
      } else {
        // If status code is not 200, treat it as login failure
        return {"success": false, "message": "Failed to login: ${response.statusCode}"};
      }
    } catch (e) {
      // Handle network or parsing errors
      return {"success": false, "message": "Network error: $e"};
    }
  }

  Future<Map<String, dynamic>> updatePassword(
      String currentPassword, String newPassword, String confirmNewPassword) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt_token');

      if (token == null) {
        return {"success": false, "message": "Không tìm thấy token, vui lòng đăng nhập lại"};
      }

      final response = await http.patch(
        Uri.parse(updatePasswordUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "CurrentPassword": currentPassword,
          "NewPassword": newPassword,
          "ConfirmNewPassword": confirmNewPassword,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        bool status = data['status'];
        if (!status) {
          return {"success": false, "message": data['message']};
        }
        return {"success": true, "message": "Mật khẩu đã được cập nhật thành công"};
      } else {
        return {
          "success": false,
          "message": "Lỗi khi cập nhật mật khẩu: ${response.statusCode}"
        };
      }
    } catch (e) {
      return {"success": false, "message": "Lỗi mạng: $e"};
    }
  }


}