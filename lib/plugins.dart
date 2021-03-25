import 'package:flutter/services.dart';

class Plugins {
  static const MethodChannel _channel = const MethodChannel('plugins');

  static void cereSpeak(String text) {
    _channel.invokeMethod('cereSpeak', {'text': text});
  }

  static void cereEngInitf() {
    print('InPlugin');
    _channel.invokeMethod('cereEngInit');
  }
}
