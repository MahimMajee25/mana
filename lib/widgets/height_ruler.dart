import 'package:flutter/material.dart';
import 'package:height_weight/widgets/simple_ruler.dart';

class HeightRuler extends SimpleRuler {
  final bool isImperial;
  final bool showOnlyFootMarks;

  const HeightRuler({
    required this.isImperial,
    this.showOnlyFootMarks = true,
    super.key,
    super.minValue = 0,
    super.maxValue = 10,
    super.majorTickInterval = 1,
    super.minorTicksPerInterval = 4,
    super.rulerHeight = 80,
    super.majorTickLength = 30,
    super.minorTickLength = 15,
    super.tickColor = Colors.black87,
    super.pointerColor = Colors.blue,
    super.orientation = RulerOrientation.horizontal,
    super.alignment = RulerAlignment.start,
    super.onChanged,
    super.initialValue = 0,
    super.labelStyle,
    super.customPointer,
    super.tickSpacing = 20.0,
    super.labelSpacing,
    super.postText,
    super.minorTickPadding,
    super.controller,
  });

  @override
  _CustomRulerState createState() => _CustomRulerState();
}

class _CustomRulerState extends State<SimpleRuler> {
  late ScrollController _scrollController;
  late double _selectedValue;
  late double _totalRulerLength;
  late double _pixelsPerUnit;
  late HeightRuler customWidget;

  @override
  void initState() {
    super.initState();
    customWidget = widget as HeightRuler;

    _selectedValue = widget.initialValue.clamp(
      widget.minValue,
      widget.maxValue,
    );
    _totalRulerLength = _calculateTotalLength();
    _pixelsPerUnit = _calculatePixelsPerUnit();

    double initialScrollOffset = _calculateInitialScrollOffset();
    _scrollController = ScrollController(
      initialScrollOffset: initialScrollOffset,
    );

    _scrollController.addListener(_updateSelectedValue);
    widget.controller?.addListener(_handleControllerValue);
  }

  double _calculateInitialScrollOffset() {
    if (widget.orientation == RulerOrientation.horizontal) {
      return (_selectedValue - widget.minValue) * _pixelsPerUnit;
    } else {
      double valueOffset = (_selectedValue - widget.minValue) * _pixelsPerUnit;
      return _totalRulerLength - valueOffset;
    }
  }

  @override
  void didUpdateWidget(SimpleRuler oldWidget) {
    super.didUpdateWidget(oldWidget);
    customWidget = widget as HeightRuler;

    if (oldWidget.minValue != widget.minValue ||
        oldWidget.maxValue != widget.maxValue ||
        oldWidget.majorTickInterval != widget.majorTickInterval ||
        oldWidget.minorTicksPerInterval != widget.minorTicksPerInterval ||
        oldWidget.tickSpacing != widget.tickSpacing) {
      _totalRulerLength = _calculateTotalLength();
      _pixelsPerUnit = _calculatePixelsPerUnit();

      if (_scrollController.hasClients) {
        _scrollController.jumpTo(
          _calculateScrollOffsetForValue(_selectedValue),
        );
      }
    }
  }

  double _calculateScrollOffsetForValue(double value) {
    if (widget.orientation == RulerOrientation.horizontal) {
      return (value - widget.minValue) * _pixelsPerUnit;
    } else {
      double valueOffset = (value - widget.minValue) * _pixelsPerUnit;
      return _totalRulerLength - valueOffset;
    }
  }

  double _calculateTotalLength() {
    double range = widget.maxValue - widget.minValue;
    int majorTickCount = (range / widget.majorTickInterval).ceil();
    int totalDivisions = majorTickCount * (widget.minorTicksPerInterval + 1);
    return totalDivisions * widget.tickSpacing;
  }

  double _calculatePixelsPerUnit() {
    double range = widget.maxValue - widget.minValue;
    return _totalRulerLength / range;
  }

  void _updateSelectedValue() {
    if (_scrollController.hasClients) {
      double newValue;

      if (widget.orientation == RulerOrientation.horizontal) {
        newValue =
            widget.minValue + (_scrollController.offset / _pixelsPerUnit);
      } else {
        double invertedOffset = _totalRulerLength - _scrollController.offset;
        newValue = widget.minValue + (invertedOffset / _pixelsPerUnit);
      }

      newValue = newValue.clamp(widget.minValue, widget.maxValue);

      if (newValue != _selectedValue) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          setState(() {
            _selectedValue = newValue;
          });
          widget.onChanged?.call(_selectedValue);
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateSelectedValue);
    _scrollController.dispose();
    widget.controller?.removeListener(_handleControllerValue);
    super.dispose();
  }

  void _handleControllerValue() {
    final controllerValue = widget.controller?.value;
    if (controllerValue != null &&
        controllerValue != _selectedValue &&
        controllerValue >= widget.minValue &&
        controllerValue <= widget.maxValue) {
      setState(() {
        _selectedValue = controllerValue;
      });

      _scrollController.animateTo(
        _calculateScrollOffsetForValue(_selectedValue),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );

      widget.onChanged?.call(_selectedValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    Alignment stackAlignment =
        widget.orientation == RulerOrientation.horizontal
            ? Alignment.center
            : Alignment.centerRight;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double halfWidth = constraints.maxWidth / 2;
        final double halfHeight = constraints.maxHeight / 2;

        return Stack(
          alignment: stackAlignment,
          children: [
            SingleChildScrollView(
              scrollDirection:
                  widget.orientation == RulerOrientation.horizontal
                      ? Axis.horizontal
                      : Axis.vertical,
              controller: _scrollController,
              child: Padding(
                padding:
                    widget.orientation == RulerOrientation.horizontal
                        ? EdgeInsets.symmetric(
                          horizontal: halfWidth - widget.tickSpacing / 2,
                        )
                        : EdgeInsets.symmetric(
                          vertical: halfHeight - widget.tickSpacing / 2,
                        ),
                child: _buildRulerContent(),
              ),
            ),
            widget.customPointer ?? _buildDefaultPointer(),
          ],
        );
      },
    );
  }

