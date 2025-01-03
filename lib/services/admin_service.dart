import 'dart:convert';
import '../config/config_url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AdminService {
  Future<Map<String, dynamic>> sendNotification({
    required String receiverName,
    required String message,
    required String title,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt_token');

      if (token == null) {
        return {"success": false, "message": "Authentication token not found."};
      }

      // Tạo URL với query parameter receiverName
      final uri = Uri.parse("${Config_URL.baseUrl}notification/send")
          .replace(queryParameters: {"receiverName": receiverName});

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
        return {"success": false, "message": "Failed to send notification."};
      }
    } catch (e) {
      return {"success": false, "message": "Network error: $e"};
    }
  }

  //gửi thông báo đến tất cả driver
  Future<Map<String, dynamic>> sendNotificationToAllDrivers({
    required String title,
    required String message,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt_token');

      if (token == null) {
        return {"success": false, "message": "Authentication token not found."};
      }
      // URL cho API gửi thông báo đến tất cả tài xế
      final uri = Uri.parse("${Config_URL.baseUrl}notification/send_to_all_drivers");

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
        return {"success": false, "message": "Failed to send notification to all drivers."};
      }
    } catch (e) {
      return {"success": false, "message": "Network error: $e"};
    }
  }
}
