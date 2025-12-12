import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/profile_provider.dart';

class NcsSelectScreen extends StatefulWidget {
  const NcsSelectScreen({super.key});

  @override
  State<NcsSelectScreen> createState() => _NcsSelectScreenState();
}

class _NcsSelectScreenState extends State<NcsSelectScreen> {
  final categories = [
    "건설","경비.청소","경영.회계.사무","교육.자연.사회과학","금융.보험","기계",
    "농림어업","마케팅.광고.홍보","문화.예술.디자인.방송","법률.경찰.소방.교도.국방",
    "보건.의료","사업관리","사회복지.종교","섬유.의복","식품가공","영업판매",
    "운전.운송","음식서비스","이용.숙박.여행.오락.스포츠","인쇄.목재.가구.공예",
    "재료","전기.전자","정보통신","화학.바이오","환경.에너지.안전"
  ];

  List<String> selected = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("관심 NCS 대직무")),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (_, idx) {
          final title = categories[idx];
          final isSelected = selected.contains(title);

          return ListTile(
            title: Text(title, style: TextStyle(fontSize: 18)),
            trailing: Checkbox(
              value: isSelected,
              onChanged: (_) {
                setState(() {
                  isSelected ? selected.remove(title) : selected.add(title);
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.check, color: Colors.white),
        onPressed: () {
          context.read<ProfileProvider>().updateProfile(
            interestNcs: selected,
          );
Navigator.pop(context);

        },
      ),
    );
  }
}
