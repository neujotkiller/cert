import 'package:flutter/material.dart';
import '../models/user_profile.dart';

class ProfileProvider extends ChangeNotifier {
  UserProfile? profile;

  void setProfile(UserProfile data) {
    profile = data;
    notifyListeners();
  }

  void updateProfile({
    List<String>? interestNcs,
  }) {
    if (profile == null) return;

    profile = profile!.copyWith(
      interestNcs: interestNcs,
    );

    notifyListeners();
  }

  void clear() {
    profile = null;
    notifyListeners();
  }
}
