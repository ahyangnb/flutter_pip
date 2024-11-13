import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_pip_platform_interface.dart';

/// An implementation of [FlutterPipPlatform] that uses method channels.
class MethodChannelFlutterPip extends FlutterPipPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_pip');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
