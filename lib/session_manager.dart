import 'dart:async';
import 'package:flutter/services.dart';


class SessionManager {
  static const MethodChannel _methodChannel =
      const MethodChannel('flutter_google_cast_plugin.SessionManager');

  static Future<void> showMediaRouteChooserDialog() async {
    return await _methodChannel.invokeMethod('showMediaRouteChooserDialog');
  }

  static Future<void> endCurrentSession(bool stopCasting) async {
    return await _methodChannel.invokeMethod('endCurrentSession', stopCasting);
  }

  static const EventChannel _castStateChannel =
      const EventChannel('flutter_google_cast_plugin.CastState');

  static Stream<dynamic> castStateStream() {
    return _castStateChannel.receiveBroadcastStream();
  }
}
