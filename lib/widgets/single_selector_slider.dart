import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SingleSelectorSlider extends StatefulWidget {
  final double? sliderHeight;
  final double? sliderWidth;
  final double? minValue;
  final double? maxValue;
  final int? divisions;

  const SingleSelectorSlider({super.key, this.sliderHeight, this.minValue, this.maxValue, this.divisions,this.sliderWidth});

  @override
  State<SingleSelectorSlider> createState() => _SingleSelectorSliderState();
}

class _SingleSelectorSliderState extends State<SingleSelectorSlider> {
  double _currentValue = 1.0;
  double _previousValue = 1.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.sliderWidth??double.maxFinite,
      child: SliderTheme(
        data: SliderThemeData(
          tickMarkShape: CustomTickShape(),
          trackShape: CustomTrackShape(),
          thumbShape: CustomThumbShape(),
          trackHeight: widget.sliderHeight ?? 36,
          inactiveTrackColor: const Color(0xFF272727),
          activeTrackColor: Colors.transparent,
          thumbColor: Color(0xFFF3F4F1),
        ),
        child: Slider(
          value: _currentValue,
          onChanged: (val) {
            setState(() {
              bool valueChanged = val.round() != _previousValue.round();

              if (valueChanged) {
                HapticFeedback.selectionClick();
              }

              _previousValue = _currentValue;
              _currentValue = val;
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

class CustomTickShape extends SliderTickMarkShape {
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
    required Offset thumbCenter,
    bool? isEnabled,
    required TextDirection textDirection,
  }) {
    final canvas = context.canvas;

    final bool isAtThumbPosition = (center.dx - thumbCenter.dx).abs() < 10;

    if (!isAtThumbPosition) {
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

class CustomTrackShape extends SliderTrackShape {
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
    required Offset thumbCenter,
    Offset? secondaryOffset,
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
  }
}

class CustomThumbShape extends SliderComponentShape {
  const CustomThumbShape({
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
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required Size sizeWithOverflow,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double textScaleFactor,
    required double value,
  }) {
    final Canvas canvas = context.canvas;
    final Tween<double> radiusTween = Tween<double>(begin: disabledThumbRadius, end: thumbRadius);

    final double radius = radiusTween.evaluate(enableAnimation) - 2;
    final double currentElevation = elevation;

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
