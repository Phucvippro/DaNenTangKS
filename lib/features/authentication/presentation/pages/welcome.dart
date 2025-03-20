import 'package:flutter/material.dart';
import 'signin.dart';
import 'signup.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _WelcomeScreen();
}

class _WelcomeScreen extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    // Lấy kích thước màn hình
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        color: Colors.white,
        width: screenWidth,
        height: screenHeight,
        child: Stack(
          children: [
            // Background màu xanh
            Positioned(
              left: 0,
              width: screenWidth,
              top: 0,
              height: screenHeight * 0.6, // 60% chiều cao màn hình
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xff078fff),
                ),
              ),
            ),
            // Container màu trắng bo góc
            Positioned(
              left: 0,
              width: screenWidth,
              top: screenHeight * 0.4, // 40% chiều cao màn hình
              height: screenHeight * 0.6, // 60% chiều cao màn hình
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
            ),
            // Text Chào mừng
            Positioned(
              left: screenWidth * 0.2,
              top: screenHeight * 0.2,
              child: const Text(
                'Chào Mừng',
                style: TextStyle(
                  fontSize: 42,
                  color: Colors.white,
                  fontFamily: 'Inter-Bold',
                ),
              ),
            ),
            // Nút đăng nhập
            Positioned(
              left: screenWidth * 0.15,
              width: screenWidth * 0.7,
              top: screenHeight * 0.6,
              height: screenHeight * 0.08,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SigninScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff078fff),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Đăng nhập',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontFamily: 'Inter-Bold',
                  ),
                ),
              ),
            ),
            // Text "Hoặc"
            Positioned(
              left: screenWidth * 0.415,
              top: screenHeight * 0.715,
              child: const Text(
                'Hoặc',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontFamily: 'Inter-Regular',
                ),
              ),
            ),
            // Đường kẻ bên trái
            Positioned(
              left: screenWidth * 0.15,
              width: screenWidth * 0.25,
              top: screenHeight * 0.735,
              child: Container(
                height: 1,
                color: Colors.black,
              ),
            ),
            // Đường kẻ bên phải
            Positioned(
              left: screenWidth * 0.57,
              width: screenWidth * 0.25,
              top: screenHeight * 0.735,
              child: Container(
                height: 1,
                color: Colors.black,
              ),
            ),
            // Nút đăng ký
            Positioned(
              left: screenWidth * 0.15,
              width: screenWidth * 0.7,
              top: screenHeight * 0.78,
              height: screenHeight * 0.08,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff078fff),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Đăng kí',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontFamily: 'Inter-Bold',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}