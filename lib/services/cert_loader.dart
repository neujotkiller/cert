import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/certificate.dart';

class CertLoader {
  static Future<Map<String, Certificate>> loadCertBasic() async {
    final raw = await rootBundle.loadString('lib/data/cert_basic.json');
    final Map<String, dynamic> jsonMap = jsonDecode(raw);

    return jsonMap.map((key, value) {
      return MapEntry(key, Certificate.fromJson(value));
    });
  }

  static Future<List<String>> loadMajorMap(String major) async {
    final raw = await rootBundle.loadString('lib/data/major_cert_map.json');
    final map = jsonDecode(raw);
    return List<String>.from(map[major] ?? []);
  }

  static Future<List<String>> loadNcsMap(List<String> ncsList) async {
    final raw = await rootBundle.loadString('lib/data/ncs_map.json');
    final map = jsonDecode(raw);

    final Set<String> result = {};
    for (final ncs in ncsList) {
      result.addAll(List<String>.from(map[ncs] ?? []));
    }
    return result.toList();
  }
}
