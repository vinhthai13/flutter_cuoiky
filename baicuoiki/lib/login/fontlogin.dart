import 'package:flutter/material.dart';
import 'package:baicuoiki/Layout.dart';
import 'package:baicuoiki/login/PageRegister.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(SignInPage());
}

class SignInPage extends StatelessWidget {
  // Add controllers for text fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  SignInPage({super.key});

  Future<bool> loginUser() async {
    try {
      final response = await http.get(
        Uri.parse('https://67b6d5db07ba6e590841ffab.mockapi.io/users'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> users = json.decode(response.body);
        
        // Tìm user với email và password khớp
        final user = users.firstWhere(
          (user) => 
            user['email'] == _emailController.text.trim() && 
            user['password'] == _passwordController.text.trim(),
          orElse: () => null,
        );

        if (user != null) {
          // Lưu thông tin user vào SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('username', user['username']);
          await prefs.setString('email', user['email']);
          await prefs.setString('phone', user['phone'] ?? '');
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error during login: $e');
      return false;
    }
  }

  void logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('password');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignInPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng Nhập')),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
              
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Email hoặc số điện thoại',
                    hintStyle: const TextStyle(color: Colors.grey), // Màu gợi ý nhạt hơn
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 10,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Mật khẩu',
                        hintStyle: const TextStyle(color: Colors.grey), // Màu gợi ý nhạt hơn
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 10,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.visibility, color: Colors.grey),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Quên mật khẩu ?',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFBBD08), // Màu vàng sáng cho nút
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    bool isLoggedIn = await loginUser();
                    if (isLoggedIn) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const Layout()),
                      );
                    } else {
                      // Show error message
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Sai tài khoản hoặc mật khẩu!'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Đăng nhập',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    Expanded(
                      child: Divider(color: Colors.grey),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text('Hoặc'),
                    ),
                    Expanded(
                      child: Divider(color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Facebook Icon
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: const Color(0xFF1877F2), // Màu sắc của Facebook
                      child: IconButton(
                        icon: const Icon(
                          Icons.facebook,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Google Icon
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: const Color(0xFFDB4437), // Màu đỏ của Google
                      child: IconButton(
                        icon: const Icon(
                          Icons.share,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Apple Icon
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: const Color(0xFF000000), // Màu đen của Apple
                      child: IconButton(
                        icon: const Icon(
                          Icons.apple,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Chưa có tài khoản? "),
                    GestureDetector(
                      onTap: () {
                        // Navigate to PageRegister
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PageRegister()),
                        );
                      },
                      child: const Text(
                        'Đăng kí',
                        style: TextStyle(color: Color(0xFFFBBD08)), // Màu vàng cho chữ
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
