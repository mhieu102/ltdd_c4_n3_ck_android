import 'package:flutter/material.dart';

class DriverDetailScreen extends StatelessWidget {
  final Map<String, dynamic> userInfo;

  const DriverDetailScreen({required this.userInfo, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('User Info: $userInfo');

    // Lấy dữ liệu chi tiết từ userInfo['data']
    final data = userInfo['data'] ?? {};

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết tài xế'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Ảnh đại diện và thông tin chính
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.orange[100],
                    child: const Icon(Icons.person, size: 50, color: Colors.orange),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    data['fullName'] ?? 'Không có dữ liệu',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    data['email'] ?? 'Không có dữ liệu',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Thông tin chi tiết
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
                  _buildInfoRow(Icons.location_on, 'Địa chỉ:', data['address']),
                  _buildInfoRow(Icons.person_outline, 'Giới tính:', data['gender']),
                  _buildInfoRow(Icons.cake, 'Ngày sinh:', data['dateOfBirth']),
                  _buildInfoRow(Icons.credit_card, 'Loại bằng lái:', data['classOfDriverLicense']),
                  _buildInfoRow(Icons.phone, 'Số điện thoại:', data['phoneNumber']),
                  _buildInfoRow(Icons.account_circle, 'Tên đăng nhập:', data['userName']),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                child: Text(
                  'Quay lại',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Hàm tạo các dòng thông tin chi tiết
  Widget _buildInfoRow(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value ?? 'Không có dữ liệu',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
