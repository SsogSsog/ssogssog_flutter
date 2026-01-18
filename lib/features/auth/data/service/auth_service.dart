import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class AuthService {
  static const String _uuidKey = 'device_uuid';

  // UUID 가져오기 (없으면 생성해서 저장)
  Future<String> getDeviceUuid() async {
    final prefs = await SharedPreferences.getInstance();
    String? uuid = prefs.getString(_uuidKey);

    if (uuid == null) {
      uuid = const Uuid().v4(); // 새 UUID 생성
      await prefs.setString(_uuidKey, uuid);
    }
    return uuid;
  }
}
