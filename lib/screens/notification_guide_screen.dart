import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'notification_screen.dart';

class NotificationGuideScreen extends StatelessWidget {
  const NotificationGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Hướng dẫn thông báo",
          style: GoogleFonts.roboto(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          _buildRow('Thông báo đến quản trị viên', 'Hiển thị trang gửi thông báo đến quản trị viên ', 'assets/thongbao.png', true),
          _buildRow('', 'B1: Nhập tiêu đề thông báo, ví dụ: Yêu cầu thay đổi lịch trình', 'assets/thongbao1.png', true),
          _buildRow('', 'B2: Nhập nội dung thông báo, ví dụ: Tuyến đường phía trước đang xảy ra tai nạn giao thông tắt nghẽn nghiêm trọng', 'assets/thongbao2.png', true),
          _buildRow('', 'B3: Kiểm tra lại báo cáo sau đó nhấn nút "Gửi thông báo" để gửi đến cho quản trị viên ', 'assets/thongbao3.png', true),
          const Divider(),
          _buildRow('Nhận thông báo từ quản trị viên', 'Sau khi quản trị viên xem xét và sẽ gửi thông báo đến cho tài xế', 'assets/thongbao4.png', false),
          const Divider(),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationScreen()),
              );
            },
            child: Text(
              "Đến trang thông báo ",
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