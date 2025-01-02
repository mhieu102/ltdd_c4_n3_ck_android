import 'package:flutter/material.dart';

class ScheduleGuideScreen extends StatelessWidget {
  const ScheduleGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hướng dẫn lịch trình'),
      ),
      body: Center(
        child: const Text(
          'Nội dung hướng dẫn cho lịch trình.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}