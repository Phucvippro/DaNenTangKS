import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:app/features/authentication/presentation/pages/welcome.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => di.sl<AuthBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Ứng dụng Xác thực',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: const Color(0xff078fff),
          fontFamily: 'Inter',
        ),
        home: const WelcomeScreen()
      ),
    );
  }
}

// Thêm InforScreen tạm thời nếu chưa có
class InforScreen extends StatelessWidget {
  const InforScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin người dùng'),
        backgroundColor: const Color(0xff078fff),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Màn hình thông tin người dùng'),
      ),
    );
  }
}