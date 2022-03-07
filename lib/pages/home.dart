import 'dart:io';

import 'package:calcer/common/expression.dart';
import 'package:calcer/widgets/windows_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MyHomePage extends HookWidget {
  // Statics
  TextSelection _currentSelection =
      TextSelection(baseOffset: 0, extentOffset: 0);
  final GlobalKey _textFieldKey = GlobalKey();
  final textFieldPadding = EdgeInsets.only(right: 8.0);
  static TextStyle textFieldTextStyle =
      TextStyle(fontSize: 80.0, fontWeight: FontWeight.w300);
  Color _numColor = Color.fromRGBO(48, 47, 63, .94);
  Color _opColor = Color.fromRGBO(22, 21, 29, .93);
  double? _fontSize = textFieldTextStyle.fontSize;
  static const _twoPageBreakpoint = 640;
  // Controllers
  TextEditingController _controller = TextEditingController(text: '');

  //bool _toggled = false;
  /// Whether or not the result is an error.
  bool _errored = false;

  /// Whether or not the result is an Easter egg.
  /// Refrain from using this for real calculations.
  bool _egged = false;

  bool _secondaryErrorVisible = false;
  String _secondaryErrorValue = "";

  void _onTextChanged() {
    final inputWidth =
        _textFieldKey.currentContext!.size!.width - textFieldPadding.horizontal;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: _controller.text,
        style: textFieldTextStyle,
      ),
    );
    textPainter.layout();

    var textWidth = textPainter.width;
    var fontSize = textFieldTextStyle.fontSize;

    while (textWidth > inputWidth && fontSize! > 40.0) {
      fontSize -= 0.5;
      textPainter.text = TextSpan(
        text: _controller.text,
        style: textFieldTextStyle.copyWith(fontSize: fontSize),
      );
      textPainter.layout();
      textWidth = textPainter.width;
    }

    _fontSize = fontSize;
  }

  void _append(String character) {
    if (_controller.selection.baseOffset >= 0) {
      _currentSelection = TextSelection(
        baseOffset: _controller.selection.baseOffset + 1,
        extentOffset: _controller.selection.extentOffset + 1,
      );
      _controller.text =
          _controller.text.substring(0, _controller.selection.baseOffset) +
              character +
              _controller.text.substring(
                  _controller.selection.baseOffset, _controller.text.length);
      _controller.selection = _currentSelection;
    } else {
      _controller.text += character;
    }
    _onTextChanged();
  }

  void _clear([bool longPress = false]) {
    if (_errored) {
      _errored = false;
      _egged = false;
      _controller.text = '';
    } else if (longPress) {
      _controller.text = '';
    } else {
      if (_controller.selection.baseOffset >= 0) {
        _currentSelection = TextSelection(
            baseOffset: _controller.selection.baseOffset - 1,
            extentOffset: _controller.selection.extentOffset - 1);
        _controller.text = _controller.text
                .substring(0, _controller.selection.baseOffset - 1) +
            _controller.text.substring(
                _controller.selection.baseOffset, _controller.text.length);
        _controller.selection = _currentSelection;
      } else {
        _controller.text =
            _controller.text.substring(0, _controller.text.length - 1);
      }
    }
    _onTextChanged();
  }

  int errorcount = 0;

  void _equals() async {
    String expText = _controller.text;
    final result = await doExpression(expText);
    _controller.text = result.result
        .toStringAsPrecision(13)
        .replaceAll(RegExp(r'0+$'), '')
        .replaceAll(RegExp(r'\.$'), '');
    if (_controller.text == "NaN") {
      _controller.text = "Impossible";
      _errored = true;
    }

    _onTextChanged();
  }

  @override
  Widget build(BuildContext context) {
    /// Defaults to degree mode (false)
    final useRadians = useState(false);

    /// Refers to the sin, cos, sqrt, etc.
    final invertedMode = useState(false);
    final invertUseRadians = useCallback(
      () => useRadians.value = !useRadians.value,
      [useRadians],
    );
    final invertMode = useCallback(
      () => invertedMode.value = !invertedMode.value,
      [invertedMode],
    );

    final fraction =
        MediaQuery.of(context).size.width > _twoPageBreakpoint ? 0.5 : 1.0;
    final pageController = usePageController(
      initialPage: 0,
      viewportFraction: fraction,
      keys: [fraction],
    );

    return TitlebarSafeArea(
      child: WindowsScaffold(
        child: Scaffold(
          backgroundColor: Platform.isWindows ? Colors.transparent : null,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            title: Row(
              children: [
                TextButton(
                  onPressed: invertUseRadians,
                  child: Text(
                    useRadians.value ? 'RAD' : 'DEG',
                    style: TextStyle(color: Theme.of(context).hintColor),
                  ),
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    TextField(
                      key: _textFieldKey,
                      controller: _controller,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: textFieldPadding,
                      ),
                      textAlign: TextAlign.right,
                      style: textFieldTextStyle.copyWith(
                          fontSize: _fontSize,
                          color: _egged
                              ? Colors.lightBlue[400]
                              : _errored
                                  ? Colors.red
                                  : null),
                      focusNode: FocusNode(),
                    ),
                    Expanded(child: Container()),
                  ],
                ),
              ),
              Expanded(
                flex: 5,
                child: Material(
                  color: _opColor,
                  textStyle: const TextStyle(color: Colors.white),
                  child: PageView(
                    controller: pageController,
                    padEnds: false,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              children: [
                                Expanded(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _buildButton('AC', () => _clear(true)),
                                      _buildButton('('),
                                      _buildButton(')'),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Material(
                                    color: _numColor,
                                    textStyle:
                                        const TextStyle(color: Colors.white),
                                    clipBehavior: Clip.antiAlias,
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(8),
                                    ),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              _buildButton('7'),
                                              _buildButton('8'),
                                              _buildButton('9'),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              _buildButton('4'),
                                              _buildButton('5'),
                                              _buildButton('6'),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              _buildButton('1'),
                                              _buildButton('2'),
                                              _buildButton('3'),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              _buildButton('%'),
                                              _buildButton('0'),
                                              _buildButton('.'),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                              child: Column(
                            children: <Widget>[
                              _buildButton('÷'),
                              _buildButton('×'),
                              _buildButton('-'),
                              _buildButton('+'),
                              _buildButton('=', _equals),
                            ],
                          )),
                          if (MediaQuery.of(context).size.width <=
                              _twoPageBreakpoint)
                            InkWell(
                              child: Container(
                                color: Theme.of(context).colorScheme.secondary,
                                child: Icon(
                                  Icons.chevron_left,
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              onTap: () => pageController.animateToPage(
                                1,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.ease,
                              ),
                            ),
                        ],
                      ),
                      Material(
                        color: Theme.of(context).colorScheme.secondary,
                        textStyle: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.white
                                    : Colors.black),
                        child: Row(
                          children: [
                            if (MediaQuery.of(context).size.width <=
                                _twoPageBreakpoint)
                              InkWell(
                                child: Container(
                                  height: double.infinity,
                                  //color: _opColor,
                                  child: Icon(
                                    Icons.chevron_right,
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                onTap: () => pageController.animateToPage(
                                  0,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.ease,
                                ),
                              ),
                            Expanded(
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        _buildButton(
                                            invertedMode.value
                                                ? 'sin⁻¹'
                                                : 'sin',
                                            () => invertedMode.value
                                                ? _append('sin⁻¹(')
                                                : _append('sin(')),
                                        _buildButton(
                                            invertedMode.value
                                                ? 'cos⁻¹'
                                                : 'cos',
                                            () => invertedMode.value
                                                ? _append('cos⁻¹(')
                                                : _append('cos(')),
                                        _buildButton(
                                            invertedMode.value
                                                ? 'tan⁻¹'
                                                : 'tan',
                                            () => invertedMode.value
                                                ? _append('tan⁻¹(')
                                                : _append('tan(')),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        _buildButton(
                                            invertedMode.value ? 'eˣ' : 'ln',
                                            () => invertedMode.value
                                                ? _append('℮^(')
                                                : _append('ln(')),
                                        _buildButton(
                                            invertedMode.value ? '10ˣ' : 'log',
                                            () => invertedMode.value
                                                ? _append('10^(')
                                                : _append('log(')),
                                        _buildButton(
                                            invertedMode.value ? 'x²' : '√',
                                            () => invertedMode.value
                                                ? _append('^2')
                                                : _append('√(')),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        _buildButton('π'),
                                        _buildButton('e', () => _append('℮')),
                                        _buildButton('^'),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        _buildButton(
                                            invertedMode.value
                                                ? '𝗜𝗡𝗩'
                                                : 'INV',
                                            invertMode),
                                        _buildButton(
                                            useRadians.value ? 'RAD' : 'DEG',
                                            invertUseRadians),
                                        _buildButton('!'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String label, [Function()? func]) {
    func ??= () {
      if (_errored) {
        _errored = false;
        _egged = false;
        _controller.text = '';
      }
      _append(label);
    };

    return Builder(builder: (context) {
      return Expanded(
        child: InkWell(
          onTap: func,
          borderRadius: BorderRadius.circular(10),
          onLongPress: (label == 'C')
              ? () => _clear(true)
              : (_errored)
                  ? () => _append(label)
                  : null,
          child: Center(
              child: Text(
            label,
            style: TextStyle(
              fontSize:
                  MediaQuery.of(context).orientation == Orientation.portrait
                      ? 32.0
                      : 24.0,
              fontWeight: FontWeight.w300,
            ),
          )),
        ),
      );
    });
  }
}
