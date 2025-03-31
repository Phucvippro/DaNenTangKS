import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:app/features/authentication/presentation/pages/welcome.dart';
import 'injection_container.dart' as di;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'features/schedule/presentation/bloc/schedule_bloc.dart';
import 'features/schedule/presentation/pages/schedule_screen.dart';

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
        BlocProvider<ScheduleBloc>(
          create: (_) => di.sl<ScheduleBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Quản lý lịch & lương',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: const Color(0xff078fff),
          fontFamily: 'Inter',
          visualDensity: VisualDensity.adaptivePlatformDensity,
          useMaterial3: true,
        ),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('vi', 'VN'),
        ],
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