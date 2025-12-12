import 'package:flutter/material.dart';
import 'package:cert_app/screens/login/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF2F0FF),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.workspace_premium, size: 100, color: Colors.deepPurple),
            SizedBox(height: 20),
            Text(
              "사용자 맞춤형 자격증 플랫폼",
              style: TextStyle(fontSize: 20, color: Colors.deepPurple),
            )
          ],
        ),
      ),
    );
  }
}
