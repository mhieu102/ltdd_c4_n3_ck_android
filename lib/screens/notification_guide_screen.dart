import 'package:flutter/material.dart';

class NotificationGuideScreen extends StatelessWidget {
  const NotificationGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hướng dẫn thông báo'),
      ),
      body: Center(
        child: const Text(
          'Nội dung hướng dẫn cho thông báo.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}