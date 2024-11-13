
import 'flutter_pip_platform_interface.dart';
export 'inner_pip_util.dart';

class FlutterPip {
  Future<String?> getPlatformVersion() {
    return FlutterPipPlatform.instance.getPlatformVersion();
  }
}
