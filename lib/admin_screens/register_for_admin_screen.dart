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

  bool _isLoading = false;
  bool _obscurePassword = true;

  void _register() async {
    if (usernameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty ||
        phoneNumberController.text.isEmpty ||
        fullNameController.text.isEmpty ||
        addressController.text.isEmpty ||
        selectedGender == null ||
        selectedDate == null ||
        licenseClassController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập đầy đủ thông tin'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mật khẩu và xác nhận mật khẩu không khớp'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    Map<String, dynamic> result = await _adminService.adminRegister(
      username: usernameController.text,
      email: emailController.text,
      password: passwordController.text,
      confirmPassword: confirmPasswordController.text,
      phoneNumber: phoneNumberController.text,
      fullName: fullNameController.text,
      address: addressController.text,
      gender: selectedGender ?? "Other",
      dateOfBirth: selectedDate != null ? DateFormat('dd/MM/yyyy').format(selectedDate!) : null,
      classOfDriverLicense: licenseClassController.text,
      role: role,
    );

    setState(() => _isLoading = false);

    if (result['status'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đăng ký thành công!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DriverListScreen()),
      );
    } else {
      String errorMessage = result['message'] ?? 'Đăng ký thất bại';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                _buildRoleButtons(),
                const SizedBox(height: 20),
                _buildTextField(usernameController, 'Tên người dùng'),
                const SizedBox(height: 12),
                _buildTextField(emailController, 'Email', keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 12),
                _buildTextField(passwordController, 'Mật khẩu', obscureText: _obscurePassword, suffixIcon: _buildPasswordVisibilityToggle()),
                const SizedBox(height: 12),
                _buildTextField(confirmPasswordController, 'Xác nhận mật khẩu', obscureText: _obscurePassword),
                const SizedBox(height: 12),
                _buildTextField(phoneNumberController, 'Số điện thoại', keyboardType: TextInputType.phone),
                const SizedBox(height: 12),
                _buildTextField(fullNameController, 'Họ và tên'),
                const SizedBox(height: 12),
                _buildTextField(addressController, 'Địa chỉ'),
                const SizedBox(height: 12),
                _buildGenderDropdown(),
                const SizedBox(height: 12),
                _buildDatePicker(),
                const SizedBox(height: 12),
                _buildTextField(licenseClassController, 'Hạng giấy phép lái xe'),
                const SizedBox(height: 20),
                _buildRegisterButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleButtons() {
    return Row(
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
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, {bool obscureText = false, TextInputType? keyboardType, Widget? suffixIcon}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: labelText,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        suffixIcon: suffixIcon,
      ),
    );
  }

  Widget _buildPasswordVisibilityToggle() {
    return IconButton(
      icon: Icon(
        _obscurePassword ? Icons.visibility_off : Icons.visibility,
        color: Colors.grey,
      ),
      onPressed: () {
        setState(() => _obscurePassword = !_obscurePassword);
      },
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedGender,
      decoration: InputDecoration(
        hintText: 'Giới tính',
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      items: const [
        DropdownMenuItem(value: 'Male', child: Text('Nam')),
        DropdownMenuItem(value: 'Female', child: Text('Nữ')),
        DropdownMenuItem(value: 'Other', child: Text('Khác')),
      ],
      onChanged: (value) {
        setState(() {
          selectedGender = value;
        });
      },
    );
  }

  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: AbsorbPointer(
        child: TextField(
          decoration: InputDecoration(
            hintText: selectedDate == null ? 'Ngày sinh' : DateFormat('dd/MM/yyyy').format(selectedDate!),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            suffixIcon: const Icon(Icons.calendar_today),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _register,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
            : const Text(
          'Tạo tài khoản',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

}