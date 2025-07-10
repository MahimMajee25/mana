import 'package:flutter/material.dart';

class CustomVerticalSlider extends StatefulWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const CustomVerticalSlider({
    required this.value,
    required this.onChanged,
  });

  @override
  _CustomVerticalSliderState createState() => _CustomVerticalSliderState();
}

class _CustomVerticalSliderState extends State<CustomVerticalSlider> {
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
            // Background track with full height
            CustomPaint(
              painter: _BackgroundTrackPainter(
                trackWidth: trackWidth,
                padding: padding,
                numberHeight: numberHeight,
              ),
              size: Size(constraints.maxWidth, constraints.maxHeight),
            ),

            // Tick marks
            CustomPaint(
              painter: _TickPainter(),
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
              left: (constraints.maxWidth - thumbRadius * 2) / 2+6,
              top: thumbPosition - thumbRadius+5,
              child: Container(
                width: 20,
                height:20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                  border: Border.all(color: Colors.red, width: 4),
                ),
              ),
            ),

            // Value display
            if(widget.value.toInt()!=0)
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

class _BackgroundTrackPainter extends CustomPainter {
  final double trackWidth;
  final double padding;
  final double numberHeight;

  _BackgroundTrackPainter({
    required this.trackWidth,
    required this.padding,
    required this.numberHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Create full height track with same shape as fill
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTRB(
        size.width / 2 - trackWidth / 2,
        padding-19,
        size.width / 2 + trackWidth / 2,
        size.height - numberHeight,
      ),
      const Radius.circular(40),
    );

    final backgroundPaint = Paint()
      ..color = Color.fromRGBO(243, 244, 241, 0.3)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(rect, backgroundPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TickPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final tickPaint = Paint()
      ..color = Color.fromRGBO(243, 244, 241, 0.1)
      ..strokeWidth = 2;

    const double padding = 24;
    const double numberHeight = 36;
    final trackHeight = size.height - numberHeight - (padding * 2);
    final spacing = trackHeight / 10; // Changed from 9 to 10 for 0-10 scale

    for (int i = 0; i <= 10; i++) { // Changed from 9 to 10
      final dy = padding + (i * spacing)+20;
      canvas.drawLine(
        Offset(size.width / 2 - 12, dy),
        Offset(size.width / 2 + 12, dy),
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
      ..color = Color.fromRGBO(243, 244, 241, 0.3)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    canvas.drawRRect(rect, fillPaint);
    canvas.drawRRect(rect, borderPaint);
  }

  @override
  bool shouldRepaint(_FillPainter oldDelegate) =>
      oldDelegate.value != value || oldDelegate.thumbPosition != thumbPosition;
}