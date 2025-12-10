import 'dart:convert';

class UserProfile {
  final String id;               // Supabase UUID 문자열
  final String? name;
  final String? birthDate;       // YYMMDD 또는 null
  final String? department;
  final int? gradeYear;

  UserProfile({
    required this.id,
    this.name,
    this.birthDate,
    this.department,
    this.gradeYear,
  });

  /// JSON → UserProfile 변환
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json["id"].toString(),
      name: json["name"],
      birthDate: json["birth_date"],
      department: json["department"],
      gradeYear: json["grade_year"],
    );
  }

  /// UserProfile → JSON (PATCH 요청에 사용)
  Map<String, dynamic> toJson() {
    return {
      if (name != null) "name": name,
      if (birthDate != null) "birth_date": birthDate,
      if (department != null) "department": department,
      if (gradeYear != null) "grade_year": gradeYear,
    };
  }

  /// 문자열 디버깅용
  @override
  String toString() {
    return jsonEncode({
      "id": id,
      "name": name,
      "birth_date": birthDate,
      "department": department,
      "grade_year": gradeYear,
    });
  }
}

