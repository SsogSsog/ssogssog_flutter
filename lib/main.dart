import 'package:flutter/material.dart';
import 'app/app.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:dio/dio.dart';
import 'package:ssogssog_flutter/core/network/api_client.dart';
import 'package:ssogssog_flutter/features/auth/data/repository/member_repository.dart';
import 'package:ssogssog_flutter/features/auth/data/service/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // 1. Auth Init (UUID 생성/로드)
  final authService = AuthService();
  final uuid = await authService.getDeviceUuid();
  
  print('📱 Device UUID: $uuid');

  // 2. ApiClient Interceptor 설정 (모든 요청에 헤더 추가)
  ApiClient().dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers['X-User-ID'] = uuid;
        return handler.next(options);
      },
    ),
  );

  // 3. 서버에 회원 등록 (비동기 실행 - 앱 시작 속도 저하 방지)
  MemberRepository().register(uuid).then((_) {
    print('✅ Member Registration Initiated');
  }).catchError((e) {
    print('❌ Member Registration Error: $e');
  });

  runApp(MyApp());
}
