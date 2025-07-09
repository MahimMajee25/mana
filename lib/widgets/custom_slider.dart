// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
//
// class VerticalRangeSelector extends StatefulWidget {
//   const VerticalRangeSelector({super.key});
//
//   @override
//   _VerticalRangeSelectorState createState() => _VerticalRangeSelectorState();
// }
//
// class _VerticalRangeSelectorState extends State<VerticalRangeSelector> {
//   double _value = 6;
//   double? _lastValue;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'HOW MANY TIMES PER DAY DO YOU PREFER TO EAT?',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 16,
//                 letterSpacing: 0.5,
//               ),
//             ),
//             SizedBox(height: 30),
//             Center(
//               child: SizedBox(
//                 height: 320,
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     // Tick lines (background)
//                     Positioned.fill(
//                       child: CustomPaint(
//                         painter: _TickLinePainter(),
//                       ),
//                     ),
//                     RotatedBox(
//                       quarterTurns: -1,
//                       child: SliderTheme(
//                         data: SliderTheme.of(context).copyWith(
//                           activeTrackColor: Colors.transparent,
//                           inactiveTrackColor: Colors.transparent,
//                           trackHeight: 60,
//                           overlayShape: SliderComponentShape.noOverlay,
//                           thumbShape: _CustomThumbShape(),
//                           tickMarkShape: RoundSliderTickMarkShape(tickMarkRadius: 0),
//                           activeTickMarkColor: Colors.transparent,
//                           inactiveTickMarkColor: Colors.transparent,
//                         ),
//                         child: Slider(
//                           value: _value,
//                           min: 1,
//                           max: 10,
//                           divisions: 9,
//                           onChanged: (val) {
//                             setState(() {
//                               _value = val;
//
//                               // Haptic feedback on value change
//                               if (_lastValue != val) {
//                                 HapticFeedback.lightImpact();
//                                 _lastValue = val;
//                               }
//                             });
//                           },
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             Text(
//               _value.toInt().toString(),
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 24,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             SizedBox(height: 4),
//             Text(
//               'TIMES A DAY',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 16,
//                 letterSpacing: 0.4,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _CustomThumbShape extends SliderComponentShape {
//   @override
//   Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size(32, 32);
//
//   @override
//   void paint(
//       PaintingContext context,
//       Offset center, {
//         required Animation<double> activationAnimation,
//         required Animation<double> enableAnimation,
//         required bool isDiscrete,
//         required TextPainter labelPainter,
//         required RenderBox parentBox,
//         required SliderThemeData sliderTheme,
//         required TextDirection textDirection,
//         required double value,
//         required double textScaleFactor,
//         required Size sizeWithOverflow,
//       }) {
//     final Canvas canvas = context.canvas;
//
//     final outerPaint = Paint()
//       ..color = Colors.red
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 3;
//
//     canvas.drawCircle(center, 12, outerPaint);
//
//     final innerPaint = Paint()
//       ..color = Colors.black
//       ..style = PaintingStyle.fill;
//
//     canvas.drawCircle(center, 10, innerPaint);
//   }
// }
//
// class _TickLinePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final tickPaint = Paint()
//       ..color = Colors.grey.shade800
//       ..strokeWidth = 1;
//
//     final spacing = size.height / 9;
//     for (int i = 0; i <= 9; i++) {
//       final dy = i * spacing;
//       canvas.drawLine(Offset(size.width / 2 - 10, dy), Offset(size.width / 2 + 10, dy), tickPaint);
//     }
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => false;
// }


/*
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VerticalRangeSelector extends StatefulWidget {
  const VerticalRangeSelector({super.key});

  @override
  _VerticalRangeSelectorState createState() => _VerticalRangeSelectorState();
}

class _VerticalRangeSelectorState extends State<VerticalRangeSelector> {
  double _value = 6;
  double? _lastValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'HOW MANY TIMES PER DAY DO YOU PREFER TO EAT?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 30),
            Center(
              child: SizedBox(
                height: 320,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Tick lines (background)
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _TickLinePainter(),
                      ),
                    ),

                    // Area below the thumb
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _SliderFillPainter(value: _value),
                      ),
                    ),

                    // Vertical slider
                    RotatedBox(
                      quarterTurns: -1,
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: Colors.transparent,
                          inactiveTrackColor: Colors.transparent,
                          trackHeight: 60,
                          overlayShape: SliderComponentShape.noOverlay,
                          thumbShape: _CustomThumbShape(),
                          tickMarkShape: RoundSliderTickMarkShape(tickMarkRadius: 0),
                          activeTickMarkColor: Colors.transparent,
                          inactiveTickMarkColor: Colors.transparent,
                        ),
                        child: Slider(
                          value: _value,
                          min: 1,
                          max: 10,
                          divisions: 9,
                          onChanged: (val) {
                            setState(() {
                              _value = val;

                              if (_lastValue != val) {
                                HapticFeedback.lightImpact();
                                _lastValue = val;
                              }
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              _value.toInt().toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'TIMES A DAY',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomThumbShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size(32, 32);

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        required Animation<double> activationAnimation,
        required Animation<double> enableAnimation,
        required bool isDiscrete,
        required TextPainter labelPainter,
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required TextDirection textDirection,
        required double value,
        required double textScaleFactor,
        required Size sizeWithOverflow,
      }) {
    final Canvas canvas = context.canvas;

    final outerPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawCircle(center, 12, outerPaint);

    final innerPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 10, innerPaint);
  }
}

class _TickLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final tickPaint = Paint()
      ..color = Colors.grey.shade800
      ..strokeWidth = 1;

    final spacing = size.height / 9;
    for (int i = 0; i <= 9; i++) {
      final dy = i * spacing;
      canvas.drawLine(Offset(size.width / 2 - 10, dy), Offset(size.width / 2 + 10, dy), tickPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _SliderFillPainter extends CustomPainter {
  final double value;

  _SliderFillPainter({required this.value});

  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;

    const divisions = 9;
    const double thumbRadius = 16; // Half of the thumb size (32x32)
    const double borderWidth = 2;

    // Total vertical range for 9 steps (10 values = 9 gaps)
    final double spacing = height / divisions;

    // Compute thumb Y-center
    final thumbCenterY = height - ((value - 1) * spacing);

    // Draw from bottom to (thumb center + thumb radius)
    final fillTop = thumbCenterY - thumbRadius - borderWidth;
    final fillBottom = height;

    final fillHeight = fillBottom - fillTop;

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(width / 2 - 20, fillTop, 40, fillHeight),
      Radius.circular(40),
    );

    final fillPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    canvas.drawRRect(rect, fillPaint);
    canvas.drawRRect(rect, borderPaint);
  }

  @override
  bool shouldRepaint(_SliderFillPainter oldDelegate) =>
      oldDelegate.value != value;
}
*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VerticalRangeSelector extends StatefulWidget {
  const VerticalRangeSelector({super.key});

  @override
  _VerticalRangeSelectorState createState() => _VerticalRangeSelectorState();
}

class _VerticalRangeSelectorState extends State<VerticalRangeSelector> {
  double _value = 6;
  double? _lastValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'HOW MANY TIMES PER DAY DO YOU PREFER TO EAT?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 30),
            Center(
              child: SizedBox(
                height: 360, // increased to accommodate number inside border
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Tick lines
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _TickLinePainter(),
                      ),
                    ),

                    // Fill with number and border
                    Positioned.fill(
                      child: _SliderFillWithValuePainter(value: _value),
                    ),

                    // Slider
                    RotatedBox(
                      quarterTurns: -1,
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: Colors.transparent,
                          inactiveTrackColor: Colors.transparent,
                          trackHeight: 60,
                          overlayShape: SliderComponentShape.noOverlay,
                          thumbShape: _CustomThumbShape(),
                          tickMarkShape: RoundSliderTickMarkShape(tickMarkRadius: 0),
                          activeTickMarkColor: Colors.transparent,
                          inactiveTickMarkColor: Colors.transparent,
                        ),
                        child: Slider(
                          value: _value,
                          min: 1,
                          max: 10,
                          divisions: 9,
                          onChanged: (val) {
                            setState(() {
                              _value = val;
                              if (_lastValue != val) {
                                HapticFeedback.lightImpact();
                                _lastValue = val;
                              }
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),
            Text(
              'TIMES A DAY',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomThumbShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size(32, 32);

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        required Animation<double> activationAnimation,
        required Animation<double> enableAnimation,
        required bool isDiscrete,
        required TextPainter labelPainter,
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required TextDirection textDirection,
        required double value,
        required double textScaleFactor,
        required Size sizeWithOverflow,
      }) {
    final Canvas canvas = context.canvas;

    final outerPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawCircle(center, 12, outerPaint);

    final innerPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 10, innerPaint);
  }
}

class _TickLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final tickPaint = Paint()
      ..color = Colors.grey.shade800
      ..strokeWidth = 1;

    final spacing = size.height / 9;
    for (int i = 0; i <= 9; i++) {
      final dy = i * spacing;
      canvas.drawLine(
        Offset(size.width / 2 - 10, dy),
        Offset(size.width / 2 + 10, dy),
        tickPaint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _SliderFillWithValuePainter extends StatelessWidget {
  final double value;
  const _SliderFillWithValuePainter({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SliderFillPainter(value),
      child: Container(
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.only(bottom: 12),
        child: Text(
          value.toInt().toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _SliderFillPainter extends CustomPainter {
  final double value;

  _SliderFillPainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;

    const divisions = 9;
    const double thumbRadius = 16;
    const double numberHeight = 36; // approximate height for number text + padding

    final spacing = (height - numberHeight) / divisions;
    final thumbCenterY = height - numberHeight - ((value - 1) * spacing);

    final fillTop = thumbCenterY - thumbRadius - 2; // ensure thumb is inside
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTRB(width / 2 - 20, fillTop, width / 2 + 20, height),
      Radius.circular(40),
    );

    final fillPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawRRect(rect, fillPaint);
    canvas.drawRRect(rect, borderPaint);
  }

  @override
  bool shouldRepaint(_SliderFillPainter oldDelegate) => oldDelegate.value != value;
}
