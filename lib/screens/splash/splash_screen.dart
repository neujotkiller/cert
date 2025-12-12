import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cert_app/providers/profile_provider.dart';
import 'package:cert_app/services/api.dart';
import 'package:cert_app/profile_api.dart';

import 'package:cert_app/screens/login/login_screen.dart';
import 'package:cert_app/screens/home/cert_home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _boot();
    });
  }

  Future<void> _boot() async {
    final token = await Api.getToken();
    if (!mounted) return;

    if (token == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
      return;
    }

    final profile = await ProfileAPI.getProfile();
    if (!mounted) return;

    if (profile != null) {
      context.read<ProfileProvider>().setProfile(profile);
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const CertHomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
