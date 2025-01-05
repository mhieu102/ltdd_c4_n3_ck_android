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

  // Tạo ngẫu nhiên một lịch trình
  Future<Map<String, dynamic>> generateRandomSchedule() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt_token');

      if (token == null) {
        return {"success": false, "message": "Authentication token not found."};
      }

      final uri = Uri.parse("${Config_URL.baseUrl}schedule/generate_random_schedule");

      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        bool status = data['status'];
        return {
          "success": status,
          "message": data['message'],
        };
      } else {
        return {"success": false, "message": "Failed to generate random schedule."};
      }
    } catch (e) {
      return {"success": false, "message": "Network error: $e"};
    }
  }

  // Xác nhận lịch trình dựa vào ID
  Future<Map<String, dynamic>> toggleScheduleConfirmation(String idSchedule) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt_token');

      if (token == null) {
        return {"success": false, "message": "Authentication token not found."};
      }

      final uri = Uri.parse("${Config_URL.baseUrl}schedule/toggle_schedule_confirmation")
          .replace(queryParameters: {"idSchedule": idSchedule});

      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        bool status = data['status'];
        return {
          "success": status,
          "message": data['message'],
        };
      } else {
        return {"success": false, "message": "Failed to toggle schedule confirmation."};
      }
    } catch (e) {
      return {"success": false, "message": "Network error: $e"};
    }
  }


  // Lấy danh sách tất cả lịch trình
  Future<Map<String, dynamic>> getAllSchedules() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt_token');

      if (token == null) {
        return {"success": false, "data": [], "message": "Authentication token not found."};
      }

      final uri = Uri.parse("${Config_URL.baseUrl}schedule/get_all_schedules");

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
            "data": data['data'] ?? [],
            "message": data['message'] ?? "Lịch trình đã được tải thành công."
          };
        } else {
          return {
            "success": false,
            "data": [],
            "message": data['message'] ?? "Không thể tải danh sách lịch trình."
          };
        }
      } else {
        return {
          "success": false,
          "data": [],
          "message": "Lỗi Server, không thể tải danh sách lịch trình."
        };
      }
    } catch (e) {
      return {
        "success": false,
        "data": [],
        "message": "Network error: $e"
      };
    }
  }

  // Xóa Lịch trình
  Future<Map<String, dynamic>> deleteSchedule(String idSchedule) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt_token');

      if (token == null) {
        return {
          "success": false,
          "message": "Authentication token not found."
        };
      }

      final uri = Uri.parse("${Config_URL.baseUrl}schedule/delete_schedule")
          .replace(queryParameters: {"idSchedule": idSchedule});

      final response = await http.delete(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        bool status = data['status'];
        return {
          "success": status,
          "message": data['message'],
        };
      } else {
        return {"success": false, "message": "Xóa lịch trình thất bại."};
      }
    } catch (e) {
      return {"success": false, "message": "Network error: $e"};
    }
  }

  Future<Map<String, dynamic>> adminRegister({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
    required String phoneNumber,
    required String fullName,
    required String address,
    required String gender,
    required String? dateOfBirth,
    required String classOfDriverLicense,
    required String role,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt_token');

      if (token == null) {
        return {
          "status": false,
          "message": "Authentication token not found."
        };
      }

      final uri = Uri.parse("${Config_URL.baseUrl}authenticate/admin_register")
          .replace(queryParameters: {
        "role": role, // Truyền vai trò vào
      });

      final response = await http.post(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "Username": username,
          "Email": email,
          "Password": password,
          "ConfirmPassword": confirmPassword,
          "PhoneNumber": phoneNumber,
          "FullName": fullName,
          "Address": address,
          "Gender": gender,
          "DateOfBirth": dateOfBirth,
          "ClassOfDriverLicense": classOfDriverLicense,
        }),
      );

      if (response.statusCode == 200) {
        // Trả về kết quả với cấu trúc đúng
        final responseBody = jsonDecode(response.body);
        return {
          "status": responseBody['status'],
          "message": responseBody['message'],
        };
      } else {
        print("Response body: ${response.body}");
        return {
          "status": false,
          "message": "Đăng ký không thành công. Vui lòng kiểm tra lại."
        };
      }
    } catch (e) {
      return {
        "status": false,
        "message": "Lỗi mạng: $e"
      };
    }
  }

  //Xóa User
  Future<Map<String, dynamic>> deleteUser(String userId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt_token');

      if (token == null) {
        return {
          "success": false,
          "message": "Authentication token not found."
        };
      }

      final uri = Uri.parse("${Config_URL.baseUrl}user/delete")
          .replace(queryParameters: {"id": userId}); // Thêm ID vào query parameters

      final response = await http.delete(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        bool status = data['status'];
        return {
          "success": status,
          "message": data['message'],
        };
      } else {
        return {"success": false, "message": "Failed to delete user."};
      }
    } catch (e) {
      return {"success": false, "message": "Network error: $e"};
    }
  }
}
