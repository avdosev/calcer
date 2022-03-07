import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

import 'windows_buttons.dart';

class WindowsScaffold extends StatelessWidget {
  final Widget child;

  const WindowsScaffold({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WindowTitleBarBox(
                  child: Row(children: [
                Expanded(child: MoveWindow()),
                WindowButtons()
              ])),
        Expanded(child: child),
      ],
    );
  }
}
