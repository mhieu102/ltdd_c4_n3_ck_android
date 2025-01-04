import 'dart:convert';
import '../config/config_url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ScheduleService {
  // Lấy danh sách lịch trình theo trạng thái xác nhận
  Future<Map<String, dynamic>> getDriverSchedulesByStatus(bool isConfirmed) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt_token');

      if (token == null) {
        return {
          "success": false,
          "schedules": [],
          "message": "Authentication token not found."
        };
      }

      // URL cho API lấy danh sách lịch trình của tài xế với trạng thái xác nhận
      final uri = Uri.parse("${Config_URL.baseUrl}schedule/driver_schedules")
          .replace(queryParameters: {"isConfirmed": isConfirmed.toString()});

      final response = await http.get(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['status'] == true) {
          return {
            "success": true,
            "schedules": data['schedules'] ?? [],
            "message": data['message'] ?? "Lịch trình đã được tải thành công."
          };
        } else {
          return {
            "success": false,
            "schedules": [],
            "message": data['message'] ?? "Không thể tải danh sách lịch trình."
          };
        }
      } else {
        return {
          "success": false,
          "schedules": [],
          "message": "Server error, failed to fetch schedules."
        };
      }
    } catch (e) {
      return {
        "success": false,
        "schedules": [],
        "message": "Network error: $e"
      };
    }
  }
  // Cập nhật trạng thái của lịch trình
  Future<Map<String, dynamic>> updateScheduleStatus(String scheduleId, String status) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt_token');

      if (token == null) {
        return {
          "success": false,
          "message": "Authentication token not found."
        };
      }

      // URL cho API cập nhật trạng thái lịch trình
      final uri = Uri.parse("${Config_URL.baseUrl}schedule/update_status")
          .replace(queryParameters: {
        "scheduleId": scheduleId,
        "status": status,
      });

      final response = await http.put(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        bool success = data['status'] == true;

        return {
          "success": success,
          "message": data['message'] ?? "Trạng thái đã được cập nhật thành công."
        };
      } else {
        return {
          "success": false,
          "message": "Server error, failed to update schedule status."
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "Network error: $e"
      };
    }
  }
}