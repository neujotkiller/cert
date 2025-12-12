import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cert_app/providers/profile_provider.dart';

class NcsSelectScreen extends StatefulWidget {
  const NcsSelectScreen({super.key});

  @override
  State<NcsSelectScreen> createState() => _NcsSelectScreenState();
}

class _NcsSelectScreenState extends State<NcsSelectScreen> {
  final List<String> all = const [
    "경영·회계·사무",
    "보건·의료",
    "정보통신",
    "기계",
    "전기·전자",
    "건설",
    "화학",
    "디자인",
  ];

  late List<String> selected;

  @override
  void initState() {
    super.initState();
    final p = context.read<ProfileProvider>().profile;
    selected = List<String>.from(p?.interestNcs ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("관심 NCS 선택"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // 뒤로가기 확실
        ),
      ),
      body: ListView.builder(
        itemCount: all.length,
        itemBuilder: (_, i) {
          final item = all[i];
          final checked = selected.contains(item);
          return CheckboxListTile(
            title: Text(item),
            value: checked,
            onChanged: (v) {
              setState(() {
                if (v == true) {
                  selected.add(item);
                } else {
                  selected.remove(item);
                }
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<ProfileProvider>().updateInterestNcs(selected);
          Navigator.pop(context);
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
