import 'package:flutter/material.dart';
import '../../services/api.dart';
import '../../models/user_profile.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final ApiService _api = ApiService();

  bool _loading = true;
  UserProfile? _profile;

  final _nameCtrl = TextEditingController();
  final _ageCtrl = TextEditingController(); // YY 형식: 99, 00, 01
  String? _selectedDepartment;
  int? _selectedGrade;

  final List<String> departments = [
    "산업데이터공학과",
    "컴퓨터공학과",
    "경영학과",
    "기계공학과",
    "경제학과",
  ];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final data = await _api.get("/me/profile");

      _profile = UserProfile.fromJson(data);

      _nameCtrl.text = _profile?.name ?? "";
      _selectedDepartment = _profile?.department;
      _selectedGrade = _profile?.gradeYear;

      if (_profile?.birthDate != null) {
        _ageCtrl.text = _profile!.birthDate!.substring(0, 2);
      }

      setState(() => _loading = false);
    } catch (e) {
      print("프로필 불러오기 실패: $e");
      setState(() => _loading = false);
    }
  }

  Future<void> _saveProfile() async {
    try {
      await _api.patch(
        "/me/profile",
        {
          "name": _nameCtrl.text,
          "birth_date": _ageCtrl.text, // YY만 저장
          "department": _selectedDepartment,
          "grade_year": _selectedGrade,
        },
      );

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      print("프로필 저장 실패: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("저장 실패")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("프로필 수정")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _input("이름", _nameCtrl),
            const SizedBox(height: 16),
            _input("나이(예: 00, 01)", _ageCtrl, max: 2),
            const SizedBox(height: 16),

            const Text("학과", style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              isExpanded: true,
              value: _selectedDepartment,
              items: departments
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedDepartment = v),
            ),
            const SizedBox(height: 16),

            const Text("학년"),
            DropdownButton<int>(
              isExpanded: true,
              value: _selectedGrade,
              items: [1, 2, 3, 4]
                  .map((e) => DropdownMenuItem(value: e, child: Text("$e학년")))
                  .toList(),
              onChanged: (v) => setState(() => _selectedGrade = v),
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: _saveProfile,
              child: const Text("저장"),
            )
          ],
        ),
      ),
    );
  }

  Widget _input(String label, TextEditingController c, {int max = 50}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        TextField(
          controller: c,
          maxLength: max,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            counterText: "",
          ),
        ),
      ],
    );
  }
}
