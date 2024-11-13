import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InnerPipUtil {
  static MethodChannel channel =
      const MethodChannel("inner_channel_pip_plugin");

  static Future<bool?> get alreadyDisplayedPip {
    try {
      return channel.invokeMethod("alreadyDisplayedPip");
    } catch (e) {
      return Future.value(false);
    }
  }

  /// Return value: operate success.
  static Future<bool?> displayOrHide() async {
    if (await alreadyDisplayedPip ?? false) {
      return disposeThePip();
    } else {
      return displayThePipWindow();
    }
  }

  static Future<bool?> displayThePipWindow() async {
    return channel.invokeMethod("displayThePipWindow");
  }

  static Future<bool?> disposeThePip() {
    return channel.invokeMethod("disposeThePip");
  }

  static Future<bool?> setDisplayText(
      String name, String content, List<Map> chatList) async {
    if (!(await alreadyDisplayedPip ?? false)) {
      if (kDebugMode) {
        print("the pip window is not displayed, so the text will not be set.");
      }
      return false;
    }

    return channel.invokeMethod("setDisplayText",
        {"name": name, "content": content, "chatList": chatList});
  }

  static Widget pipNativeWidget() {
    return const SizedBox(
      width: 0.1,
      height: 0.1,
      child: UiKitView(viewType: "FlutterPipWidget-UiKitType"),
    );
  }
}