  Widget _buildRulerContent() {
    double range = widget.maxValue - widget.minValue;
    int majorTickCount = (range / widget.majorTickInterval).ceil() + 1;

    if (widget.orientation == RulerOrientation.horizontal) {
      return Row(
        children: List.generate(majorTickCount, (majorIndex) {
          double value =
              widget.minValue + (majorIndex * widget.majorTickInterval);
          if (value > widget.maxValue) return const SizedBox();
          return _buildMajorTickGroup(value, majorIndex);
        }),
      );
    } else {
      return Column(
        children: List.generate(majorTickCount, (majorIndex) {
          double value =
              widget.maxValue - (majorIndex * widget.majorTickInterval);
          if (value < widget.minValue) return const SizedBox();
          return _buildMajorTickGroup(value, majorIndex);
        }),
      );
    }
  }

  Widget _buildMajorTickGroup(double value, int majorIndex) {
    bool isLastMajorTick;

    if (widget.orientation == RulerOrientation.horizontal) {
      isLastMajorTick = value + widget.majorTickInterval > widget.maxValue;
    } else {
      isLastMajorTick = value - widget.majorTickInterval < widget.minValue;
    }

    if (widget.orientation == RulerOrientation.horizontal) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildMajorTick(value, widget.labelSpacing ?? 4),
              if (!isLastMajorTick)
                ...List.generate(widget.minorTicksPerInterval, (minorIndex) {
                  return _buildMinorTick();
                }),
            ],
          ),
        ],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildMajorTick(value, widget.labelSpacing ?? 4),
              if (!isLastMajorTick)
                ...List.generate(widget.minorTicksPerInterval, (minorIndex) {
                  return _buildMinorTick();
                }),
            ],
          ),
        ],
      );
    }
  }

  String _formatLabelText(double value) {
    if (customWidget.isImperial) {
      if (customWidget.showOnlyFootMarks) {
        if (value == value.floorToDouble()) {
          int feet = value.toInt();
          return "$feet'0 ft";
        } else {
          return "";
        }
      } else {
        int feet = value.floor();
        int inches = ((value - feet) * 12).round();

        if (inches == 12) {
          feet += 1;
          inches = 0;
        }

        return "$feet'$inches";
      }
    } else {
      return value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 1) +
          (widget.postText ?? "");
    }
  }

  Widget _buildMajorTick(double value, double labelSpacing) {
    Widget tick = Container(
      width:
          widget.orientation == RulerOrientation.horizontal
              ? 2
              : widget.majorTickLength,
      height:
          widget.orientation == RulerOrientation.horizontal
              ? widget.majorTickLength
              : 2,
      color: widget.tickColor,
    );

    final String labelText = _formatLabelText(value);
    final TextStyle labelTextStyle =
        widget.labelStyle ?? TextStyle(fontSize: 12, color: widget.tickColor);

    if (widget.orientation == RulerOrientation.horizontal) {
      return SizedBox(
        width: widget.tickSpacing,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:
              widget.alignment == RulerAlignment.start
                  ? [
                    Center(child: tick),
                    SizedBox(height: labelSpacing),
                    Center(
                      child: Text(
                        labelText,
                        style: labelTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ]
                  : [
                    Center(
                      child: Text(
                        labelText,
                        style: labelTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: labelSpacing),
                    Center(child: tick),
                  ],
        ),
      );
    } else {
      List<Widget> rowChildren =
          widget.alignment == RulerAlignment.start
              ? [
                Text(labelText, style: labelTextStyle),
                SizedBox(width: labelSpacing),
                tick,
              ]
              : [
                tick,
                SizedBox(width: labelSpacing),
                Text(labelText, style: labelTextStyle),
              ];

      return SizedBox(
        height: widget.tickSpacing,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: rowChildren,
        ),
      );
    }
  }

  Widget _buildMinorTick() {
    if (widget.orientation == RulerOrientation.horizontal) {
      return Container(
        padding: EdgeInsets.only(bottom: widget.minorTickPadding ?? 4),
        width: widget.tickSpacing,
        child: Center(
          child: Container(
            width: 1,
            height: widget.minorTickLength,
            color: widget.tickColor,
          ),
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.only(left: widget.minorTickPadding ?? 4),
        height: widget.tickSpacing,
        child: Align(
          alignment: Alignment.center,
          child: Container(
            width: widget.minorTickLength,
            height: 2,
            color: widget.tickColor,
          ),
        ),
      );
    }
  }

  Widget _buildDefaultPointer() {
    final Color color = widget.pointerColor;

    if (widget.orientation == RulerOrientation.horizontal) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 2,
            height: widget.majorTickLength * 0.8,
            color: color,
          ),
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          Container(
            width: widget.majorTickLength * 0.8,
            height: 2,
            color: color,
          ),
        ],
      );
    }
  }
}
