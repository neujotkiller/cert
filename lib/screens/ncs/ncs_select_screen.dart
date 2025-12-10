import 'package:flutter/material.dart';
import '../../services/api.dart';

class NcsSelectScreen extends StatefulWidget {
  const NcsSelectScreen({super.key});

  @override
  State<NcsSelectScreen> createState() => _NcsSelectScreenState();
}

class _NcsSelectScreenState extends State<NcsSelectScreen> {
  final ApiService _api = ApiService();

  List<Map<String, dynamic>> largeList = [];
  List<Map<String, dynamic>> middleList = [];

  List<Map<String, dynamic>> selectedLarge = [];
  List<Map<String, dynamic>> selectedMiddle = [];

  String? _currentLarge;

  @override
  void initState() {
    super.initState();
    _loadLarge();
  }

  Future<void> _loadLarge() async {
    try {
      final data = await _api.get("/meta/ncs/large");
      largeList = List<Map<String, dynamic>>.from(data);
      setState(() {});
    } catch (e) {
      print("대직무 로드 실패: $e");
    }
  }

  Future<void> _loadMiddle(String largeCode) async {
    try {
      final data = await _api.get("/meta/ncs/middle/$largeCode");
      middleList = List<Map<String, dynamic>>.from(data);
      setState(() {});
    } catch (e) {
      print("중직무 로드 실패: $e");
    }
  }

  Future<void> _save() async {
    try {
      await _api.put("/me/ncs-preferences", {
        "large": selectedLarge,
        "mid": selectedMiddle,
      });

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      print("NCS 저장 실패: $e");
    }
  }

  void _toggleLarge(Map<String, dynamic> item) {
    final exists = selectedLarge.any((e) => e["large_code"] == item["large_code"]);
    if (exists) {
      selectedLarge.removeWhere((e) => e["large_code"] == item["large_code"]);
    } else {
      selectedLarge.add(item);
    }
    setState(() {});
  }

  void _toggleMiddle(Map<String, dynamic> item) {
    if (selectedMiddle.length >= 4 &&
        !selectedMiddle.any((e) => e["mid_code"] == item["mid_code"])) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("최대 4개까지 선택 가능합니다.")));
      return;
    }

    final exists = selectedMiddle.any((e) => e["mid_code"] == item["mid_code"]);
    if (exists) {
      selectedMiddle.removeWhere((e) => e["mid_code"] == item["mid_code"]);
    } else {
      selectedMiddle.add(item);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("NCS 관심 직무 선택")),
      body: Column(
        children: [
          const SizedBox(height: 10),
          const Text("대직무 선택", style: TextStyle(fontSize: 18)),
          Expanded(
            child: ListView(
              children: largeList.map((item) {
                final selected = selectedLarge.any(
                    (e) => e["large_code"] == item["large_code"]);
                return ListTile(
                  title: Text(item["large_name"]),
                  trailing:
                      selected ? const Icon(Icons.check, color: Colors.blue) : null,
                  onTap: () {
                    _toggleLarge(item);
                    _currentLarge = item["large_code"];
                    _loadMiddle(_currentLarge!);
                  },
                );
              }).toList(),
            ),
          ),

          const Divider(height: 1),
          const Text("중직무 선택", style: TextStyle(fontSize: 18)),
          Expanded(
            child: ListView(
              children: middleList.map((item) {
                final selected = selectedMiddle
                    .any((e) => e["mid_code"] == item["mid_code"]);
                return ListTile(
                  title: Text(item["mid_name"]),
                  trailing:
                      selected ? const Icon(Icons.check, color: Colors.blue) : null,
                  onTap: () => _toggleMiddle(item),
                );
              }).toList(),
            ),
          ),

          ElevatedButton(
            onPressed: _save,
            child: const Text("저장"),
          ),
        ],
      ),
    );
  }
}
