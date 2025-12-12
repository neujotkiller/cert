class UserProfile {
  final String name;
  final String major;
  final int grade;
  final int employmentTotal;
  final int employmentMale;
  final int employmentFemale;
  final List<String> interestNcs;
  final String? imageUrl;

  UserProfile({
    required this.name,
    required this.major,
    required this.grade,
    required this.employmentTotal,
    required this.employmentMale,
    required this.employmentFemale,
    required this.interestNcs,
    this.imageUrl,
  });

  UserProfile copyWith({
    List<String>? interestNcs,
  }) {
    return UserProfile(
      name: name,
      major: major,
      grade: grade,
      employmentTotal: employmentTotal,
      employmentMale: employmentMale,
      employmentFemale: employmentFemale,
      interestNcs: interestNcs ?? this.interestNcs,
      imageUrl: imageUrl,
    );
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'],
      major: json['major'],
      grade: json['grade'],
      employmentTotal: json['employment_total'],
      employmentMale: json['employment_male'],
      employmentFemale: json['employment_female'],
      interestNcs: List<String>.from(json['interest_ncs']),
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'major': major,
      'grade': grade,
      'employment_total': employmentTotal,
      'employment_male': employmentMale,
      'employment_female': employmentFemale,
      'interest_ncs': interestNcs,
      'image_url': imageUrl,
    };
  }
}
