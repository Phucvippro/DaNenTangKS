import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:app/features/authentication/presentation/bloc/auth_event.dart';
import 'package:app/features/authentication/presentation/bloc/auth_state.dart';
import 'package:app/core/utils/input_validator.dart';
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
  
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is SignUpSuccess) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FrontIdScreen()),
            );
          } else if (state is SignUpError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: SingleChildScrollView(
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
                    controller: _usernameController,
                    label: 'Tên đăng nhập',
                    validator: InputValidator.validateUsername,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  // Password field
                  _buildTextField(
                    controller: _passwordController,
                    label: 'Mật khẩu',
                    isPassword: true,
                    isPasswordVisible: _isPasswordVisible,
                    onVisibilityChanged: (value) {
                      setState(() {
                        _isPasswordVisible = value;
                      });
                    },
                    validator: InputValidator.validatePassword,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  // Confirm Password field
                  _buildTextField(
                    controller: _confirmPasswordController,
                    label: 'Nhập lại mật khẩu',
                    isPassword: true,
                    isPasswordVisible: _isConfirmPasswordVisible,
                    onVisibilityChanged: (value) {
                      setState(() {
                        _isConfirmPasswordVisible = value;
                      });
                    },
                    validator: (value) => InputValidator.validateConfirmPassword(
                      value, 
                      _passwordController.text
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  // Verify ID Button
                  Center(
                    child: BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: state is AuthLoading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<AuthBloc>().add(
                                          SignUpEvent(
                                            username: _usernameController.text,
                                            password: _passwordController.text,
                                            confirmPassword: _confirmPasswordController.text,
                                          ),
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
                          child: state is AuthLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                                  'Đăng kí',
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                    fontFamily: 'Inter-Bold',
                                  ),
                                ),
                        );
                      },
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
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
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
          controller: controller,
          obscureText: isPassword && !(isPasswordVisible ?? false),
          validator: validator,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.black),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.black),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xff078fff), width: 2),
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