import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';

import 'pages/pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Window.initialize();
  if (Platform.isWindows) {
    await Window.hideWindowControls();
  }
  await Window.setEffect(
    effect: WindowEffect.acrylic,
    color: const Color(0x22222222),
  );
  if (Platform.isWindows) {
    doWhenWindowReady(() {
      appWindow
        ..minSize = Size(360, 640)
        ..size = Size(540, 720)
        ..show();
    });
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calcer',
      theme: ThemeData(
        brightness: Platform.isWindows ? Brightness.dark : null,
        primarySwatch: Colors.blue,
        hintColor: Platform.isWindows ? Colors.blueGrey : null,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      themeMode: ThemeMode.system,
      home: MyHomePage(),
    );
  }
}
