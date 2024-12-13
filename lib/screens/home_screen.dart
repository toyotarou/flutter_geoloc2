import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../controllers/geoloc/geoloc.dart';

// import 'package:mailer/mailer.dart';
// import 'package:mailer/smtp_server.dart';
//
//
//

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Position? _currentPosition;

  ///
  @override
  void initState() {
    super.initState();
    _startLocationTracking();
  }

  ///
  Future<void> _startLocationTracking() async {
    final bool hasPermission = await _requestPermission();
    if (!hasPermission) {
      return;
    }

    // FlutterBackgroundのバックグラウンド実行を有効化
    final bool enabled = await FlutterBackground.enableBackgroundExecution();

    if (!enabled) {
      print('バックグラウンド実行の有効化に失敗しました。');
      return;
    }

    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      setState(() {
        _currentPosition = position;

        // mailSend(position: position);
        //
        //
        //
        //
        //

        ref
            .read(geolocProvider.notifier)
            .inputGeoloc(latitude: position.latitude.toString(), longitude: position.longitude.toString());
      });

      // サーバーへの送信やログ保存など
      print('位置情報: ${position.latitude}, ${position.longitude}');
    });
  }

  // ///
  // Future<void> mailSend({required Position position}) async {
  //   String username = 'hide.toyoda@gmail.com'; // 送信元メールアドレス
  //   String password = 'hidechy4819'; // メールアカウントのパスワード
  //
  //   final smtpServer = gmail(username, password); // Gmailを使用する場合
  //   final message = Message()
  //     ..from = Address(username, 'あなたの名前')
  //     ..recipients.add('hide.toyoda@gmail.com') // 宛先
  //     ..subject = '位置情報'
  //     ..text = '${position.latitude} | ${position.longitude}';
  //
  //   try {
  //     final sendReport = await send(message, smtpServer);
  //     print('メール送信成功: $sendReport');
  //   } catch (e) {
  //     print('メール送信失敗: $e');
  //   }
  // }
  //
  //

  ///
  Future<bool> _requestPermission() async {
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('位置情報サービスが無効です。');
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('位置情報の権限が拒否されました。');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('位置情報の権限が永久に拒否されています。設定を確認してください。');
      return false;
    }
    return true;
  }

  ///
  @override
  void dispose() {
    FlutterBackground.disableBackgroundExecution();
    super.dispose();
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('バックグラウンド位置情報追跡'),
      ),
      body: Center(
        child: _currentPosition == null
            ? const Text('位置情報を取得中...')
            : Text(
                '緯度: ${_currentPosition!.latitude}, 経度: ${_currentPosition!.longitude}',
                style: const TextStyle(fontSize: 16),
              ),
      ),
    );
  }
}
