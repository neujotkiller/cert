import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cert_app/providers/profile_provider.dart';
import 'package:cert_app/screens/ncs/ncs_select_screen.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  late final TextEditingController nameCtrl;
  late final TextEditingController majorCtrl;
  late final TextEditingController gradeCtrl;
  late final TextEditingController empTotalCtrl;
  late final TextEditingController empMaleCtrl;
  late final TextEditingController empFemaleCtrl;

  @override
  void initState() {
    super.initState();
    final p = context.read<ProfileProvider>().profile!;
    nameCtrl = TextEditingController(text: p.name);
    majorCtrl = TextEditingController(text: p.major);
    gradeCtrl = TextEditingController(text: p.grade.toString());
    empTotalCtrl = TextEditingController(text: p.employmentTotal.toString());
    empMaleCtrl = TextEditingController(text: p.employmentMale.toString());
    empFemaleCtrl = TextEditingController(text: p.employmentFemale.toString());
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    majorCtrl.dispose();
    gradeCtrl.dispose();
    empTotalCtrl.dispose();
    empMaleCtrl.dispose();
    empFemaleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("프로필 편집"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _field("이름", nameCtrl),
            _field("학과", majorCtrl),
            _field("학년", gradeCtrl),

            const SizedBox(height: 20),
            const Text("취업률 입력", style: TextStyle(fontSize: 18)),
            _field("전체 취업률", empTotalCtrl),
            _field("남자 취업률", empMaleCtrl),
            _field("여자 취업률", empFemaleCtrl),

            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const NcsSelectScreen()),
                  );
                },
                child: const Text("관심 NCS 선택"),
              ),
            ),

            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                onPressed: () {
                  provider.updateName(nameCtrl.text);
                  provider.updateMajor(majorCtrl.text);
                  provider.updateGrade(int.tryParse(gradeCtrl.text) ?? 0);
                  provider.updateEmployment(
                    double.tryParse(empTotalCtrl.text) ?? 0,
                    double.tryParse(empMaleCtrl.text) ?? 0,
                    double.tryParse(empFemaleCtrl.text) ?? 0,
                  );
                  Navigator.pop(context);
                },
                child: const Text("저장하기", style: TextStyle(color: Colors.white)),
              ),
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
