import 'package:calcer/providers/controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CalculatorOutput extends StatelessWidget {
  const CalculatorOutput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CallculatorController>();
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
