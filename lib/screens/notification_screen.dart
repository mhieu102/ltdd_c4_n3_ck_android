import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../services/notification_user_service.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final NotificationUserService _notificationUserService = NotificationUserService();

  bool _isLoading = false;
  late Future<List<Map<String, dynamic>>> _receivedNotificationsFuture;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  void _fetchNotifications() {
    _receivedNotificationsFuture = _notificationUserService.getReceivedNotifications().then((notifications) {
      return notifications.reversed.toList();
    });
  }

  Future<void> _sendNotificationToAdmin() async {
    setState(() {
      _isLoading = true;
    });

    final result = await _notificationUserService.sendNotificationToAdmin(
      title: _titleController.text,
      message: _messageController.text,
    );

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result['success'] ? 'Thông báo đã được gửi đến quản trị viên!' : 'Gửi thông báo thất bại!',
          style: GoogleFonts.roboto(color: Colors.white),
        ),
        backgroundColor: result['success'] ? Colors.green : Colors.red,
      ),
    );

    if (result['success']) {
      _titleController.clear();
      _messageController.clear();
      _fetchNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý thông báo'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gửi thông báo đến quản trị viên',
              style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Tiêu đề thông báo',
                labelStyle: GoogleFonts.roboto(fontSize: 16, color: Colors.orange[800]),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.orange, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
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
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.orange, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _isLoading
                ? const Center(
              child: SpinKitCircle(color: Colors.orange),
            )
                : ElevatedButton(
              onPressed: _sendNotificationToAdmin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              ),
              child: const Text(
                'Gửi thông báo',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Thông báo đã nhận',
              style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _receivedNotificationsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: Colors.orange));
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Lỗi khi tải thông báo: ${snapshot.error}',
                        style: GoogleFonts.roboto(color: Colors.red),
                      ),
                    );
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    final notifications = snapshot.data!;

                    return ListView.separated(
                      itemCount: notifications.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final notification = notifications[index];
                        return ListTile(
                          title: Text(
                            notification['title'] ?? 'Không có tiêu đề',
                            style: GoogleFonts.roboto(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            notification['description'] ?? 'Không có nội dung',
                            style: GoogleFonts.roboto(color: Colors.black54),
                          ),
                          leading: const Icon(Icons.notifications, color: Colors.orange),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text('Không có thông báo nào.'),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
