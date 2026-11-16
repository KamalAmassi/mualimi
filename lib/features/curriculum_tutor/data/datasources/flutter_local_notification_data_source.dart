import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../../core/constants/app_strings.dart';
import 'local_notification_data_source.dart';

class FlutterLocalNotificationDataSource
    implements LocalNotificationDataSource {
  FlutterLocalNotificationDataSource({FlutterLocalNotificationsPlugin? plugin})
      : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  static const _channelId = 'tutor_answers';
  static const _icon = '@mipmap/ic_launcher';

  final FlutterLocalNotificationsPlugin _plugin;
  final _taps = StreamController<String>.broadcast();
  Future<bool>? _ready;

  @override
  Stream<String> get taps => _taps.stream;

  @override
  Future<void> show({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!await _prepare()) return;
    await _plugin.show(
      id: id,
      title: title,
      body: body,
      payload: payload,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          AppStrings.answersChannelName,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }

  @override
  Future<void> requestPermission() async {
    if (!await _prepare()) return;
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<bool> _prepare() => _ready ??= _initialize();

  /// False when the host has no notification implementation (desktop and
  /// test hosts). Answers must still work there, so this never throws.
  Future<bool> _initialize() async {
    try {
      await _plugin.initialize(
        settings: const InitializationSettings(
            android: AndroidInitializationSettings(_icon)),
        onDidReceiveNotificationResponse: (response) {
          final payload = response.payload;
          if (payload != null) _taps.add(payload);
        },
      );
      return true;
    } on Error {
      return false;
    }
  }
}
