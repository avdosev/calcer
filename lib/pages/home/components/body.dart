import 'package:calcer/providers/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

class CalculatorBody extends HookWidget {
  static const _numColor = Color.fromRGBO(48, 47, 63, .94);
  static const _twoPageBreakpoint = 640;

  const CalculatorBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fraction =
        MediaQuery.of(context).size.width > _twoPageBreakpoint ? 0.5 : 1.0;
    final pageController = usePageController(
      initialPage: 0,
      viewportFraction: fraction,
      keys: [fraction],
    );

    final invertedMode = useState(false);
    final invertMode = useCallback(
      () => invertedMode.value = !invertedMode.value,
      [invertedMode],
    );

    final controller = context.watch<CallculatorController>();

    return PageView(
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
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildButton('AC', () => controller.clear(true)),
                        _buildButton('('),
                        _buildButton(')'),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Material(
                      color: _numColor,
                      textStyle: const TextStyle(color: Colors.white),
                      clipBehavior: Clip.antiAlias,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildButton('7'),
                                _buildButton('8'),
                                _buildButton('9'),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildButton('4'),
                                _buildButton('5'),
                                _buildButton('6'),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildButton('1'),
                                _buildButton('2'),
                                _buildButton('3'),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                _buildButton('=', controller.equals),
              ],
            )),
            if (MediaQuery.of(context).size.width <= _twoPageBreakpoint)
              InkWell(
                child: Container(
                  color: Theme.of(context).colorScheme.secondary,
                  child: Icon(
                    Icons.chevron_left,
                    color: Theme.of(context).brightness == Brightness.light
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
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.white
                  : Colors.black),
          child: Row(
            children: [
              if (MediaQuery.of(context).size.width <= _twoPageBreakpoint)
                InkWell(
                  child: Container(
                    height: double.infinity,
                    //color: _opColor,
                    child: Icon(
                      Icons.chevron_right,
                      color: Theme.of(context).brightness == Brightness.light
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
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildButton(
                              invertedMode.value ? 'sin⁻¹' : 'sin',
                              () => invertedMode.value
                                  ? controller.append('sin⁻¹(')
                                  : controller.append('sin(')),
                          _buildButton(
                              invertedMode.value ? 'cos⁻¹' : 'cos',
                              () => invertedMode.value
                                  ? controller.append('cos⁻¹(')
                                  : controller.append('cos(')),
                          _buildButton(
                              invertedMode.value ? 'tan⁻¹' : 'tan',
                              () => invertedMode.value
                                  ? controller.append('tan⁻¹(')
                                  : controller.append('tan(')),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildButton(
                              invertedMode.value ? 'eˣ' : 'ln',
                              () => invertedMode.value
                                  ? controller.append('℮^(')
                                  : controller.append('ln(')),
                          _buildButton(
                              invertedMode.value ? '10ˣ' : 'log',
                              () => invertedMode.value
                                  ? controller.append('10^(')
                                  : controller.append('log(')),
                          _buildButton(
                              invertedMode.value ? 'x²' : '√',
                              () => invertedMode.value
                                  ? controller.append('^2')
                                  : controller.append('√(')),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildButton('π'),
                          _buildButton('e', () => controller.append('℮')),
                          _buildButton('^'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildButton(invertedMode.value ? '𝗜𝗡𝗩' : 'INV',
                              invertMode),
                          _buildButton(controller.useRadians ? 'RAD' : 'DEG',
                              controller.invertUseRadians),
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
    );
  }

  Widget _buildButton(String label, [Function()? func]) {
    return Builder(builder: (context) {
      final controller = Provider.of<CallculatorController>(context);

      return Expanded(
        child: InkWell(
          onTap: func ?? () => controller.appendLabel(label),
          borderRadius: BorderRadius.circular(10),
          onLongPress: (label == 'C')
              ? () => controller.clear(true)
              : (controller.errored)
                  ? () => controller.append(label)
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
