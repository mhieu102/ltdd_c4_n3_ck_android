import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/home_service.dart';
import '../screens/login_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late Future<Map<String, dynamic>> _userInfoFuture;

  @override
  void initState() {
    super.initState();
    _userInfoFuture = HomeService.fetchUserInfo();
  }

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Thông tin tài khoản",
          style: GoogleFonts.roboto(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _userInfoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.orange),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Lỗi khi tải thông tin: ${snapshot.error}",
                style: GoogleFonts.roboto(color: Colors.red, fontSize: 16),
              ),
            );
          } else if (snapshot.hasData && snapshot.data!['data'] != null) {
            final userInfo = snapshot.data!['data'] as Map<String, dynamic>;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Avatar và tên người dùng
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.orange[100],
                          child: const FaIcon(
                            FontAwesomeIcons.user,
                            size: 60,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          userInfo['fullName'] ?? "Chưa cập nhật",
                          style: GoogleFonts.roboto(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          userInfo['email'] ?? "Chưa cập nhật",
                          style: GoogleFonts.roboto(color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Các thông tin chi tiết
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(
                          label: "Địa chỉ",
                          value: userInfo['address'],
                          icon: FontAwesomeIcons.locationDot,
                        ),
                        _buildInfoRow(
                          label: "Giới tính",
                          value: userInfo['gender'],
                          icon: FontAwesomeIcons.venusMars,
                        ),
                        _buildInfoRow(
                          label: "Ngày sinh",
                          value: userInfo['dateOfBirth'],
                          icon: FontAwesomeIcons.calendarDays,
                        ),
                        _buildInfoRow(
                          label: "Số điện thoại",
                          value: userInfo['phoneNumber'],
                          icon: FontAwesomeIcons.phone,
                        ),
                        _buildInfoRow(
                          label: "Tên đăng nhập",
                          value: userInfo['userName'],
                          icon: FontAwesomeIcons.user,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Nút Đăng xuất
                  ElevatedButton.icon(
                    onPressed: () => _logout(context),
                    icon: const Icon(FontAwesomeIcons.signOutAlt, color: Colors.white),
                    label: const Text("Đăng xuất"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      textStyle: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text("Không có dữ liệu người dùng"),
            );
          }
        },
      ),
    );
  }

  Widget _buildInfoRow({required String label, required String? value, required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FaIcon(icon, color: Colors.orange, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '$label: ${value ?? "Chưa cập nhật"}',
              style: GoogleFonts.roboto(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
