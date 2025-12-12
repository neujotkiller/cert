import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cert_app/providers/auth_provider.dart';

class EmailVerifyDialog extends StatefulWidget {
  final String email;
  const EmailVerifyDialog({super.key, required this.email});

  @override
  State<EmailVerifyDialog> createState() => _EmailVerifyDialogState();
}

class _EmailVerifyDialogState extends State<EmailVerifyDialog> {
  bool verifying = false;

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();

    return AlertDialog(
      title: const Text("이메일 인증 확인"),
      content: const Text("메일함에서 인증을 완료한 후 '확인' 버튼을 눌러주세요."),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("취소"),
        ),
        ElevatedButton(
          onPressed: verifying
              ? null
              : () async {
                  setState(() => verifying = true);

                  final ok = await auth.checkEmailVerify(widget.email);

                  setState(() => verifying = false);

                  if (ok && mounted) {
                    Navigator.pop(context, true);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("아직 인증되지 않았습니다. 메일을 확인해주세요."),
                      ),
                    );
                  }
                },
          child: verifying
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text("확인"),
        ),
      ],
    );
  }
}
