import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../services/admin_service.dart';

class SendNotificationScreen extends StatefulWidget {
  const SendNotificationScreen({Key? key}) : super(key: key);

  @override
  State<SendNotificationScreen> createState() => _SendNotificationScreenState();
}

class _SendNotificationScreenState extends State<SendNotificationScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _receiverController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final AdminService _adminService = AdminService();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _sendNotification() async {
    setState(() {
      _isLoading = true;
    });

    final result = await _adminService.sendNotification(
      receiverName: _receiverController.text,
      message: _messageController.text,
      title: _titleController.text,
    );

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result['success'] ? 'Gửi thông báo thành công!' : 'Gửi thông báo thất bại!',
          style: GoogleFonts.roboto(color: Colors.white),
        ),
        backgroundColor: result['success'] ? Colors.green : Colors.red,
      ),
    );

    if (result['success']) {
      _receiverController.clear();
      _messageController.clear();
      _titleController.clear();
    }
  }

  Future<void> _sendNotificationToAllDrivers() async {
    if (_titleController.text.isEmpty || _messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Vui lòng nhập tiêu đề và nội dung thông báo.',
            style: GoogleFonts.roboto(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final result = await _adminService.sendNotificationToAllDrivers(
      title: _titleController.text,
      message: _messageController.text,
    );

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result['success'] ? 'Gửi thông báo đến tất cả tài xế thành công!' : 'Gửi thông báo thất bại!',
          style: GoogleFonts.roboto(color: Colors.white),
        ),
        backgroundColor: result['success'] ? Colors.green : Colors.red,
      ),
    );

    if (result['success']) {
      _messageController.clear();
      _titleController.clear();
    }
  }

  Widget _buildSendToDriverForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _receiverController,
            decoration: InputDecoration(
              labelText: 'Tên người nhận (receiverName)',
              labelStyle: GoogleFonts.roboto(fontSize: 16, color: Colors.orange[800]),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Tiêu đề thông báo',
              labelStyle: GoogleFonts.roboto(fontSize: 16, color: Colors.orange[800]),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _messageController,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: 'Nội dung thông báo',
              labelStyle: GoogleFonts.roboto(fontSize: 16, color: Colors.orange[800]),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(height: 16),
          _isLoading
              ? const Center(
            child: SpinKitCircle(color: Colors.orange),
          )
              : ElevatedButton(
            onPressed: _sendNotification,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Gửi thông báo'),
          ),
        ],
      ),
    );
  }

  Widget _buildSendToAllDriversForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Tiêu đề thông báo',
              labelStyle: GoogleFonts.roboto(fontSize: 16, color: Colors.orange[800]),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _messageController,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: 'Nội dung thông báo',
              labelStyle: GoogleFonts.roboto(fontSize: 16, color: Colors.orange[800]),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(height: 16),
          _isLoading
              ? const Center(
            child: SpinKitCircle(color: Colors.orange),
          )
              : ElevatedButton(
            onPressed: _sendNotificationToAllDrivers,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Gửi đến tất cả tài xế'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý thông báo'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.person), text: 'Gửi đến 1 tài xế'),
            Tab(icon: Icon(Icons.group), text: 'Gửi đến tất cả tài xế'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSendToDriverForm(),
          _buildSendToAllDriversForm(),
        ],
      ),
    );
  }
}
