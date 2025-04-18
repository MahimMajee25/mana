import 'package:flutter/material.dart';

enum RulerOrientation { horizontal, vertical }

enum RulerAlignment { start, end }

class SimpleRulerController extends ChangeNotifier {
  double? _value;

  double? get value => _value;

  set value(double? newValue) {
    if (newValue != _value && newValue != null) {
      _value = newValue;
      notifyListeners();
    }
  }
}

class SimpleRuler extends StatefulWidget {
  final double minValue;
  final double maxValue;
  final double majorTickInterval;
  final int minorTicksPerInterval;
  final double rulerHeight;
  final double majorTickLength;
  final double minorTickLength;
  final Color tickColor;
  final Color pointerColor;
  final RulerOrientation orientation;
  final RulerAlignment alignment;
  final Function(double)? onChanged;
  final double initialValue;
  final TextStyle? labelStyle;
  final Widget? customPointer;
  final double tickSpacing;
  final double? labelSpacing;
  final double? minorTickPadding;
  final String? postText;
  final SimpleRulerController? controller;

  const SimpleRuler({
    super.key,
    this.minValue = 0,
    this.maxValue = 10,
    this.majorTickInterval = 1,
    this.minorTicksPerInterval = 4,
    this.rulerHeight = 80,
    this.majorTickLength = 30,
    this.minorTickLength = 15,
    this.tickColor = Colors.black87,
    this.pointerColor = Colors.blue,
    this.orientation = RulerOrientation.horizontal,
    this.alignment = RulerAlignment.start,
    this.onChanged,
    this.initialValue = 0,
    this.labelStyle,
    this.customPointer,
    this.tickSpacing = 20.0, // Default is 20 pixels, but now customizable
    this.labelSpacing,
    this.postText,
    this.minorTickPadding,
    this.controller,
  }) : assert(minValue < maxValue, 'minValue must be less than maxValue'),
       assert(majorTickInterval > 0, 'majorTickInterval must be positive'),
       assert(
         minorTicksPerInterval >= 0,
         'minorTicksPerInterval must be non-negative',
       ),
       assert(tickSpacing > 0, 'tickSpacing must be positive');

  @override
  State<SimpleRuler> createState() => _SimpleRulerState();
}

class _SimpleRulerState extends State<SimpleRuler> {
  late ScrollController _scrollController;
  late ScrollController _scrollControllerWeightLabel;
  late double _selectedValue;
  late double _totalRulerLength;
  late double _pixelsPerUnit;
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
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

    _scrollControllerWeightLabel = ScrollController(
      initialScrollOffset: initialScrollOffset,
    );

    _scrollController.addListener(_updateSelectedValue);
    widget.controller?.addListener(_handleControllerValue);

    _scrollController.addListener(() {
      if (_isSyncing) return;
      _isSyncing = true;
      _scrollControllerWeightLabel.jumpTo(_scrollController.offset);
      _isSyncing = false;
    });

    _scrollControllerWeightLabel.addListener(() {
      if (_isSyncing) return;
      _isSyncing = true;
      _scrollController.jumpTo(_scrollControllerWeightLabel.offset);
      _isSyncing = false;
    });
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
    // Determine the alignment for the stack based on orientation
    Alignment stackAlignment =
        widget.orientation == RulerOrientation.horizontal
            ? Alignment.center
            : Alignment.centerRight; // Always right-aligned for vertical

    return LayoutBuilder(
      builder: (context, constraints) {
        final double halfWidth = constraints.maxWidth / 2;
        final double halfHeight = constraints.maxHeight / 2;
        double range = widget.maxValue - widget.minValue;
        int majorTickCount = (range / widget.majorTickInterval).ceil() + 1;
        final TextStyle labelTextStyle =
            widget.labelStyle ??
            TextStyle(fontSize: 12, color: widget.tickColor);
        return Stack(
          alignment: stackAlignment,
          children: [
            // Scrollable ruler
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
            SingleChildScrollView(
              scrollDirection:
                  widget.orientation == RulerOrientation.horizontal
                      ? Axis.horizontal
                      : Axis.vertical,
              controller: _scrollControllerWeightLabel,
              child: Padding(
                padding: EdgeInsets.only(
                  left: halfWidth - widget.tickSpacing / 2 - 20,
                  top: 112,
                  right: halfWidth - widget.tickSpacing / 2 + 20,
                ),

                child: Row(
                  children: List.generate(majorTickCount, (majorIndex) {
                    double value =
                        widget.minValue +
                        (majorIndex * widget.majorTickInterval);
                    final String labelText =
                        value.toStringAsFixed(
                          value.truncateToDouble() == value ? 0 : 1,
                        ) +
                        (widget.postText ?? "");
                    if (value > widget.maxValue) return const SizedBox();
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        return Row(
                          children: [
                            SizedBox(
                              width: widget.tickSpacing + 40,
                              child: Center(
                                child: Text(
                                  labelText,
                                  style: labelTextStyle,
                                  textAlign: TextAlign.center,
                                  softWrap: false,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ),
                            if (majorIndex != 0 ||
                                majorIndex != majorTickCount - 1)
                              SizedBox(width: 140),
                          ],
                        );
                      },
                    );
                  }),
                ),
              ),
            ),

            // Pointer
            widget.customPointer ?? _buildDefaultPointer(),
          ],
        );
      },
    );
  }

  Widget _buildRulerContent() {
    double range = widget.maxValue - widget.minValue;
    // Calculate number of major ticks needed
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
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: [_buildMajorTick(value, widget.labelSpacing ?? 4)],
              ),

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
              // Major tick
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

    final String labelText =
        value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 1) +
        (widget.postText ?? "");

    final TextStyle labelTextStyle =
        widget.labelStyle ?? TextStyle(fontSize: 12, color: widget.tickColor);

    if (widget.orientation == RulerOrientation.horizontal) {
      return Column(
        children: [
          SizedBox(
            width: widget.tickSpacing,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:
                  widget.alignment == RulerAlignment.start
                      ? [Center(child: tick), SizedBox(height: labelSpacing)]
                      : [
                        LayoutBuilder(
                          builder: (context, constraints) {
                            return SizedBox(
                              width: widget.tickSpacing * 2,
                              child: Center(
                                child: Text(
                                  labelText,
                                  style: labelTextStyle,
                                  textAlign: TextAlign.center,
                                  softWrap: false,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: labelSpacing),
                        Center(child: tick),
                      ],
            ),
          ),
        ],
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
        padding: EdgeInsets.only(top: widget.minorTickPadding ?? 4),
        width: widget.tickSpacing,
        child: Center(
          child: Container(
            width: 2,
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
