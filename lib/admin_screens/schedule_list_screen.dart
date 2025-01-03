import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../services/admin_service.dart';

class ListScheduleScreen extends StatefulWidget {
  const ListScheduleScreen({Key? key}) : super(key: key);

  @override
  _ListScheduleScreenState createState() => _ListScheduleScreenState();
}

class _ListScheduleScreenState extends State<ListScheduleScreen> {
  final AdminService _adminService = AdminService();
  List<dynamic> _schedules = [];
  String _message = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSchedules();
  }

  Future<void> _fetchSchedules() async {
    final result = await _adminService.getAllSchedules();
    if (result['success']) {
      setState(() {
        _schedules = result['data'];
        _message = result['message'];
      });
    } else {
      setState(() {
        _message = result['message'];
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _toggleScheduleConfirmation(String idSchedule) async {
    final result = await _adminService.toggleScheduleConfirmation(idSchedule);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result['message'])),
    );
    _fetchSchedules(); // Cập nhật danh sách lịch trình
  }

  Future<void> _generateRandomSchedule() async {
    final result = await _adminService.generateRandomSchedule();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result['message'])),
    );
    _fetchSchedules(); // Cập nhật danh sách lịch trình
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Danh Sách Lịch Trình"),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _generateRandomSchedule,
              child: const Text("Tạo Ngẫu Nhiên Lịch Trình"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? Center(
                child: SpinKitCircle(
                  color: Colors.orange,
                  size: 50.0,
                ),
              )
                  : _schedules.isNotEmpty
                  ? ListView.builder(
                itemCount: _schedules.length,
                itemBuilder: (context, index) {
                  final schedule = _schedules[index];
                  return Slidable(
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            // Xử lý xóa lịch trình ở đây
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Xóa',
                        ),
                      ],
                    ),
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 4,
                      child: ListTile(
                        title: Text(schedule['driverName']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Hàng hóa: ${schedule['goodsName']}'),
                            Text('Địa điểm lấy: ${schedule['pickupLocation']}'),
                            Text('Địa điểm giao: ${schedule['deliveryLocation']}'),
                            Text('Chi phí: \$${schedule['shippingCost'].toStringAsFixed(2)}'),
                            Text('Trạng thái: ${schedule['isConfirmed'] ? "Đã xác nhận" : "Chưa xác nhận"}'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            schedule['isConfirmed'] ? Icons.check_circle : Icons.check,
                            color: schedule['isConfirmed'] ? Colors.green : Colors.blue,
                          ),
                          onPressed: () => _toggleScheduleConfirmation(schedule['id'].toString()),
                        ),
                      ),
                    ),
                  );
                },
              )
                  : Center(
                child: Text(_message.isNotEmpty ? _message : "Không có lịch trình nào."),
              ),
            ),
          ],
        ),
      ),
    );
  }
}