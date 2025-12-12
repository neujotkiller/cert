import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Api {
  Api._internal();
  static final Api instance = Api._internal();

  static const String baseUrl = "https://fastapi-cert-backend.onrender.com";
  static const storage = FlutterSecureStorage();

  // =====================================================
  // 토큰 저장
  // =====================================================
  static Future<void> saveToken(String token) async {
    await storage.write(key: "access_token", value: token);
  }

  // =====================================================
  // 토큰 불러오기
  // =====================================================
  static Future<String?> getToken() async {
    return await storage.read(key: "access_token");
  }

  // =====================================================
  // 토큰 삭제
  // =====================================================
  static Future<void> clearToken() async {
    await storage.delete(key: "access_token");
  }

  // =====================================================
  // 로그인
  // =====================================================
  Future<Map<String, dynamic>> login(String userid, String password) async {
    final url = Uri.parse("$baseUrl/auth/login");
    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"userid": userid, "password": password}),
    );

    return jsonDecode(res.body);
  }

  // =====================================================
  // 회원가입
  // =====================================================
  Future<AuthResult> signup({
    required String name,
    required String birth,
    required String email,
    required String userid,
    required String password,
  }) async {
    final url = Uri.parse("$baseUrl/auth/signup");

    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "birth": birth,
        "email": email,
        "userid": userid,
        "password": password,
      }),
    );

    final data = jsonDecode(res.body);

    return AuthResult(
      success: res.statusCode == 201,
      message: data["message"],
    );
  }

  // =====================================================
  // 이메일 중복 체크
  // =====================================================
  Future<bool> checkEmail(String email) async {
    final url = Uri.parse("$baseUrl/auth/check-email");
    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email}),
    );

    final body = jsonDecode(res.body);
    return res.statusCode == 200 && body["ok"] == true;
  }

  // =====================================================
  // 이메일 인증 여부
  // =====================================================
  Future<bool> checkEmailVerify(String email) async {
    final url = Uri.parse("$baseUrl/auth/email-verify-status?email=$email");
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      return body["verified"] == true;
    }
    return false;
  }

  // =====================================================
  // ID 중복 체크
  // =====================================================
  Future<bool> checkUserId(String userid) async {
    final url = Uri.parse("$baseUrl/auth/check-userid");
    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"userid": userid}),
    );

    final body = jsonDecode(res.body);
    return res.statusCode == 200 && body["ok"] == true;
  }

  // =====================================================
  // 내 자격증 추천
  // =====================================================
  Future<List<dynamic>> getMyRecommendedCertificates(String token) async {
    final url = Uri.parse("$baseUrl/me/certificates/recommended");

    final res = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    final body = jsonDecode(res.body);
    return body["data"] ?? [];
  }

  // =====================================================
  // NCS 기반 자격증 추천
  // =====================================================
  Future<List<dynamic>> getCertificatesByNcs(String token) async {
    final url = Uri.parse("$baseUrl/me/certificates/ncs");

    final res = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    final body = jsonDecode(res.body);
    return body["data"] ?? [];
  }

  // =====================================================
  // 커뮤니티 글 작성
  // =====================================================
  Future<bool> createCommunityPost(
    String token,
    String title,
    String content,
  ) async {
    final url = Uri.parse("$baseUrl/community/posts");

    final res = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"title": title, "content": content}),
    );

    return res.statusCode == 201;
  }

  // =====================================================
  // 커뮤니티 글 목록
  // =====================================================
  Future<List<dynamic>> getCommunityPosts() async {
    final url = Uri.parse("$baseUrl/community/posts");
    final res = await http.get(url);
    final body = jsonDecode(res.body);

    return body is List ? body : (body["data"] ?? []);
  }

  // =====================================================
  // 직업 상세
  // =====================================================
  Future<Map<String, dynamic>> getJobDetail(int jobSeq) async {
    final url = Uri.parse("$baseUrl/jobs/detail/$jobSeq");

    final res = await http.get(url);

    if (res.statusCode == 200) return jsonDecode(res.body);
    return {};
  }

  // =====================================================
  // 자격증 → 관련 직업
  // =====================================================
  Future<List<dynamic>> getRelatedJobs(int licenseId) async {
    final url = Uri.parse("$baseUrl/cert/related_jobs/$licenseId");

    final res = await http.get(url);

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      return body["jobs"] ?? [];
    }
    return [];
  }
}

class AuthResult {
  final bool success;
  final String? message;

  AuthResult({
    required this.success,
    this.message,
  });
}
