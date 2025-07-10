import 'package:flutter/material.dart';

class RangeSliderOk extends StatefulWidget {
  const RangeSliderOk({super.key});

  @override
  State<RangeSliderOk> createState() => _RangeSliderOkState();
}

class _RangeSliderOkState extends State<RangeSliderOk> {
  RangeValues _currentRangeValues = const RangeValues(1, 5);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SliderTheme(
        data: SliderThemeData(
          rangeTickMarkShape: CustomRangeTickShape(),
          trackShape: RoundedRectSliderTrackShape(),
          rangeThumbShape: CustomRangeThumbShape(),
          trackHeight: 36,
          inactiveTrackColor: Color(0x10F3F4F1),
          activeTrackColor: Color(0xFF1A1B18),
        ),
        child: RangeSlider(
          values: _currentRangeValues,
          onChanged: (val) {
            setState(() {
              _currentRangeValues = val;
            });
          },
          min: 1,
          max: 5,
          divisions: 4, // This creates the tick marks
        ),
      ),
    );
  }
}

class CustomRangeTickShape extends RangeSliderTickMarkShape {
  @override
  Size getPreferredSize({
    required SliderThemeData sliderTheme,
    bool? isEnabled,
  }) {
    return const Size(4, 12);
  }

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required Animation<double> enableAnimation,
        required Offset startThumbCenter,
        required Offset endThumbCenter,
        bool? isEnabled,
        required TextDirection textDirection,
      }) {
    final canvas = context.canvas;

    // Determine if this tick is active (between the two thumbs)
    final bool isActive = center.dx >= startThumbCenter.dx && center.dx <= endThumbCenter.dx;

    final color = isActive
        ? sliderTheme.activeTickMarkColor ?? Colors.blue
        : sliderTheme.inactiveTickMarkColor ?? Colors.grey;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    const double tickWidth = 2;
    const double tickHeight = 12;

    canvas.drawRect(
      Rect.fromCenter(
        center: center,
        width: tickWidth,
        height: tickHeight,
      ),
      paint,
    );
  }
}

class CustomRangeThumbShape extends RangeSliderThumbShape {
  const CustomRangeThumbShape({
    this.thumbRadius = 12.0,
    this.disabledThumbRadius = 8.0,
    this.elevation = 1.0,
    this.pressedElevation = 6.0,
  });

  final double thumbRadius;
  final double disabledThumbRadius;
  final double elevation;
  final double pressedElevation;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(isEnabled ? thumbRadius : disabledThumbRadius);
  }

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        required Animation<double> activationAnimation,
        required Animation<double> enableAnimation,
        bool isDiscrete = false,
        bool isEnabled = false,
        bool? isOnTop,
        required SliderThemeData sliderTheme,
        TextDirection? textDirection,
        Thumb? thumb,
        bool? isPressed,
      }) {
    final Canvas canvas = context.canvas;
    final Tween<double> radiusTween = Tween<double>(
      begin: disabledThumbRadius,
      end: thumbRadius,
    );

    final double radius = radiusTween.evaluate(enableAnimation);
    final double currentElevation = isPressed == true ? pressedElevation : elevation;

    // Draw shadow
    final Path shadowPath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius));
    canvas.drawShadow(shadowPath, Colors.black, currentElevation, true);

    // Draw thumb base (outer circle)
    final Paint thumbPaint = Paint()
      ..color = sliderTheme.thumbColor ?? Colors.blue
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, thumbPaint);

    // Draw inner circle with different color
    final Paint innerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius * 0.6, innerPaint);

    // Draw border
    final Paint borderPaint = Paint()
      ..color = sliderTheme.thumbColor ?? Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawCircle(center, radius, borderPaint);

    // Optional: Add a small dot in the center
    final Paint dotPaint = Paint()
      ..color = sliderTheme.thumbColor ?? Colors.blue
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius * 0.2, dotPaint);
  }
}

class CustomRangeTrackShape extends RangeSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight!;
    final double trackLeft = offset.dx;
    final double trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(
      PaintingContext context,
      Offset offset, {
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required Animation<double> enableAnimation,
        required Offset startThumbCenter,
        required Offset endThumbCenter,
        bool isEnabled = false,
        bool isDiscrete = false,
        required TextDirection textDirection,
      }) {
    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final Canvas canvas = context.canvas;
    final double radius = trackRect.height / 2;

    // Left inactive track
    final Paint leftInactivePaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(
          trackRect.left,
          trackRect.top,
          startThumbCenter.dx,
          trackRect.bottom,
        ),
        Radius.circular(radius),
      ),
      leftInactivePaint,
    );

    // Active track rectangle
    final Rect activeTrackRect = Rect.fromLTRB(
      startThumbCenter.dx,
      trackRect.top,
      endThumbCenter.dx,
      trackRect.bottom,
    );

    final RRect activeTrackRRect = RRect.fromRectAndRadius(
      activeTrackRect,
      Radius.circular(radius),
    );

    // Draw active track fill
    final Paint activePaint = Paint()
      ..color = sliderTheme.activeTrackColor ?? Colors.blue
      ..style = PaintingStyle.fill;

    canvas.drawRRect(activeTrackRRect, activePaint);

    // Draw border around active track
    final Paint borderPaint = Paint()
      ..color = Colors.black // Border color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0; // Border width

    canvas.drawRRect(activeTrackRRect, borderPaint);

    // Right inactive track
    final Paint rightInactivePaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(
          endThumbCenter.dx,
          trackRect.top,
          trackRect.right,
          trackRect.bottom,
        ),
        Radius.circular(radius),
      ),
      rightInactivePaint,
    );
  }
}
