import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_pip/flutter_pip.dart';
import 'package:flutter_pip/flutter_pip_platform_interface.dart';
import 'package:flutter_pip/flutter_pip_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterPipPlatform
    with MockPlatformInterfaceMixin
    implements FlutterPipPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterPipPlatform initialPlatform = FlutterPipPlatform.instance;

  test('$MethodChannelFlutterPip is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterPip>());
  });

  test('getPlatformVersion', () async {
    FlutterPip flutterPipPlugin = FlutterPip();
    MockFlutterPipPlatform fakePlatform = MockFlutterPipPlatform();
    FlutterPipPlatform.instance = fakePlatform;

    expect(await flutterPipPlugin.getPlatformVersion(), '42');
  });
}
