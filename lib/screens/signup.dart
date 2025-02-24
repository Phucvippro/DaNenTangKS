import 'package:flutter/material.dart';
import 'frontid.dart';
import 'signin.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SignupScreen();
}

class _SignupScreen extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          width: screenWidth,
          height: screenHeight,
          color: Colors.white,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.1),
                Center(
                  child: Text(
                    'Đăng kí',
                    style: TextStyle(
                      fontSize: 42,
                      color: const Color(0xff078fff),
                      fontFamily: 'Inter-Bold',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                // Username field
                _buildTextField(
                  label: 'Tên đăng nhập',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập tên đăng nhập';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.02),
                // Password field
                _buildTextField(
                  label: 'Mật khẩu',
                  isPassword: true,
                  isPasswordVisible: _isPasswordVisible,
                  onVisibilityChanged: (value) {
                    setState(() {
                      _isPasswordVisible = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mật khẩu';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.02),
                // Confirm Password field
                _buildTextField(
                  label: 'Nhập lại mật khẩu',
                  isPassword: true,
                  isPasswordVisible: _isConfirmPasswordVisible,
                  onVisibilityChanged: (value) {
                    setState(() {
                      _isConfirmPasswordVisible = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập lại mật khẩu';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.05),
                // Verify ID Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FrontIdScreen()),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff078fff),
                      minimumSize: Size(screenWidth * 0.9, 64),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'Xác minh căn cước',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontFamily: 'Inter-Bold',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                // Login Link
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Đã có tài khoản? ',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontFamily: 'Inter-Regular',
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SigninScreen()),
                          );
                        },
                        child: const Text(
                          'Đăng nhập ngay!',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xff078fff),
                            fontFamily: 'Inter-Regular',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    bool isPassword = false,
    bool? isPasswordVisible,
    Function(bool)? onVisibilityChanged,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          obscureText: isPassword && !(isPasswordVisible ?? false),
          validator: validator,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.black),
            ),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      isPasswordVisible ?? false ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      onVisibilityChanged?.call(!(isPasswordVisible ?? false));
                    },
                  )
                : null,
          ),
        ),
      ],
    );
  }
}