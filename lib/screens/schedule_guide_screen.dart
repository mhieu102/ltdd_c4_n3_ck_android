import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'schedule_screen.dart';

class ScheduleGuideScreen extends StatelessWidget {
  const ScheduleGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Hướng dẫn lịch trình",
          style: GoogleFonts.roboto(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          _buildRow('Hướng dẫn lịch trình', 'Hiển thị lịch trình "Đã duyệt" và "Chưa duyệt" nhận được từ quản trị viên ', 'assets/lichtrinh.png', true),
          const Divider(),
          _buildRow('Bắt đầu di chuyển', 'Nhấn nút "Bắt đầu" để di chuyển', 'assets/lichtrinh2.png', false),
          const Divider(),
          _buildRow('Giao hàng thành công', 'Khi giao hàng thành công nhấn "Hoàn thành" để kết thúc chuyến đi', 'assets/lichtrinh5.png', true),
          const Divider(),
          _buildRow('Khi gặp sự cố', 'Khi gặp sự cổ xảy ra trong chuyến đi nhấn "Tạm hoãn" để khắc phục sự cố " ', 'assets/lichtrinh3.png', false),
          const Divider(),
          _buildRow('Khi giao hàng không thành công', 'Sau khi giao hàng không thành công nhấn "Thất bại"', 'assets/lichtrinh4.png', true),
          const Divider(),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ScheduleScreen()),
              );
            },
            child: Text(
              "Đến trang lịch trình ",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange, // Màu nền
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.orange, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String title, String subtitle, String imagePath, bool isLeft) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: isLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: [
            if (isLeft) ...[
              Image.asset(imagePath, width: 200, height: 250), // Thay đổi kích thước theo nhu cầu
              SizedBox(width: 0), // Khoảng cách giữa ảnh và nội dung
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      softWrap: true, // Cho phép xuống dòng
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                      softWrap: true, // Cho phép xuống dòng
                    ),
                  ],
                ),
              ),
            ] else ...[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      softWrap: true, // Cho phép xuống dòng
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 14, color: Colors.black),
                      softWrap: true, // Cho phép xuống dòng
                    ),
                  ],
                ),
              ),
              SizedBox(width: 0), // Khoảng cách giữa nội dung và ảnh
              Image.asset(imagePath, width: 200, height: 250), // Thay đổi kích thước theo nhu cầu
            ],
          ],
        ),
      ],
    );
  }
}