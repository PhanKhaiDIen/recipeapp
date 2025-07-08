import 'package:flutter/material.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int currentPage = 0; // 0: Welcome, 1: Login, 2: Register

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _buildPage(),
        ),
      ),
    );
  }

  Widget _buildPage() {
    switch (currentPage) {
      case 0:
        return _buildWelcomePage();
      case 1:
        return _buildLoginPage();
      case 2:
        return _buildRegisterPage();
      default:
        return Container();
    }
  }

  Widget _buildWelcomePage() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("images/Logo.jpg"),
          const SizedBox(height: 20),
          Center(
            child: const Text(
              'Master Chef',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Hạnh Phúc Khi Được Nấu Ăn\nCho Người Mình Thương',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              setState(() {
                currentPage = 1;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF90FFF7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            ),
            child: const Text(
              "Let's Go",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLoginPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Xin Chào !', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Đăng nhập vào ứng dụng', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 40),
          const Text('Thông tin đăng nhập', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          TextField(
            controller: emailController,
            decoration: _inputDecoration('Email'),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: _inputDecoration('Password'),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Bạn chưa có tài khoản ? "),
              GestureDetector(
                onTap: () => setState(() => currentPage = 2),
                child: const Text(
                  "Đăng ký",
                  style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: _buttonStyle(),
              onPressed: () {
                // TODO: Xử lý đăng nhập
                String email = emailController.text.trim();
                String password = passwordController.text;

                if (!isValidEmail(email) || !isValidPassword(password)) {
                  _showDialog("Email hoặc mật khẩu không hợp lệ!");
                  return;
                }

                // Giả lập đăng nhập thành công → chuyển đến HomeScreen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Home()),
                );
              },
              child: const Text('Đăng nhập', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Xin Chào !', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Đăng ký vào ứng dụng', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 40),
          const Text('Thông tin đăng ký', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          TextField(
            controller: emailController,
            decoration: _inputDecoration('Email'),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: _inputDecoration('Password'),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: confirmPasswordController,
            obscureText: true,
            decoration: _inputDecoration('Confirmation Password'),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Bạn đã có tài khoản ? "),
              GestureDetector(
                onTap: () => setState(() => currentPage = 1),
                child: const Text(
                  "Đăng nhập",
                  style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: _buttonStyle(),
              onPressed: _handleRegister,
              child: const Text('Đăng ký', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------- VALIDATION LOGIC ---------------------

  void _handleRegister() {
    String email = emailController.text.trim();
    String pass = passwordController.text;
    String confirm = confirmPasswordController.text;

    if (!isValidEmail(email)) {
      _showDialog("Email không hợp lệ. Email phải có @ và bao gồm cả chữ và số.");
      return;
    }

    if (!isValidPassword(pass)) {
      _showDialog("Mật khẩu phải bao gồm cả số và chữ.");
      return;
    }

    if (pass != confirm) {
      _showDialog("Mật khẩu xác nhận không trùng khớp.");
      return;
    }

    // Nếu mọi thứ hợp lệ
    _showDialog("Đăng ký thành công!", onOk: () {
      setState(() {
        currentPage = 1; // chuyển về trang đăng nhập
      });
    });
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)[\w\.\-]+@[\w\.\-]+\.\w+$');
    return emailRegex.hasMatch(email);
  }

  bool isValidPassword(String password) {
    final passRegex = RegExp(r'^(?=.*[a-zA-Z])(?=.*\d).+$');
    return passRegex.hasMatch(password);
  }

  void _showDialog(String message, {VoidCallback? onOk}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thông báo'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (onOk != null) onOk();
            },
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      filled: true,
      fillColor: Colors.grey.shade200,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide.none,
      ),
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF90FFF7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
    );
  }
}
