import 'package:flutter/material.dart';
import '../../services/api.dart';
import '../login/login_screen.dart';
import '../home/cert_home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    await Future.delayed(const Duration(milliseconds: 600)); // 로딩 애니메이션용

    final token = await ApiService.instance.getToken();

    // 토큰 없으면 로그인 화면으로 이동
    if (token == null) {
      _goToLogin();
      return;
    }

    // 토큰 있으면 프로필 요청해서 정상인지 체크
    final profile = await ApiService.instance.getProfile();

    if (profile == null) {
      await ApiService.instance.clearToken();
      _goToLogin();
      return;
    }

    // 정상 토큰 → 홈 화면
    _goToHome();
  }

  void _goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  void _goToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const CertHomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircularProgressIndicator(
          color: Color(0xFF5B46C5),
          strokeWidth: 3,
        ),
      ),
    );
  }
}
