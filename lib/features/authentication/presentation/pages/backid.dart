import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:app/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:app/features/authentication/presentation/bloc/auth_event.dart';
import 'package:app/features/authentication/presentation/bloc/auth_state.dart';
import 'infor.dart';

class BackIdScreen extends StatefulWidget {
  const BackIdScreen({super.key});

  @override
  _BackIdScreenState createState() => _BackIdScreenState();
}

class _BackIdScreenState extends State<BackIdScreen> {
  File? _backIdImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _takePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        _backIdImage = File(photo.path);
      });
    }
  }

  Future<void> _chooseFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _backIdImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Xác minh căn cước'),
        backgroundColor: const Color(0xff078fff),
        foregroundColor: Colors.white,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is VerificationSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const InforScreen()),
            );
          } else if (state is VerificationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          width: screenWidth,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.05),
              const Text(
                'Vui lòng cung cấp ảnh mặt sau căn cước công dân/CMND của bạn',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.05),
              Container(
                width: screenWidth * 0.9,
                height: screenHeight * 0.3,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _backIdImage == null
                    ? const Center(
                        child: Text(
                          'Chưa có ảnh',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          _backIdImage!,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              SizedBox(height: screenHeight * 0.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _takePhoto,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Chụp ảnh'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff078fff),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _chooseFromGallery,
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Chọn ảnh'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff078fff),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.1),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return Center(
                    child: ElevatedButton(
                      onPressed: (_backIdImage == null || state is AuthLoading)
                          ? null
                          : () {
                              final bloc = context.read<AuthBloc>();
                              if (bloc is Authenticated) {
                                // Lấy user ID từ state
                                final userId = (bloc as Authenticated).user.id;
                                context.read<AuthBloc>().add(
                                      VerifyIdEvent(
                                        userId: userId,
                                        idImagePath: _backIdImage!.path,
                                      ),
                                    );
                              } else {
                                // Trong trường hợp đăng ký và chưa có user ID, có thể cần xử lý khác
                                // Tùy thuộc vào thiết kế của ứng dụng
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Lỗi xác thực người dùng. Vui lòng đăng nhập lại.')),
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
                              'Xác minh',
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontFamily: 'Inter-Bold',
                              ),
                            ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}