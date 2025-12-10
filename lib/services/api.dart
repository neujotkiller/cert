import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static final ApiService instance = ApiService._internal();
  factory ApiService() => instance;
  ApiService._internal();

  static const String baseUrl = "http://127.0.0.1:8000";

  final storage = const FlutterSecureStorage();

  // ------------------------------------------------------
  // JWT TOKEN
  // ------------------------------------------------------
  Future<void> saveToken(String token) async {
    await storage.write(key: "access_token", value: token);
  }

  Future<String?> getToken() async {
    return await storage.read(key: "access_token");
  }

  Future<void> clearToken() async {
    await storage.delete(key: "access_token");
  }

  // ------------------------------------------------------
  // HEADERS
  // ------------------------------------------------------
  Future<Map<String, String>> _headers({bool auth = false}) async {
    final h = {
      "Content-Type": "application/json",
    };
    if (auth) {
      final token = await getToken();
      if (token != null) {
        h["Authorization"] = "Bearer $token";
      }
    }
    return h;
  }

  // ------------------------------------------------------
  // LOGIN
  // ------------------------------------------------------
  Future<bool> login(String email, String password) async {
    final url = Uri.parse("$baseUrl/auth/login");

    final res = await http.post(
      url,
      headers: await _headers(),
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      await saveToken(data["access_token"]);
      return true;
    }
    return false;
  }

  // ------------------------------------------------------
  // SIGNUP
  // ------------------------------------------------------
  Future<bool> signup(String email, String password, String name) async {
    final url = Uri.parse("$baseUrl/auth/signup");

    final res = await http.post(
      url,
      headers: await _headers(),
      body: jsonEncode({
        "email": email,
        "password": password,
        "name": name,
      }),
    );

    return res.statusCode == 201;
  }

  // ------------------------------------------------------
  // GET PROFILE
  // ------------------------------------------------------
  Future<Map<String, dynamic>?> getProfile() async {
    final url = Uri.parse("$baseUrl/me/profile");

    final res = await http.get(
      url,
      headers: await _headers(auth: true),
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    return null;
  }

  // ------------------------------------------------------
  // UPDATE PROFILE
  // ------------------------------------------------------
  Future<bool> updateProfile(Map<String, dynamic> payload) async {
    final url = Uri.parse("$baseUrl/me/profile");

    final res = await http.patch(
      url,
      headers: await _headers(auth: true),
      body: jsonEncode(payload),
    );

    return res.statusCode == 200;
  }

  // ------------------------------------------------------
  // RECOMMENDED CERTIFICATES (전공 기반)
  // ------------------------------------------------------
  Future<List<dynamic>> getRecommendedCerts() async {
    final url = Uri.parse("$baseUrl/me/certificates/recommended");

    final res = await http.get(
      url,
      headers: await _headers(auth: true),
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    return [];
  }

  // ------------------------------------------------------
  // NCS 기반 추천
  // ------------------------------------------------------
  Future<List<dynamic>> getCertsByNcs() async {
    final url = Uri.parse("$baseUrl/me/certificates/by-ncs");

    final res = await http.get(
      url,
      headers: await _headers(auth: true),
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    return [];
  }

  // ------------------------------------------------------
  // COMMUNITY — 목록
  // ------------------------------------------------------
  Future<List<dynamic>> getPosts() async {
    final url = Uri.parse("$baseUrl/community/posts");

    final res = await http.get(
      url,
      headers: await _headers(auth: true),
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    return [];
  }

  // ------------------------------------------------------
  // COMMUNITY — 글쓰기
  // ------------------------------------------------------
  Future<bool> writePost(String title, String content) async {
    final url = Uri.parse("$baseUrl/community/posts");

    final res = await http.post(
      url,
      headers: await _headers(auth: true),
      body: jsonEncode({
        "title": title,
        "content": content,
      }),
    );

    return res.statusCode == 201;
  }
}
