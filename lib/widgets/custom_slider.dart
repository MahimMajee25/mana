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
            const Text(
              'HOW MANY TIMES PER DAY DO YOU PREFER TO EAT?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: SizedBox(
                height: 360,
                child: _CustomVerticalSlider(
                  value: _value,
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
            const SizedBox(height: 12),
            const Text(
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

class _CustomVerticalSlider extends StatefulWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const _CustomVerticalSlider({
    required this.value,
    required this.onChanged,
  });

  @override
  _CustomVerticalSliderState createState() => _CustomVerticalSliderState();
}

class _CustomVerticalSliderState extends State<_CustomVerticalSlider> {
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const double thumbRadius = 16;
        const double trackWidth = 36;
        const double numberHeight = 36;
        const double padding = 24;

        final trackHeight = constraints.maxHeight - numberHeight - (padding * 2);
        final thumbPosition = _calculateThumbPosition(trackHeight, padding, numberHeight);

        return Stack(
          children: [
            CustomPaint(
              painter: _TrackPainter(),
              size: Size(constraints.maxWidth, constraints.maxHeight),
            ),

            // Fill area
            CustomPaint(
              painter: _FillPainter(
                value: widget.value,
                thumbPosition: thumbPosition,
                trackWidth: trackWidth,
              ),
              size: Size(constraints.maxWidth, constraints.maxHeight),
            ),

            // Thumb
            Positioned(
              left: (constraints.maxWidth - thumbRadius * 2) / 2,
              top: thumbPosition - thumbRadius,
              child: Container(
                width: thumbRadius * 2,
                height: thumbRadius * 2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                  border: Border.all(color: Colors.red, width: 3),
                ),
              ),
            ),

            // Value display
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              top: 250,
              child: Center(
                child: Text(
                  widget.value.toInt().toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            // Gesture detector
            GestureDetector(
              onPanStart: (details) {
                _isDragging = true;
                _updateValue(details.localPosition.dy, trackHeight, padding, numberHeight);
              },
              onPanUpdate: (details) {
                if (_isDragging) {
                  _updateValue(details.localPosition.dy, trackHeight, padding, numberHeight);
                }
              },
              onPanEnd: (details) {
                _isDragging = false;
              },
              child: Container(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                color: Colors.transparent,
              ),
            ),
          ],
        );
      },
    );
  }

  double _calculateThumbPosition(double trackHeight, double padding, double numberHeight) {
    final normalizedValue = widget.value / 10; // 0 to 1 (changed from (value - 1) / 9)
    return padding + (trackHeight * (1 - normalizedValue)); // Inverted so 10 is at top
  }

  void _updateValue(double dy, double trackHeight, double padding, double numberHeight) {
    final adjustedY = dy - padding;
    final normalizedPosition = (trackHeight - adjustedY) / trackHeight; // Inverted
    final clampedPosition = normalizedPosition.clamp(0.0, 1.0);
    final newValue = clampedPosition * 10; // Changed from 1 + (clampedPosition * 9)
    final roundedValue = newValue.round().toDouble().clamp(0.0, 10.0); // Changed from 1.0, 10.0

    if (roundedValue != widget.value) {
      widget.onChanged(roundedValue);
    }
  }
}

class _TrackPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final tickPaint = Paint()
      ..color = Colors.grey // Changed from Colors.grey.shade800 to Colors.grey
      ..strokeWidth = 1;

    const double padding = 24;
    const double numberHeight = 36;
    final trackHeight = size.height - numberHeight - (padding * 2);
    final spacing = trackHeight / 10; // Changed from 9 to 10 for 0-10 scale

    for (int i = 0; i <= 10; i++) { // Changed from 9 to 10
      final dy = padding + (i * spacing);
      canvas.drawLine(
        Offset(size.width / 2 - 10, dy),
        Offset(size.width / 2 + 10, dy),
        tickPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FillPainter extends CustomPainter {
  final double value;
  final double thumbPosition;
  final double trackWidth;

  _FillPainter({
    required this.value,
    required this.thumbPosition,
    required this.trackWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const double thumbRadius = 16;
    const double numberHeight = 36;

    final fillTop = thumbPosition - thumbRadius - 2;
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTRB(
        size.width / 2 - trackWidth / 2,
        fillTop,
        size.width / 2 + trackWidth / 2,
        size.height - numberHeight,
      ),
      const Radius.circular(40),
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
  bool shouldRepaint(_FillPainter oldDelegate) =>
      oldDelegate.value != value || oldDelegate.thumbPosition != thumbPosition;
}