import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/config_url.dart';
import 'package:http/http.dart' as http;

class NotificationUserService {
  Future<Map<String, dynamic>> sendNotificationToAdmin({
    required String title,
    required String message,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt_token');
      if (token == null) {
        return {"success": false, "message": "Authentication token not found."};
      }
      // Tạo URL với receiverName là admin
      final uri = Uri.parse("${Config_URL.baseUrl}notification/send_to_all_admins");
      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "Title": title,
          "Description": message,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        bool status = data['status'];
        return {
          "success": status,
          "message": data['message'],
        };
      } else {
        return {"success": false, "message": "Failed to send notification to admin."};
      }
    } catch (e) {
      return {"success": false, "message": "Network error: $e"};
    }
  }

  // Hàm lấy danh sách thông báo đã nhận
  Future<List<Map<String, dynamic>>> getReceivedNotifications() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt_token');

      // Kiểm tra nếu không có token
      if (token == null || token.isEmpty) {
        print("Token không tồn tại hoặc rỗng");
        return [];
      }

      final uri = Uri.parse("${Config_URL.baseUrl}notification/received");

      final response = await http.get(
        uri,
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      // Kiểm tra mã trạng thái HTTP
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Kiểm tra dữ liệu trả về
        if (data['status'] == true && data['notifications'] != null) {
          return List<Map<String, dynamic>>.from(data['notifications']);
        } else {
          print("API trả về status = false hoặc không có dữ liệu.");
          return [];
        }
      } else {
        print("Lỗi HTTP: ${response.statusCode} - ${response.body}");
        return [];
      }
    } catch (e) {
      // In lỗi ra console để debug
      print("Lỗi khi lấy thông báo: $e");
      return [];
    }

  }

}