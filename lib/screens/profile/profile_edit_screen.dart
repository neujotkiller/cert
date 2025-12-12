import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/profile_provider.dart';
import '../ncs/ncs_select_screen.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  @override
  Widget build(BuildContext context) {
    final p = context.watch<ProfileProvider>().profile;

    final nameCtrl = TextEditingController(text: p.name);
    final majorCtrl = TextEditingController(text: p.major);
    final gradeCtrl = TextEditingController(text: p.grade.toString());
    final empTotalCtrl = TextEditingController(text: p.employmentTotal.toString());
    final empMaleCtrl = TextEditingController(text: p.employmentMale.toString());
    final empFemaleCtrl = TextEditingController(text: p.employmentFemale.toString());

    return Scaffold(
      appBar: AppBar(title: const Text("프로필 편집")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 이름
            _field("이름", nameCtrl),
            _field("학과", majorCtrl),
            _field("학년", gradeCtrl),

            const SizedBox(height: 20),
            const Text("취업률 입력", style: TextStyle(fontSize: 18)),
            _field("전체 취업률", empTotalCtrl),
            _field("남자 취업률", empMaleCtrl),
            _field("여자 취업률", empFemaleCtrl),

            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
              onPressed: () async {
                context.read<ProfileProvider>().updateName(nameCtrl.text);
                context.read<ProfileProvider>().updateMajor(majorCtrl.text);
                context.read<ProfileProvider>().updateGrade(int.tryParse(gradeCtrl.text) ?? 0);
                context.read<ProfileProvider>()
                  .updateEmployment(
                      double.tryParse(empTotalCtrl.text) ?? 0,
                      double.tryParse(empMaleCtrl.text) ?? 0,
                      double.tryParse(empFemaleCtrl.text) ?? 0
                  );

                Navigator.pop(context);
              },
              child: const Text("저장하기", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(String title, TextEditingController ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
