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
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SliderTheme(
        data: SliderThemeData(
          rangeTickMarkShape: CustomRangeTickShape(), // Show tick marks only on inactive track
          rangeTrackShape: CustomRangeTrackShape(), // Custom track with white border
          rangeThumbShape: CustomRangeThumbShape(),
          trackHeight: 36,
          inactiveTrackColor: const Color(0xFF272727),
          activeTrackColor: const Color(0xFF1A1B18),
          thumbColor: Color(0xFFFF0101),
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
          divisions: 4,
        ),
      ),
    );
  }
}

class CustomRangeTickShape extends RangeSliderTickMarkShape {
  @override
  Size getPreferredSize({required SliderThemeData sliderTheme, bool? isEnabled}) {
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

    // Only show tick marks on inactive track (outside the range)
    final bool isInActiveRange = center.dx >= startThumbCenter.dx && center.dx <= endThumbCenter.dx;

    if (!isInActiveRange) {
      final Paint thumbPaint =
      Paint()
        ..color = Color(0xFF393939)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(center, 6, thumbPaint);

      final Paint innerPaint =
      Paint()
        ..color = Color(0xFF1F1F1F)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(center, 6 * 0.6, innerPaint);
    }
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
    final double trackRadius = trackRect.height / 2;

    // Paint inactive track (full width)
    final Paint inactiveTrackPaint = Paint()
      ..color = sliderTheme.inactiveTrackColor!
      ..style = PaintingStyle.fill;

    final RRect inactiveTrackRRect = RRect.fromRectAndRadius(
      trackRect,
      Radius.circular(trackRadius),
    );
    canvas.drawRRect(inactiveTrackRRect, inactiveTrackPaint);

    // Paint active track (between thumbs, extending to thumb centers)
    final double thumbRadius = 12.0; // Match the thumb radius
    final double activeTrackLeft = startThumbCenter.dx - thumbRadius-6;
    final double activeTrackRight = endThumbCenter.dx + thumbRadius+6;
    final double activeTrackWidth = activeTrackRight - activeTrackLeft;

    if (activeTrackWidth > 0) {
      final Rect activeTrackRect = Rect.fromLTWH(
        activeTrackLeft.clamp(trackRect.left, trackRect.right - activeTrackWidth+10),
        trackRect.top,
        activeTrackWidth.clamp(0, trackRect.width),
        trackRect.height,
      );

      // Paint active track background
      final Paint activeTrackPaint = Paint()
        ..color = sliderTheme.activeTrackColor!
        ..style = PaintingStyle.fill;

      final RRect activeTrackRRect = RRect.fromRectAndRadius(
        activeTrackRect,
        Radius.circular(trackRadius),
      );
      canvas.drawRRect(activeTrackRRect, activeTrackPaint);

      // Paint white border around active track
      final Paint borderPaint = Paint()
        ..color = Color(0x70F3F4F1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;

      canvas.drawRRect(activeTrackRRect, borderPaint);
    }
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
    final Tween<double> radiusTween = Tween<double>(begin: disabledThumbRadius, end: thumbRadius);

    final double radius = radiusTween.evaluate(enableAnimation);
    final double currentElevation = isPressed == true ? pressedElevation : elevation;

    final Path shadowPath = Path()..addOval(Rect.fromCircle(center: center, radius: radius));
    canvas.drawShadow(shadowPath, Colors.black, currentElevation, true);

    final Paint thumbPaint =
    Paint()
      ..color = sliderTheme.thumbColor ?? Colors.blue
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, thumbPaint);

    final Paint innerPaint =
    Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius * 0.6, innerPaint);
  }
}