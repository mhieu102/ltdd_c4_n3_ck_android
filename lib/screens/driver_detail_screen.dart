import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/home_service.dart';

class DriverDetailScreen extends StatefulWidget {
  final Map<String, dynamic> userInfo;

  const DriverDetailScreen({required this.userInfo, Key? key}) : super(key: key);

  @override
  _DriverDetailScreenState createState() => _DriverDetailScreenState();
}

class _DriverDetailScreenState extends State<DriverDetailScreen> {
  late Map<String, dynamic> data;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    data = Map<String, dynamic>.from(widget.userInfo['data'] ?? {});
  }

  void _toggleEditing() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  Future<void> _updateDriverInfo() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: SpinKitCircle(color: Colors.orange),
      ),
    );

    final success = await HomeService.updateUserInfo(data['id'], data);
    Navigator.pop(context);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Cập nhật thông tin thành công!',
            style: GoogleFonts.roboto(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );
      setState(() {
        isEditing = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Cập nhật thất bại!',
            style: GoogleFonts.roboto(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chi tiết tài xế',
          style: GoogleFonts.roboto(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: FaIcon(isEditing ? FontAwesomeIcons.floppyDisk : FontAwesomeIcons.pen),
            onPressed: () {
              if (isEditing) {
                _updateDriverInfo();
              } else {
                _toggleEditing();
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.orange[100],
                    child: const FaIcon(FontAwesomeIcons.user, size: 60, color: Colors.orange),
                  ),
                  const SizedBox(height: 12),
                  _buildInlineEditableField('Họ và tên', 'fullName', icon: FontAwesomeIcons.idBadge),
                  const SizedBox(height: 8),
                  _buildInlineEditableField('Email', 'email', icon: FontAwesomeIcons.envelope, isEnabled: false),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInlineEditableField('Địa chỉ', 'address', icon: FontAwesomeIcons.locationDot),
                  _buildInlineEditableField('Giới tính', 'gender', icon: FontAwesomeIcons.venusMars),
                  _buildInlineEditableField('Ngày sinh', 'dateOfBirth', icon: FontAwesomeIcons.calendarDays),
                  _buildInlineEditableField('Loại bằng lái', 'classOfDriverLicense', icon: FontAwesomeIcons.idCard),
                  _buildInlineEditableField('Số điện thoại', 'phoneNumber', icon: FontAwesomeIcons.phone),
                  _buildInlineEditableField('Tên đăng nhập', 'userName', icon: FontAwesomeIcons.user, isEnabled: false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInlineEditableField(String label, String fieldKey, {IconData? icon, bool isEnabled = true}) {
    TextEditingController controller = TextEditingController(text: data[fieldKey]);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FaIcon(icon, color: Colors.orange, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: isEditing && isEnabled
                ? TextFormField(
              controller: controller,
              onChanged: (value) {
                data[fieldKey] = value;
              },
              style: GoogleFonts.roboto(fontSize: 16),
              decoration: InputDecoration(
                labelText: label,
                labelStyle: GoogleFonts.roboto(color: Colors.orange[800]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            )
                : Text(
              '$label: ${data[fieldKey] ?? ''}',
              style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
