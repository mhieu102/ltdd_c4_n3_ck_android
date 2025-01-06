import 'package:flutter/material.dart';
import '../services/home_service.dart';
import 'driver_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = 'Người dùng'; // Biến lưu tên người dùng
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    try {
      final userInfo = await HomeService.fetchUserInfo();
      if (userInfo.isNotEmpty) {
        setState(() {
          userName = userInfo['data']['fullName'] ?? 'Người dùng';
        });
      } else {
        setState(() {
          userName = 'Người dùng';
        });
      }
    } catch (e) {
      print('Lỗi khi lấy thông tin người dùng: $e');
      setState(() {
        userName = 'Người dùng';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/backgroundhome.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Foreground content
          Column(
            children: [
              Container(
                color: Colors.orange.withOpacity(0.8),
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        // Xử lý sự kiện nhấn vào avatar
                        bool isLoading = false;
                        if (isLoading) return;
                        isLoading = true;
                        try {
                          final userInfo = await HomeService.fetchUserInfo();
                          if (userInfo.isNotEmpty) {
                            if (context.mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DriverDetailScreen(userInfo: userInfo),
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Không thể lấy thông tin người dùng'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Đã xảy ra lỗi: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } finally {
                          isLoading = false;
                        }
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 24,
                        child: const Icon(Icons.person, color: Colors.orange),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Xin chào,',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        isLoading
                            ? const CircularProgressIndicator() // Hiển thị vòng loading
                            : Text(
                          userName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const Icon(Icons.qr_code, color: Colors.white),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12), // Bo tròn góc
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12), // Bo tròn góc
                  child: Image.asset(
                    'assets/hinhgt1.png', // Đường dẫn đến hình ảnh
                    height: 170, // Chiều cao của hình ảnh
                    fit: BoxFit.cover, // Cách hình ảnh được hiển thị
                  ),
                ),
              ),

              // Khung cho phần nội dung
              Container(
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white, // Màu nền của khung
                  borderRadius: BorderRadius.circular(12), // Bo tròn các góc
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: const Offset(0, 2), // Đổ bóng phía dưới
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Căn trái cho các cột
                  children: [
                    const SizedBox(height: 8),
                    const Text(
                      'Chúc bạn lái xe an toàn và bình an trên mọi nẻo đường! Luôn giữ được tinh thần tỉnh táo trong suốt hành trình!',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      textAlign: TextAlign.justify, // Căn đều hai bên
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.orange[100],
          radius: 24,
          child: Icon(icon, size: 30, color: Colors.orange),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 16, color: Colors.black)),
      ],
    );
  }

  Widget _buildFeatureButton(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.orange[100],
          radius: 32,
          child: Icon(icon, size: 35, color: Colors.orange),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.black),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}