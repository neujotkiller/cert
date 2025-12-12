import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  static Future<File?> pickImage() async {
    if (kIsWeb) {
      // 웹에서는 File 사용 불가 → null 반환
      return null;
    }

    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked == null) return null;
    return File(picked.path);
  }
}
