import 'package:calcer/common/expression.dart';
import 'package:flutter/cupertino.dart';

class CallculatorController extends ChangeNotifier {
  var _currentSelection = TextSelection(
    baseOffset: 0,
    extentOffset: 0,
  );
  final controller = TextEditingController(text: '');
  double fontSize = 80;
  final GlobalKey textFieldKey = GlobalKey();
  final textFieldPadding = const EdgeInsets.only(right: 8.0);
  final textFieldTextStyle = const TextStyle(
    fontWeight: FontWeight.w300,
    fontSize: 80,
  );

  bool useRadians = false;
  void invertUseRadians() {
    useRadians = !useRadians;
    notifyListeners();
  }

  //bool _toggled = false;
  /// Whether or not the result is an error.
  bool errored = false;

  /// Whether or not the result is an Easter egg.
  /// Refrain from using this for real calculations.
  bool egged = false;

  bool secondaryErrorVisible = false;
  String secondaryErrorValue = "";

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final inputWidth =
        textFieldKey.currentContext!.size!.width - textFieldPadding.horizontal;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: controller.text,
        style: textFieldTextStyle,
      ),
    );
    textPainter.layout();

    var textWidth = textPainter.width;
    var _fontSize = textFieldTextStyle.fontSize!;

    while (textWidth > inputWidth && _fontSize > 40.0) {
      _fontSize -= 0.5;
      textPainter.text = TextSpan(
        text: controller.text,
        style: textFieldTextStyle.copyWith(fontSize: _fontSize),
      );
      textPainter.layout();
      textWidth = textPainter.width;
    }

    fontSize = _fontSize;
    notifyListeners();
  }

  void append(String character) {
    if (controller.selection.baseOffset >= 0) {
      _currentSelection = TextSelection(
        baseOffset: controller.selection.baseOffset + 1,
        extentOffset: controller.selection.extentOffset + 1,
      );
      controller.text =
          controller.text.substring(0, controller.selection.baseOffset) +
              character +
              controller.text.substring(
                  controller.selection.baseOffset, controller.text.length);
      controller.selection = _currentSelection;
    } else {
      controller.text += character;
    }
    _onTextChanged();
  }

  void clear([bool longPress = false]) {
    if (errored) {
      errored = false;
      egged = false;
      controller.text = '';
    } else if (longPress) {
      controller.text = '';
    } else {
      if (controller.selection.baseOffset >= 0) {
        _currentSelection = TextSelection(
            baseOffset: controller.selection.baseOffset - 1,
            extentOffset: controller.selection.extentOffset - 1);
        controller.text =
            controller.text.substring(0, controller.selection.baseOffset - 1) +
                controller.text.substring(
                    controller.selection.baseOffset, controller.text.length);
        controller.selection = _currentSelection;
      } else {
        controller.text =
            controller.text.substring(0, controller.text.length - 1);
      }
    }
    _onTextChanged();
  }

  int errorcount = 0;

  void equals() async {
    String expText = controller.text;
    final result = await doExpression(
      expText,
      ExpressionContext(
        useRadians: useRadians,
      ),
    );
    controller.text = result.result
        .toStringAsPrecision(13)
        .replaceAll(RegExp(r'0+$'), '')
        .replaceAll(RegExp(r'\.$'), '');
    if (controller.text == "NaN") {
      controller.text = "Impossible";
      errored = true;
    }

    _onTextChanged();
  }

  appendLabel(String label) {
    if (errored) {
      errored = false;
      egged = false;
      controller.text = '';
    }
    append(label);
  }
}
