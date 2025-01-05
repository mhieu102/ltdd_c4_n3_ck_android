import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'account_screen.dart';
import 'driver_detail_screen.dart';

class AccountGuideScreen extends StatelessWidget {
  const AccountGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Hướng dẫn thao tác tài khoản",
          style: GoogleFonts.roboto(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          _buildRow('Thông tin người dùng', 'Hiển thị chi tiết thông tin người dùng ', 'assets/thongtinnguoidung.png', true),
          const Divider(),
          _buildRow('Thay đổi mật khẩu', 'B1: Bấm vào nút đổi mật khẩu', 'assets/doimk1.png', false),
          _buildRow('', 'B2: Nnhập "mật khẩu cũ, mật khẩu mới, xác nhận mật khẩu mới" sau đó nhấn "Xác nhận"', 'assets/doimk2.png', false),
          const Divider(),
          _buildRow('Chỉnh sửa thông tin người dùng', 'B1: Nhìn lên phía trên bên phải chọn vào icon trên hình', 'assets/chinhsuatt1.png', true),
          _buildRow('', 'B2: Tiến hành thay đổi thông tin người dùng và sau đó nhấn icon "lưu"', 'assets/chinhsuatt2.png', true),
          const Divider(),
          // ElevatedButton(
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => DriverDetailScreen(userInfo: {},)), // Thay AccountScreen() bằng tên của widget trang chỉnh sửa
          //     );
          //   },
          //   child: Text("Đến trang chỉnh sửa"),
          // ),
          // Nút để chuyển đến trang đổi mật khẩu
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccountScreen()),
              );
            },
            child: Text(
              "Đến trang đổi mật khẩu",
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
          // const Divider(),
          // _buildRow('Nội dung 7', 'Nội dung phụ cho 7', 'assets/image7.png', true),
          // const Divider(),
          // _buildRow('Nội dung 8', 'Nội dung phụ cho 8', 'assets/image8.png', false),
          // const Divider(),
          // _buildRow('Nội dung 9', 'Nội dung phụ cho 9', 'assets/image9.png', true),
          // const Divider(),
          // _buildRow('Nội dung 10', 'Nội dung phụ cho 10', 'assets/image10.png', false),
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