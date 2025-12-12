import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cert_app/services/api.dart';

class AuthProvider extends ChangeNotifier {
  final Api api = Api.instance;
  final storage = const FlutterSecureStorage();

  bool initializing = true;
  bool isLoggedIn = false;
  String? token;

  // -----------------------------
  // 프로필 화면용 정보 변수들 (백엔드 연동 시 업데이트 가능)
  // -----------------------------
  String? userName;
  String? userMajor;
  String? userGrade;

  String? employmentTotal;
  String? employmentMale;
  String? employmentFemale;

  AuthProvider() {
    loadStoredToken();
  }

  // -----------------------------------------
  // 저장된 토큰 불러오기
  // -----------------------------------------
  Future<void> loadStoredToken() async {
    token = await storage.read(key: "access_token");

    if (token != null) {
      isLoggedIn = true;
    } else {
      isLoggedIn = false;
    }

    initializing = false;
    notifyListeners();
  }

  // -----------------------------------------
  // 로그인
  // -----------------------------------------
  Future<bool> login(String userid, String password) async {
    try {
      final result = await api.login(userid, password);

      if (result.containsKey("access_token")) {
        token = result["access_token"];
        isLoggedIn = true;

        await storage.write(key: "access_token", value: token);
        notifyListeners();
        return true;
      }
    } catch (e) {
      return false;
    }

    return false;
  }

  // -----------------------------------------
  // 회원가입
  // -----------------------------------------
  Future<bool> signup({
    required String name,
    required String birth,
    required String email,
    required String userid,
    required String password,
  }) async {
    try {
      final result = await api.signup(
        name: name,
        birth: birth,
        email: email,
        userid: userid,
        password: password,
      );

      return result.success;
    } catch (e) {
      return false;
    }
  }

  // -----------------------------------------
  // 이메일 인증 확인
  // -----------------------------------------
  Future<bool> checkEmailVerify(String email) async {
    try {
      return await api.checkEmailVerify(email);
    } catch (e) {
      return false;
    }
  }

  // -----------------------------------------
  // 프로필 정보 업데이트 (프로필 화면에서 사용)
  // -----------------------------------------
  void setProfileData(Map<String, dynamic> data) {
    userName = data["name"];
    userMajor = data["major"];
    userGrade = data["grade"];

    employmentTotal = data["employment_total"];
    employmentMale = data["employment_male"];
    employmentFemale = data["employment_female"];

    notifyListeners();
  }

  // -----------------------------------------
  // 로그아웃
  // -----------------------------------------
  Future<void> logout() async {
    token = null;
    isLoggedIn = false;

    await storage.delete(key: "access_token");
    notifyListeners();
  }
}
