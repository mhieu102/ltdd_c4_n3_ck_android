import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      body: Center(
        child: const Text(
          'Nội dung hướng dẫn cho tài khoản.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}