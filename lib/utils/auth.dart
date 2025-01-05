import 'dart:convert';

import '../services/api_client.dart';
import '../services/auth_service.dart';

class Auth {
  static final AuthService _authService = AuthService();
  static final ApiClient _apiClient = ApiClient();

  // Đăng nhập
  static Future<Map<String, dynamic>> login(String username, String password) async {
    var result = await _authService.login(username, password);
    return result; // returns a map with {success: bool, token: string?, role: string?, message: string?}
  }

  // Đăng ký tài khoản mới
  static Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
    required String phoneNumber,
    required String fullName,
    required String address,
    required String gender,
    required String? dateOfBirth,
    required String licenseClass,
  }) async {
    // Tạo body để gửi lên API
    Map<String, dynamic> body = {
      "Username": username,
      "Email": email,
      "Password": password,
      "ConfirmPassword": confirmPassword,
      "PhoneNumber": phoneNumber,
      "FullName": fullName,
      "Address": address,
      "Gender": gender,
      "DateOfBirth": dateOfBirth,
      "ClassOfDriverLicense": licenseClass,
    };

    // Gọi API đăng ký thông qua ApiClient
    try {
      var response = await _apiClient.post('Authenticate/register', body: body);

      // Xử lý kết quả từ API
      if (response.statusCode == 200) {
        // Chuyển đổi body JSON từ API thành Map
        var result = jsonDecode(response.body);
        return result;
      } else {
        return {
          'success': false,
          'message': 'Đăng ký thất bại, vui lòng thử lại.'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Lỗi kết nối: ${e.toString()}'
      };
    }
  }
}
