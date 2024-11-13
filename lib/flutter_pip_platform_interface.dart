import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_pip_method_channel.dart';

abstract class FlutterPipPlatform extends PlatformInterface {
  /// Constructs a FlutterPipPlatform.
  FlutterPipPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterPipPlatform _instance = MethodChannelFlutterPip();

  /// The default instance of [FlutterPipPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterPip].
  static FlutterPipPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterPipPlatform] when
  /// they register themselves.
  static set instance(FlutterPipPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
