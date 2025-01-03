import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'account_guide_screen.dart'; // Import trang hướng dẫn tài khoản
import 'schedule_guide_screen.dart'; // Import trang hướng dẫn lịch trình
import 'notification_guide_screen.dart'; // Import trang hướng dẫn thông báo
import 'custom_info_windows.dart'; // Import màn hình bản đồ (thêm nếu cần)

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Lịch trình đường đi",
          style: GoogleFonts.roboto(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Thực hiện hành động, ví dụ mở bản đồ
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HutechMap()),
          );
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.map), // Logo bản đồ
      ),
    );
  }
}