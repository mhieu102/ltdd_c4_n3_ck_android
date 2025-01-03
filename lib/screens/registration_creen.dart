import 'package:flutter/material.dart';

import '../utils/auth.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _licenseClassController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _handleRegister() async {
    if (_usernameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty ||
        _phoneNumberController.text.isEmpty ||
        _fullNameController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _genderController.text.isEmpty ||
        _dateOfBirthController.text.isEmpty ||
        _licenseClassController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập đầy đủ thông tin'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mật khẩu và xác nhận mật khẩu không khớp'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    Map<String, dynamic> result = await Auth.register(
      username: _usernameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
      phoneNumber: _phoneNumberController.text,
      fullName: _fullNameController.text,
      address: _addressController.text,
      gender: _genderController.text,
      dateOfBirth: _dateOfBirthController.text,
      licenseClass: _licenseClassController.text,
    );

    setState(() => _isLoading = false);

    if (result['status'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đăng ký thành công!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
        child: SingleChildScrollView(
        child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    const SizedBox(height: 60),
    Text(
    'Đăng ký tài khoản',
    textAlign: TextAlign.center,
    style: TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: Colors.blue[700],
    ),
    ),
    const SizedBox(height: 40),
    TextField(
    controller: _usernameController,
    keyboardType: TextInputType.text,
    decoration: InputDecoration(
    hintText: 'Tên người dùng',
    filled: true,
    fillColor: Colors.grey[100],
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 16,
    ),
    ),
    ),
    const SizedBox(height: 12),
    TextField(
    controller: _emailController,
    keyboardType: TextInputType.emailAddress,
    decoration: InputDecoration(
    hintText: 'Email',
    filled: true,
    fillColor: Colors.grey[100],
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 16,
    ),
    ),
    ),
    const SizedBox(height: 12),
    TextField(
    controller: _passwordController,
    obscureText: _obscurePassword,
    decoration: InputDecoration(
    hintText: 'Mật khẩu',
    filled: true,
    fillColor: Colors.grey[100],
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 16,
    ),
    suffixIcon: IconButton(
    icon: Icon(
    _obscurePassword ? Icons.visibility_off : Icons.visibility,
    color: Colors.grey,
    ),
    onPressed: () {
    setState(() => _obscurePassword = !_obscurePassword);
    },
    ),
    ),
    ),
    const SizedBox(height: 12),
    TextField(
    controller: _confirmPasswordController,
    obscureText: _obscurePassword,
    decoration: InputDecoration(
    hintText: 'Xác nhận mật khẩu',
    filled: true,
    fillColor: Colors.grey[100],
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 16,
    ),
    ),
    ),
    const SizedBox(height: 12),
    TextField(
    controller: _phoneNumberController,
    keyboardType: TextInputType.phone,
    decoration: InputDecoration(
    hintText: 'Số điện thoại',
    filled: true,
    fillColor: Colors.grey[100],
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 16,
    ),
    ),
    ),
    const SizedBox(height: 12),
    TextField(
    controller: _fullNameController,
    keyboardType: TextInputType.text,
    decoration: InputDecoration(
    hintText: 'Họ và tên',
    filled: true,
    fillColor: Colors.grey[100],
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 16,
    ),
    ),
    ),
    const SizedBox(height: 12),
    TextField(
    controller: _addressController,
    keyboardType: TextInputType.text,
    decoration: InputDecoration(
    hintText: 'Địa chỉ',
    filled: true,
    fillColor: Colors.grey[100],
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 16,
    ),
    ),
    ),
    const SizedBox(height: 12),
    TextField(
    controller:
    _genderController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: 'Giới tính (Male/Female/Other)',
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    ),
      const SizedBox(height: 12),
      TextField(
        controller: _dateOfBirthController,
        keyboardType: TextInputType.datetime,
        decoration: InputDecoration(
          hintText: 'Ngày sinh (DD/MM/YYYY)',
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
      const SizedBox(height: 12),
      TextField(
        controller: _licenseClassController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: 'Hạng giấy phép lái xe',
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
      const SizedBox(height: 20),
      SizedBox(
        height: 50,
        child: ElevatedButton(
          onPressed: _isLoading ? null : _handleRegister,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[700],
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
            'Đăng ký',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      const SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Đã có tài khoản? ",style: TextStyle(fontSize: 15),),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Quay lại màn hình đăng nhập
            },
            child: const Text(
              'Đăng nhập',
              style: TextStyle(color: Colors.blue,fontSize: 15),
            ),
          ),
        ],
      ),
    ],
    ),
        ),
        ),
        ),
    );
  }
}
