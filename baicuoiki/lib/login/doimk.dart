import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChangePasswordScreen(),
    );
  }
}

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _showOldPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final userEmail = prefs.getString('email');

      // Lấy danh sách users từ API
      final response = await http.get(
        Uri.parse('https://67b6d5db07ba6e590841ffab.mockapi.io/users'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> users = json.decode(response.body);
        
        // Tìm user hiện tại
        final user = users.firstWhere(
          (user) => user['email'] == userEmail && 
                    user['password'] == _oldPasswordController.text,
          orElse: () => null,
        );

        if (user != null) {
          // Cập nhật mật khẩu mới
          final updateResponse = await http.put(
            Uri.parse('https://67b6d5db07ba6e590841ffab.mockapi.io/users/${user['id']}'),
            body: {
              'password': _newPasswordController.text,
              // Giữ nguyên các thông tin khác
              'email': user['email'],
              'username': user['username'],
              'phone': user['phone'],
              'avatar': user['avatar'],
            },
          );

          if (updateResponse.statusCode == 200) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đổi mật khẩu thành công!')),
              );
              Navigator.pop(context);
            }
          } else {
            throw Exception('Không thể cập nhật mật khẩu');
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Mật khẩu cũ không đúng!')),
            );
          }
        }
      } else {
        throw Exception('Không thể kết nối với server');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Đổi mật khẩu',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Vui lòng nhập thông tin để thay đổi mật khẩu.',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 20),
                _buildPasswordField('Mật khẩu cũ', _oldPasswordController, _showOldPassword, () {
                  setState(() {
                    _showOldPassword = !_showOldPassword;
                  });
                }),
                const SizedBox(height: 20),
                _buildPasswordField('Mật khẩu mới', _newPasswordController, _showNewPassword, () {
                  setState(() {
                    _showNewPassword = !_showNewPassword;
                  });
                }),
                const SizedBox(height: 20),
                _buildPasswordField('Xác nhận mật khẩu', _confirmPasswordController, _showConfirmPassword, () {
                  setState(() {
                    _showConfirmPassword = !_showConfirmPassword;
                  });
                }),
                const SizedBox(height: 40),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow.shade700,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(23.0),
                      ),
                      shadowColor: Colors.black26,
                      elevation: 4,
                    ),
                    onPressed: _changePassword,
                    child: const Text(
                      'Xác nhận',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller, bool showPassword, VoidCallback toggleVisibility) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black54),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        suffixIcon: IconButton(
          icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
          onPressed: toggleVisibility,
        ),
      ),
      obscureText: !showPassword,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập ${label.toLowerCase()}';
        }
        if (label == 'Xác nhận mật khẩu' && value != _newPasswordController.text) {
          return 'Mật khẩu không khớp';
        }
        return null;
      },
    );
  }
}

void logout(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
 
  Navigator.pushReplacementNamed(context, '/login'); // Redirect to login screen
}

Future<bool> loginUser(String email, String password) async {
  final prefs = await SharedPreferences.getInstance();
  String? savedEmail = prefs.getString('email');
  String? savedPassword = prefs.getString('password');

  if (email == savedEmail && password == savedPassword) {
    return true;
  }
  return false;
}
