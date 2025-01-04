import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/schedule_service.dart';
import 'custom_info_windows.dart'; // Import màn hình bản đồ (thêm nếu cần)

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  List<dynamic> _schedules = [];
  bool _isLoading = true;
  bool _showConfirmed = true; // Trạng thái hiển thị

  @override
  void initState() {
    super.initState();
    _fetchSchedules();
  }

  Future<void> _fetchSchedules() async {
    final scheduleService = ScheduleService();
    final result = await scheduleService.getDriverSchedulesByStatus(_showConfirmed);
    if (result['success']) {
      setState(() {
        _schedules = result['schedules'];
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleFilter(bool isConfirmed) {
    setState(() {
      _showConfirmed = isConfirmed;
      _isLoading = true;
    });
    _fetchSchedules(); // Gọi lại để lấy danh sách lịch trình mới
  }

  Future<void> _updateScheduleStatus(String scheduleId, String status) async {
    final scheduleService = ScheduleService();
    final result = await scheduleService.updateScheduleStatus(scheduleId, status);
    if (result['success']) {
      // Cập nhật lại danh sách lịch trình
      _fetchSchedules();
      // Hiển thị thông báo thành công
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Trạng thái đã được cập nhật thành công: $status"),
        duration: const Duration(seconds: 2),
      ));
    } else {
      // Xử lý lỗi nếu cần
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Lỗi: ${result['message']}"),
        duration: const Duration(seconds: 2),
      ));
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'InProgress':
        return Colors.green; // Màu xanh cho trạng thái đang tiến hành
      case 'Completed':
        return Colors.blue; // Màu xanh dương cho trạng thái đã hoàn thành
      case 'Pending':
        return Colors.orange; // Màu cam cho trạng thái tạm hoãn
      case 'Failed':
        return Colors.red; // Màu đỏ cho trạng thái thất bại
      default:
        return Colors.white; // Màu trắng cho trạng thái mặc định
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Lịch trình đường đi",
          style: GoogleFonts.roboto(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Bộ lọc
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () => _toggleFilter(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _showConfirmed ? Colors.orange : Colors.grey,
                    ),
                    child: const Text("Đã Duyệt"),
                  ),
                  ElevatedButton(
                    onPressed: () => _toggleFilter(false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !_showConfirmed ? Colors.orange : Colors.grey,
                    ),
                    child: const Text("Chưa Duyệt"),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Danh sách lịch trình
              _isLoading
                  ? const CircularProgressIndicator()
                  : _schedules.isNotEmpty
                  ? Expanded(
                child: ListView.builder(
                  itemCount: _schedules.length,
                  itemBuilder: (context, index) {
                    final schedule = _schedules[index];
                    final bool isStarted = schedule['status'] == 'InProgress';
                    final bool isPending = schedule['status'] == 'Pending';

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        children: [
                          Container(
                            color: _getStatusColor(schedule['status']),
                            child: ListTile(
                              title: Text(schedule['driverName']),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Chi phí: \$${schedule['shippingCost'].toStringAsFixed(2)}'),
                                  Text('Địa điểm xuất phát: ${schedule['pickupLocation']}'),
                                  Text('Địa điểm đến: ${schedule['deliveryLocation']}'),
                                  Text('Hàng hóa: ${schedule['goodsName']}'),
                                  Text('Trạng thái: ${schedule['status']}'),
                                ],
                              ),
                            ),
                          ),
                          // Nút để bắt đầu lịch trình
                          if (schedule['status'] == 'NotStarted' && schedule['isConfirmed'] == true)
                            ElevatedButton(
                              onPressed: () => _updateScheduleStatus(schedule['id'].toString(), 'InProgress'),
                              child: const Text("Bắt Đầu"),
                            ),
                          // Nút để bắt đầu lại nếu đang tạm hoãn
                          if (isPending)
                            ElevatedButton(
                              onPressed: () => _updateScheduleStatus(schedule['id'].toString(), 'InProgress'),
                              child: const Text("Bắt Đầu Lại"),
                            ),
                          // Nút để cập nhật trạng thái nếu đang InProgress
                          if (isStarted)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () => _updateScheduleStatus(schedule['id'].toString(), 'Completed'),
                                  child: const Text("Hoàn Thành"),
                                ),
                                ElevatedButton(
                                  onPressed: () => _updateScheduleStatus(schedule['id'].toString(), 'Pending'),
                                  child: const Text("Tạm Hoãn"),
                                ),
                                ElevatedButton(
                                  onPressed: () => _updateScheduleStatus(schedule['id'].toString(), 'Failed'),
                                  child: const Text("Thất Bại"),
                                ),
                              ],
                            ),
                        ],
                      ),
                    );
                  },
                ),
              )
                  : const Text("Không có lịch trình nào."),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Thực hiện hành động, ví dụ mở bản đồ
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HutechMap()),
          );
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.map), // Logo bản đồ
      ),
    );
  }
}