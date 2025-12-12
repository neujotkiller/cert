import 'package:flutter/material.dart';

class CommunityListScreen extends StatelessWidget {
  const CommunityListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("커뮤니티")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xff5b4db8),
        child: const Icon(Icons.edit),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: DropdownButtonFormField(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              labelText: "자격증 분류 선택",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            items: const [
              DropdownMenuItem(value: "전체", child: Text("전체 자격증")),
            ],
            onChanged: (value) {},
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: "검색어 입력",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),

        const SizedBox(height: 40),

        const Center(
          child: Text(
            "작성된 글이 없습니다.\n아래 글쓰기 버튼을 눌러 새 글을 작성하세요!",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ]),
    );
  }
}
