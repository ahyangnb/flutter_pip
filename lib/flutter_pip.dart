
import 'flutter_pip_platform_interface.dart';

class FlutterPip {
  Future<String?> getPlatformVersion() {
    return FlutterPipPlatform.instance.getPlatformVersion();
  }
}
