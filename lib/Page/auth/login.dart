import 'package:doanthuchanh/Page/auth/quenmk.dart';
import 'package:doanthuchanh/Page/auth/register.dart';
import 'package:doanthuchanh/layout/homePage.dart';
import 'package:doanthuchanh/config/const.dart';
import 'package:doanthuchanh/data/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../../data/sharepre.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController accountController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  login() async {
    //lấy token (lưu share_preference)
    String token = await APIRepository()
        .login(accountController.text, passwordController.text);
    var user = await APIRepository().current(token);
    // save share
    saveUser(user);
    //
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Mainpage()));
    return token;
  }

  @override
  void initState() {
    super.initState();
    // autoLogin();
  }

  autoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user') != null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Mainpage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: const Color(0xFFFFC0CB), // Màu hồng nhạt
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(16.0),
          color: const Color(0xFFFFE4E1), // Màu nền hồng nhạt
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                urlLogo,
                height: 150,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.image),
              ),
              const SizedBox(height: 24),
              const Text(
                "LOGIN INFORMATION",
                style: TextStyle(
                  fontSize: 24,
                  color: Color(0xFFFF1493), // Màu hồng đậm
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: accountController,
                decoration: InputDecoration(
                  labelText: "Account",
                  icon: const Icon(Icons.person, color: Color(0xFFFF1493)), // Màu hồng đậm
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFF1493)), // Màu hồng đậm
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  icon: const Icon(Icons.lock, color: Color(0xFFFF1493)), // Màu hồng đậm
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFF1493)), // Màu hồng đậm
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF69B4), // Màu hồng
                      ),
                      child: const Text("Login"),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Register()),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFFF69B4)), // Màu hồng
                      ),
                      child: const Text(
                        "Register",
                        style: TextStyle(color: Color(0xFFFF69B4)), // Màu hồng
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ForgotPasswordScreen()),
                  );
                },
                child: const Text(
                  'Quên mật khẩu?',
                  style: TextStyle(color: Color(0xFFFF1493)), // Màu hồng đậm
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
