import 'package:flutter/material.dart';
import 'account_guide_screen.dart'; // Import trang hướng dẫn tài khoản
import 'schedule_guide_screen.dart'; // Import trang hướng dẫn lịch trình
import 'notification_guide_screen.dart'; // Import trang hướng dẫn thông báo

class DriverGuideScreen extends StatelessWidget {
  const DriverGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hướng dẫn cho tài xế'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Hướng dẫn cho tài xế',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text(
                'Hướng dẫn cho Tài xế là một tài nguyên thiết yếu dành cho những người lái xe, giúp họ nắm vững các kỹ năng và kiến thức cần thiết để vận hành phương tiện một cách an toàn và hiệu quả. Trang này cung cấp thông tin chi tiết về quy tắc giao thông, mẹo lái xe an toàn, và các tình huống có thể gặp phải trên đường. Ngoài ra, người dùng cũng có thể tìm thấy các video hướng dẫn trực quan, giúp cải thiện khả năng lái xe của mình. Hãy khám phá và trang bị cho mình những kiến thức hữu ích để trở thành một tài xế tự tin và an toàn!.',
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
                child: const Text('Hướng dẫn tài khoản'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ScheduleGuideScreen()),
                  );
                },
                child: const Text('Hướng dẫn lịch trình'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NotificationGuideScreen()),
                  );
                },
                child: const Text('Hướng dẫn thông báo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}