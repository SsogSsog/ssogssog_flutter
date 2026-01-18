import 'package:ssogssog_flutter/core/network/api_client.dart';

class MemberRepository {
  final ApiClient _apiClient = ApiClient();

  // 서버에 회원 등록/로그인 요청
  Future<void> register(String uuid, {String? fcmToken}) async {
    try {
      final response = await _apiClient.dio.post(
        '/members/register',
        data: {
          'uuid': uuid,
          'fcm': fcmToken, // 현재는 null 가능
        },
      );
      print("✅ 회원 등록 성공: ${response.data}");
    } catch (e) {
      print("❌ 회원 등록 실패: $e");
      // 필요 시 에러 핸들링
    }
  }
}
