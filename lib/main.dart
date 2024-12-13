import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // FlutterBackgroundを初期化
  final bool initialized = await FlutterBackground.initialize(
    androidConfig: const FlutterBackgroundAndroidConfig(
      notificationTitle: '位置情報取得中',
      notificationText: 'バックグラウンドで位置情報を取得しています',
    ),
  );

  if (!initialized) {
    print('FlutterBackgroundの初期化に失敗しました。');
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      themeMode: ThemeMode.dark,
      title: 'flutter geoloc2',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
