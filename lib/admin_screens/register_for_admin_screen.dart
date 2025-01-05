import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Đảm bảo import thư viện này
import '../services/admin_service.dart';
import 'driver_list_screen.dart';

class RegisterForAdmin extends StatefulWidget {
  const RegisterForAdmin({Key? key}) : super(key: key);

  @override
  _RegisterForAdminState createState() => _RegisterForAdminState();
}

class _RegisterForAdminState extends State<RegisterForAdmin> {
  final AdminService _adminService = AdminService();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController licenseClassController = TextEditingController();

  String role = 'Admin'; // Mặc định là Admin
  DateTime? selectedDate; // Biến lưu trữ ngày đã chọn
  String? selectedGender; // Biến lưu trữ giới tính đã chọn

  void _register() async {
    String? formattedDate;

    if (selectedDate != null) {
      formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate!);
    }

    final result = await _adminService.adminRegister(
      username: usernameController.text,
      email: emailController.text,
      password: passwordController.text,
      confirmPassword: confirmPasswordController.text,
      phoneNumber: phoneNumberController.text,
      fullName: fullNameController.text,
      address: addressController.text,
      gender: selectedGender ?? "Other",
      dateOfBirth: formattedDate,
      classOfDriverLicense: licenseClassController.text,
      role: role, // Truyền vai trò vào đây
    );

    // Kiểm tra phản hồi từ server
    if (result['status'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đăng ký thành công: ${result['message']}'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DriverListScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi: ${result['message']}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng ký'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      role = 'Admin';
                    });
                  },
                  child: const Text('Admin'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: role == 'Admin' ? Colors.orange : Colors.grey,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      role = 'Driver';
                    });
                  },
                  child: const Text('Driver'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: role == 'Driver' ? Colors.orange : Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password', hintText: 'Nhập mật khẩu'),
              obscureText: true,
            ),
            TextField(
              controller: confirmPasswordController,
              decoration: const InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
            ),
            TextField(
              controller: phoneNumberController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            TextField(
              controller: fullNameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(labelText: 'Address'),
            ),
            // ComboBox cho giới tính
            DropdownButtonFormField<String>(
              value: selectedGender,
              decoration: const InputDecoration(labelText: 'Giới tính'),
              items: [
                DropdownMenuItem(
                  child: Text('Nam'),
                  value: 'Male',
                ),
                DropdownMenuItem(
                  child: Text('Nữ'),
                  value: 'Female',
                ),
                DropdownMenuItem(
                  child: Text('Khác'),
                  value: 'Other',
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedGender = value;
                });
              },
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Ngày sinh',
                    hintText: selectedDate == null ? 'Chọn ngày' : DateFormat('dd/MM/yyyy').format(selectedDate!),
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                ),
              ),
            ),
            TextField(
              controller: licenseClassController,
              decoration: const InputDecoration(labelText: 'Class of Driver License'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              child: const Text('Tạo tài khoản'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}