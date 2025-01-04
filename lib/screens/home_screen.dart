import 'package:flutter/material.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

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
            decoration: BoxDecoration(
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
                padding: EdgeInsets.all(16.0),
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
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Xin chào,',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        isLoading
                            ? CircularProgressIndicator() // Hiển thị vòng loading
                            : Text(
                          userName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Icon(Icons.qr_code, color: Colors.white),
                  ],
                ),
              ),
              // Phần còn lại của giao diện
              Container(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildMenuButton(Icons.attach_money, 'Nạp tiền'),
                    _buildMenuButton(Icons.money_off, 'Rút tiền'),
                    _buildMenuButton(Icons.account_balance_wallet, 'FUTAPay'),
                  ],
                ),
              ),
              Divider(color: Colors.white),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                  padding: EdgeInsets.all(8.0),
                  children: [
                    _buildFeatureButton(Icons.directions_bus, 'Mua vé xe'),
                    _buildFeatureButton(Icons.local_taxi, 'Gọi TAXI'),
                    _buildFeatureButton(Icons.car_rental, 'Gọi Ô Tô'),
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
        SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 16, color: Colors.black)),
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
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: 16, color: Colors.black),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}