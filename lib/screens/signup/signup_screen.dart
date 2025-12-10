import 'package:flutter/material.dart';
import 'package:your_app/api.dart'; // ← 반드시 실제 프로젝트 경로로 수정
import '../login/login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  bool isLoading = false;

  Future<void> _signup() async {
    final email = emailController.text.trim();
    final password = pwController.text.trim();
    final name = nameController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showError("이메일과 비밀번호는 필수입니다.");
      return;
    }

    setState(() => isLoading = true);

    final result = await ApiService.signup(email, password, name);

    setState(() => isLoading = false);

    if (result == null) {
      _showError("회원가입 실패. 이메일 형식 또는 비밀번호를 확인하세요.");
      return;
    }

    // 가입 성공 → 로그인 화면으로 이동
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("회원가입 완료"),
        content: const Text("이제 로그인해 주세요."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // dialog 닫기
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            child: const Text("확인"),
          )
        ],
      ),
    );
  }

  void _showError(String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("오류"),
        content: Text(msg),
        actions: [
          TextButton(
            child: const Text("확인"),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("회원가입"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 이름 입력
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "이름 (선택)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // 이메일 입력
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "이메일",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // 비밀번호 입력
            TextField(
              controller: pwController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "비밀번호",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // 회원가입 버튼
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.primary,
                ),
                onPressed: isLoading ? null : _signup,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "회원가입",
                        style: TextStyle(fontSize: 18),
                      ),
              ),
            ),

            const SizedBox(height: 12),

            // 로그인 이동
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              child: const Text("이미 계정이 있으신가요? 로그인하기"),
            ),
          ],
        ),
      ),
    );
  }
}
