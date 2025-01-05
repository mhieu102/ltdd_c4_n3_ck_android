import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/admin_service.dart';

class DriverDetailScreen extends StatefulWidget {
  final String driverId;
  const DriverDetailScreen({Key? key, required this.driverId}) : super(key: key);

  @override
  State<DriverDetailScreen> createState() => _DriverDetailScreenState();
}

class _DriverDetailScreenState extends State<DriverDetailScreen> {
  late Future<Map<String, dynamic>> _driverFuture;
  final AdminService _adminService = AdminService();

  @override
  void initState() {
    super.initState();
    _driverFuture = _adminService.fetchDriverById(widget.driverId);
  }

  Future<void> _deleteUser() async {
    final result = await _adminService.deleteUser(widget.driverId);
    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Xóa tài xế thành công!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi: ${result['message']}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết tài xế'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Xóa tài xế'),
                  content: const Text('Bạn có chắc chắn muốn xóa tài xế này?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Hủy'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Đóng hộp thoại
                        _deleteUser(); // Gọi phương thức xóa
                      },
                      child: const Text('Xóa'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _driverFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.orange),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Lỗi: ${snapshot.error}',
                style: GoogleFonts.roboto(color: Colors.red, fontSize: 16),
              ),
            );
          } else if (snapshot.hasData && snapshot.data!['success']) {
            final driver = snapshot.data!['data'];
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    driver['fullName'] ?? 'Không có tên',
                    style: GoogleFonts.roboto(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    leading: const Icon(Icons.person, color: Colors.orange),
                    title: Text(driver['userName'] ?? 'Không có username'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.phone, color: Colors.orange),
                    title: Text(driver['phoneNumber'] ?? 'Không có số điện thoại'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.email, color: Colors.orange),
                    title: Text(driver['email'] ?? 'Không có email'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.home, color: Colors.orange),
                    title: Text(driver['address'] ?? 'Không có địa chỉ'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.perm_identity, color: Colors.orange),
                    title: Text(driver['classOfDriverLicense'] ?? 'Không có bằng lái'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.cake, color: Colors.orange),
                    title: Text(driver['dateOfBirth'] ?? 'Không có ngày sinh'),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text(
                'Không có dữ liệu tài xế',
                style: TextStyle(fontSize: 16),
              ),
            );
          }
        },
      ),
    );
  }
}