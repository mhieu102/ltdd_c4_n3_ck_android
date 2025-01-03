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
  // Lấy danh sách thông báo đã đọc
  Future<Map<String, dynamic>> fetchReadNotifications() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt_token');

      if (token == null) {
        return {"success": false, "data": []};
      }

      final uri = Uri.parse("${Config_URL.baseUrl}notification/read");

      final response = await http.get(uri, headers: {
        "Authorization": "Bearer $token",
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        print('Read Notifications Raw: $data');

        if (data['status'] == true) {
          return {
            "success": true,
            "data": data['notifications'] ?? [],
          };
        }
      }

      return {"success": false, "data": []};
    } catch (e) {
      print('Error fetching read notifications: $e');
      return {"success": false, "data": []};
    }
  }


  // Lấy danh sách thông báo chưa đọc
  Future<Map<String, dynamic>> fetchUnreadNotifications() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt_token');

      if (token == null) {
        return {"success": false, "data": []};
      }

      final uri = Uri.parse("${Config_URL.baseUrl}notification/unread");

      final response = await http.get(uri, headers: {
        "Authorization": "Bearer $token",
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        print('Unread Notifications Raw: $data');

        if (data['status'] == true) {
          return {
            "success": true,
            "data": data['notifications'] ?? [],
          };
        }
      }

      return {"success": false, "data": []};
    } catch (e) {
      print('Error fetching unread notifications: $e');
      return {"success": false, "data": []};
    }
  }
  // Lấy danh sách tài xế
  Future<Map<String, dynamic>> fetchDrivers() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt_token');

      if (token == null) {
        return {
          "success": false,
          "data": [],
          "message": "Authentication token not found."
        };
      }

      final uri = Uri.parse("${Config_URL.baseUrl}user/drivers");

      final response = await http.get(uri, headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        print('Fetched Drivers Raw: $data');

        if (data['status'] == true) {
          return {
            "success": true,
            "data": data['data'],
            "message": data['data'].isEmpty
                ? "Không có tài xế nào trong hệ thống."
                : "Tài xế được tải thành công."
          };
        } else {
          return {
            "success": false,
            "data": [],
            "message": "Không thể tải danh sách tài xế."
          };
        }
      } else {
        return {
          "success": false,
          "data": [],
          "message": "Server error, failed to fetch drivers."
        };
      }
    } catch (e) {
      print('Error fetching drivers: $e');
      return {
        "success": false,
        "data": [],
        "message": "Network error: $e"
      };
    }
  }

  // Lấy chi tiết tài xế theo ID
  Future<Map<String, dynamic>> fetchDriverById(String driverId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt_token');

      if (token == null) {
        return {
          "success": false,
          "data": {},
          "message": "Authentication token not found."
        };
      }

      final uri = Uri.parse("${Config_URL.baseUrl}user/driver/byId")
          .replace(queryParameters: {"id": driverId});

      final response = await http.get(uri, headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        print('Fetched Driver Details Raw: $data');

        if (data['status'] == true) {
          return {
            "success": true,
            "data": data['data'],
            "message": "Chi tiết tài xế được tải thành công."
          };
        } else {
          return {
            "success": false,
            "data": {},
            "message": "Không tìm thấy tài xế."
          };
        }
      } else {
        return {
          "success": false,
          "data": {},
          "message": "Server error, failed to fetch driver details."
        };
      }
    } catch (e) {
      print('Error fetching driver by ID: $e');
      return {
        "success": false,
        "data": {},
        "message": "Network error: $e"
      };
    }
  }


}
