import 'package:flutter/material.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/login/login_screen.dart';
import 'screens/signup/signup_screen.dart';
import 'screens/home/cert_home_screen.dart';

// 🔥 추가: APIService 초기화용 import
import 'services/api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 1) 앱 실행 전에 APIService 초기화 (토큰 읽어오기)
  await ApiService.instance.init();  

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "사용자 맞춤형 자격증 플랫폼",

      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5B46C5),
        ),
        fontFamily: "Pretendard",
      ),

      // 앱 시작 화면
      home: const SplashScreen(),

      // 라우트 등록
      routes: {
        "/login": (_) => const LoginScreen(),
        "/signup": (_) => const SignupScreen(),
        "/home": (_) => const CertHomeScreen(),
      },
    );
  }
}
