import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/admin_service.dart';
import 'driver_detail_screen.dart';
import 'register_for_admin_screen.dart';

class DriverListScreen extends StatefulWidget {
  const DriverListScreen({Key? key}) : super(key: key);

  @override
  State<DriverListScreen> createState() => _DriverListScreenState();
}

class _DriverListScreenState extends State<DriverListScreen> {
  final AdminService _adminService = AdminService();
  late Future<Map<String, dynamic>> _driversFuture;

  @override
  void initState() {
    super.initState();
    _fetchDrivers();
  }

  void _fetchDrivers() {
    setState(() {
      _driversFuture = _adminService.fetchDrivers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách tài xế'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Map<String, dynamic>>(
          future: _driversFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.orange),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Lỗi khi tải danh sách tài xế: ${snapshot.error}',
                  style: GoogleFonts.roboto(color: Colors.red),
                ),
              );
            } else if (snapshot.hasData && snapshot.data!['data'].isNotEmpty) {
              final drivers = snapshot.data!['data'];
              return ListView.builder(
                itemCount: drivers.length,
                itemBuilder: (context, index) {
                  final driver = drivers[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.orange,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      title: Text(
                        driver['userName'] ?? 'Không có tên người dùng',
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            driver['phoneNumber'] ?? 'Không có số điện thoại',
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            driver['fullName'] ?? 'Không có tên',
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DriverDetailScreen(driverId: driver['id'].toString()),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text(
                  snapshot.data!['message'] ?? 'Không có tài xế nào.',
                  style: GoogleFonts.roboto(fontSize: 16, color: Colors.black54),
                ),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegisterForAdmin()),
          );
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
      ),
    );
  }
}
