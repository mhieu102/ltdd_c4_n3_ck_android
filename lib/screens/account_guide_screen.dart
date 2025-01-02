import 'package:flutter/material.dart';

class AccountGuideScreen extends StatelessWidget {
  const AccountGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hướng dẫn tài khoản'),
      ),
      body: Center(
        child: const Text(
          'Nội dung hướng dẫn cho tài khoản.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}