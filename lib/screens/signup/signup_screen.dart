import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cert_app/providers/auth_provider.dart';
import 'package:cert_app/services/api.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _name = TextEditingController();
  final _birth = TextEditingController();
  final _email = TextEditingController();
  final _userid = TextEditingController();
  final _password = TextEditingController();
  final _passwordConfirm = TextEditingController();

  bool loading = false;
  bool checkingId = false;
  bool checkingEmail = false;

  bool idAvailable = false;
  bool emailVerified = false;

  // ==============================
  // 아이디 중복확인
  // ==============================
  Future<void> _checkUserId() async {
    if (_userid.text.trim().isEmpty) {
      _showSnack("아이디를 입력하세요.");
      return;
    }

    setState(() => checkingId = true);

    final ok = await Api.instance.checkUserId(_userid.text.trim());

    if (!mounted) return;

    setState(() {
      checkingId = false;
      idAvailable = ok;
    });

    _showSnack(ok ? "사용 가능한 아이디입니다." : "이미 존재하는 아이디입니다.");
  }

  // ==============================
  // 이메일 인증 요청
  // ==============================
  Future<void> _requestEmailVerify() async {
    if (_email.text.trim().isEmpty) {
      _showSnack("이메일을 입력하세요.");
      return;
    }

    setState(() => checkingEmail = true);

    final ok = await Api.instance.checkEmail(_email.text.trim());

    if (!mounted) return;

    setState(() => checkingEmail = false);

    _showSnack(
      ok ? "인증 메일이 전송되었습니다. 메일함을 확인해주세요."
         : "이미 사용 중인 이메일입니다.",
    );
  }

  // ==============================
  // 이메일 인증 확인
  // ==============================
  Future<void> _verifyEmail() async {
    final verified = await Api.instance.checkEmailVerify(_email.text.trim());

    if (!mounted) return;

    setState(() => emailVerified = verified);

    _showSnack(
      verified ? "이메일 인증이 완료되었습니다!" : "아직 인증되지 않았습니다.",
    );
  }

  // ==============================
  // 회원가입
  // ==============================
  Future<void> _submitSignup() async {
    if (!idAvailable) {
      _showSnack("아이디 중복확인을 해주세요.");
      return;
    }
    if (!emailVerified) {
      _showSnack("이메일 인증을 완료해주세요.");
      return;
    }
    if (_password.text != _passwordConfirm.text) {
      _showSnack("비밀번호가 일치하지 않습니다.");
      return;
    }

    setState(() => loading = true);

    final auth = context.read<AuthProvider>();
    final ok = await auth.signup(
      name: _name.text.trim(),
      birth: _birth.text.trim(),
      email: _email.text.trim(),
      userid: _userid.text.trim(),
      password: _password.text.trim(),
    );

    if (!mounted) return;

    setState(() => loading = false);

    if (ok) {
      _showSnack("회원가입 성공!");
      Navigator.pop(context);
    } else {
      _showSnack("회원가입 실패");
    }
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  void dispose() {
    _name.dispose();
    _birth.dispose();
    _email.dispose();
    _userid.dispose();
    _password.dispose();
    _passwordConfirm.dispose();
    super.dispose();
  }

  // ============================================================
  // UI
  // ============================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("회원가입", style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _inputField("이름", _name),
              _inputField("생년월일 (예: 000229)", _birth),

              Row(
                children: [
                  Expanded(child: _inputField("이메일", _email)),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: checkingEmail ? null : _requestEmailVerify,
                    child: checkingEmail
                        ? const CircularProgressIndicator(strokeWidth: 2)
                        : const Text("인증 전송"),
                  ),
                ],
              ),

              const SizedBox(height: 6),
              OutlinedButton(
                onPressed: _verifyEmail,
                child: const Text("인증 확인"),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(child: _inputField("아이디", _userid)),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: checkingId ? null : _checkUserId,
                    child: checkingId
                        ? const CircularProgressIndicator(strokeWidth: 2)
                        : const Text("중복확인"),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              _inputField("비밀번호", _password, obscure: true),
              _inputField("비밀번호 확인", _passwordConfirm, obscure: true),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: loading ? null : _submitSignup,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("회원가입 완료"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputField(String label, TextEditingController controller,
      {bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
