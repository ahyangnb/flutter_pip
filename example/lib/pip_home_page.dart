import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PipOverlay extends StatefulWidget {
  const PipOverlay({super.key});

  @override
  State<PipOverlay> createState() => _PipOverlayState();
}

class _PipOverlayState extends State<PipOverlay> {
  RxInt randomInt = 0.obs;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      randomInt.value =
          DateTime.now().millisecondsSinceEpoch; // Example random value
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Obx(() {
            return Text("Flutter Pip ${randomInt.value}");
          }),
        ),
      ),
    );
  }
}
