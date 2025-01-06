import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'account_guide_screen.dart';
import 'schedule_guide_screen.dart';
import 'notification_guide_screen.dart';

class DriverGuideScreen extends StatelessWidget {
  const DriverGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Hướng dẫn cho tài xế",
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
              const Text(
                'Trang hướng dẫn dành cho tài xế',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Image.asset(
                'assets/huongdantc.png',
                height: 170,
                fit: BoxFit.cover,
              ),
              const Text(
                'Hướng dẫn cho Tài xế là một tài nguyên thiết yếu dành'
                    ' cho những người lái xe, giúp họ nắm vững các kỹ năng'
                    ' và kiến thức cần thiết để vận hành phương tiện một cách'
                    ' an toàn và hiệu quả.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AccountGuideScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent, // Màu nền trong suốt
                  elevation: 0, // Không có bóng
                  side: BorderSide(color: Colors.orange, width: 2), // Khung màu cam
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Bo tròn góc
                  ),
                ).copyWith(
                  // Tùy chỉnh trạng thái hover
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.hovered)) {
                        return Colors.orange.withOpacity(0.2); // Màu nền khi hover
                      }
                      return Colors.transparent; // Màu mặc định
                    },
                  ),
                ),
                child: const Text(
                  'Xem hướng dẫn tài khoản',
                  style: TextStyle(
                    fontSize: 16, // Kích thước chữ
                    color: Colors.orange, // Màu chữ
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ScheduleGuideScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent, // Màu nền trong suốt
                  elevation: 0, // Không có bóng
                  side: BorderSide(color: Colors.orange, width: 2), // Khung màu cam
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Bo tròn góc
                  ),
                ).copyWith(
                  // Tùy chỉnh trạng thái hover
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.hovered)) {
                        return Colors.orange.withOpacity(0.2); // Màu nền khi hover
                      }
                      return Colors.transparent; // Màu mặc định
                    },
                  ),
                ),
                child: const Text(
                  'Xem hướng dẫn lịch trình',
                  style: TextStyle(
                    fontSize: 16, // Kích thước chữ
                    color: Colors.orange, // Màu chữ
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NotificationGuideScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent, // Màu nền trong suốt
                  elevation: 0, // Không có bóng
                  side: BorderSide(color: Colors.orange, width: 2), // Khung màu cam
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Bo tròn góc
                  ),
                ).copyWith(
                  // Tùy chỉnh trạng thái hover
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.hovered)) {
                        return Colors.orange.withOpacity(0.2); // Màu nền khi hover
                      }
                      return Colors.transparent; // Màu mặc định
                    },
                  ),
                ),
                child: const Text(
                  'Xem hướng dẫn thông báo',
                  style: TextStyle(
                    fontSize: 16, // Kích thước chữ
                    color: Colors.orange, // Màu chữ
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}