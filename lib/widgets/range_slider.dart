import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomRangeSlider extends StatefulWidget {
  final double? sliderHeight;
  final double? sliderWidth;
  final double? minValue;
  final double? maxValue;
  final int? divisions;
  final double? leftValue;
  final ValueChanged<RangeValues> onChanged;

  const CustomRangeSlider({
    super.key,
    this.sliderHeight,
    this.sliderWidth,
    this.minValue,
    this.maxValue,
    this.divisions,
    this.leftValue,
    required this.onChanged,
  });

  @override
  State<CustomRangeSlider> createState() => _CustomRangeSliderState();
}

class _CustomRangeSliderState extends State<CustomRangeSlider> {
  RangeValues _currentRangeValues = const RangeValues(1, 5);
  RangeValues _previousRangeValues = const RangeValues(1, 5);

  @override
  void initState() {
    super.initState();
    if (widget.leftValue != null) {
      _currentRangeValues = RangeValues(widget.leftValue!, _currentRangeValues.end);
      _previousRangeValues = _currentRangeValues;
    }
  }

  @override
  void didUpdateWidget(CustomRangeSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.leftValue != oldWidget.leftValue && widget.leftValue != null) {
      _currentRangeValues = RangeValues(widget.leftValue!, _currentRangeValues.end);
      _previousRangeValues = _currentRangeValues;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.sliderWidth ?? double.maxFinite,
      child: SliderTheme(
        data: SliderThemeData(
          rangeTickMarkShape: CustomRangeTickShape(),
          rangeTrackShape: CustomRangeTrackShape(),
          rangeThumbShape: CustomRangeThumbShape(),
          trackHeight: widget.sliderHeight ?? 36,
          inactiveTrackColor: const Color(0xFF272727),
          activeTrackColor: const Color(0xFF1A1B18),
          thumbColor: const Color(0xFFFF0101),
        ),
        child: RangeSlider(
          values: _currentRangeValues,
          onChanged: (val) {
            setState(() {
              RangeValues newValues;

              if (widget.leftValue != null) {
                newValues = RangeValues(widget.leftValue!, val.end);
              } else {
                newValues = val;
              }

              bool startChanged = newValues.start.round() != _previousRangeValues.start.round();
              bool endChanged = newValues.end.round() != _previousRangeValues.end.round();

              if (startChanged || endChanged) {
                HapticFeedback.selectionClick();
              }

              _previousRangeValues = _currentRangeValues;
              _currentRangeValues = newValues;

              widget.onChanged(newValues);
            });
          },
          min: widget.minValue ?? 1,
          max: widget.maxValue ?? 5,
          divisions: widget.divisions ?? 4,
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

    final bool isInActiveRange = center.dx >= startThumbCenter.dx && center.dx <= endThumbCenter.dx;

    if (!isInActiveRange) {
      final Paint thumbPaint =
      Paint()
        ..color = const Color(0xFF393939)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(center, 6, thumbPaint);

      final Paint innerPaint =
      Paint()
        ..color = const Color(0xFF1F1F1F)
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

    final Paint inactiveTrackPaint =
    Paint()
      ..color = sliderTheme.inactiveTrackColor!
      ..style = PaintingStyle.fill;

    final RRect inactiveTrackRRect = RRect.fromRectAndRadius(trackRect, Radius.circular(trackRadius));
    canvas.drawRRect(inactiveTrackRRect, inactiveTrackPaint);

    final double thumbRadius = 12.0;
    final double activeTrackLeft = startThumbCenter.dx - thumbRadius - 6;
    final double activeTrackRight = endThumbCenter.dx + thumbRadius + 6;
    final double activeTrackWidth = activeTrackRight - activeTrackLeft;

    if (activeTrackWidth > 0) {
      final Rect activeTrackRect = Rect.fromLTWH(
        activeTrackLeft.clamp(trackRect.left, trackRect.right - activeTrackWidth + 10),
        trackRect.top,
        activeTrackWidth.clamp(0, trackRect.width),
        trackRect.height,
      );

      final Paint activeTrackPaint =
      Paint()
        ..color = sliderTheme.activeTrackColor!
        ..style = PaintingStyle.fill;

      final RRect activeTrackRRect = RRect.fromRectAndRadius(activeTrackRect, Radius.circular(trackRadius));
      canvas.drawRRect(activeTrackRRect, activeTrackPaint);

      final Paint borderPaint =
      Paint()
        ..color = const Color(0x70F3F4F1)
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

    final double radius = radiusTween.evaluate(enableAnimation) - 2;
    final double currentElevation = isPressed == true ? pressedElevation : elevation;

    final Path shadowPath = Path()..addOval(Rect.fromCircle(center: center, radius: radius));
    canvas.drawShadow(shadowPath, Colors.black, currentElevation, true);

    final Paint thumbPaint = Paint()
      ..color = sliderTheme.thumbColor ?? Colors.blue
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, thumbPaint);

    final Paint innerPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius * 0.6, innerPaint);
  }
}