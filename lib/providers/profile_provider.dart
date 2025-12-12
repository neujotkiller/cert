import 'package:flutter/foundation.dart';
import 'package:cert_app/models/user_profile.dart';

class ProfileProvider extends ChangeNotifier {
  UserProfile? _profile;

  bool get hasProfile => _profile != null;
  UserProfile? get profile => _profile;

  void setProfile(UserProfile p) {
    _profile = p;
    notifyListeners();
  }

  void clear() {
    _profile = null;
    notifyListeners();
  }

  // ====== 수정 메서드들 ======
  void updateName(String v) {
    if (_profile == null) return;
    _profile = _profile!.copyWith(name: v);
    notifyListeners();
  }

  void updateMajor(String v) {
    if (_profile == null) return;
    _profile = _profile!.copyWith(major: v);
    notifyListeners();
  }

  void updateGrade(int v) {
    if (_profile == null) return;
    _profile = _profile!.copyWith(grade: v);
    notifyListeners();
  }

  void updateEmployment(double t, double m, double f) {
    if (_profile == null) return;
    _profile = _profile!.copyWith(
      employmentTotal: t,
      employmentMale: m,
      employmentFemale: f,
    );
    notifyListeners();
  }

  void updateImage(String path) {
    if (_profile == null) return;
    _profile = _profile!.copyWith(imageUrl: path);
    notifyListeners();
  }

  void updateInterestNcs(List<String> list) {
    if (_profile == null) return;
    _profile = _profile!.copyWith(interestNcs: list);
    notifyListeners();
  }
}
