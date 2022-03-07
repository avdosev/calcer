import 'dart:io';

import 'package:calcer/common/expression.dart';
import 'package:calcer/pages/home/components/body.dart';
import 'package:calcer/providers/controller.dart';
import 'package:calcer/widgets/windows_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

class MyHomePage extends HookWidget {
  MyHomePage();

  final textFieldTextStyle = const TextStyle(
    fontWeight: FontWeight.w300,
  );
  final _opColor = Color.fromRGBO(22, 21, 29, .93);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CallculatorController(),
      child: TitlebarSafeArea(
        child: WindowsScaffold(
          child: Scaffold(
            backgroundColor: Platform.isWindows ? Colors.transparent : null,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: Row(
                children: [
                  Builder(builder: (context) {
                    final controller = context.watch<CallculatorController>();
                    return TextButton(
                      onPressed: controller.invertUseRadians,
                      child: Text(
                        controller.useRadians ? 'RAD' : 'DEG',
                        style: TextStyle(color: Theme.of(context).hintColor),
                      ),
                    );
                  }),
                ],
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      const CalculatorOutput(),
                      const Spacer(),
                    ],
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Material(
                    color: _opColor,
                    textStyle: const TextStyle(color: Colors.white),
                    child: const CalculatorBody(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CalculatorOutput extends StatelessWidget {
  const CalculatorOutput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<CallculatorController>(context);
    return TextField(
      key: controller.textFieldKey,
      controller: controller.controller,
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: controller.textFieldPadding,
      ),
      textAlign: TextAlign.right,
      style: controller.textFieldTextStyle.copyWith(
          fontSize: controller.fontSize,
          color: controller.egged
              ? Colors.lightBlue[400]
              : controller.errored
                  ? Colors.red
                  : null),
      focusNode: FocusNode(),
    );
  }
}
