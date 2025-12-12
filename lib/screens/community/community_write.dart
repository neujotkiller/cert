import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cert_app/services/api.dart';
import 'package:cert_app/providers/auth_provider.dart';

class CommunityWriteScreen extends StatefulWidget {
  const CommunityWriteScreen({super.key});

  @override
  State<CommunityWriteScreen> createState() => _CommunityWriteScreenState();
}

class _CommunityWriteScreenState extends State<CommunityWriteScreen> {
  final _title = TextEditingController();
  final _content = TextEditingController();
  bool loading = false;

  Future<void> submit() async {
    if (_title.text.trim().isEmpty || _content.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("제목과 내용을 입력해주세요.")),
      );
      return;
    }

    final token = context.read<AuthProvider>().token;

    if (token == null) return;

    setState(() => loading = true);

    final ok = await Api.instance.createCommunityPost(
      token,
      _title.text.trim(),
      _content.text.trim(),
    );

    setState(() => loading = false);

    if (ok) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("작성 실패")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("글 작성")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: "제목"),
            ),
            TextField(
              controller: _content,
              decoration: const InputDecoration(labelText: "내용"),
              maxLines: 10,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loading ? null : submit,
              child: Text(loading ? "저장 중..." : "등록"),
            ),
          ],
        ),
      ),
    );
  }
}
