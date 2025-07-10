import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:height_weight/bmi_flow/weight.dart';
import 'package:height_weight/widgets/display_chip.dart';
import 'package:height_weight/widgets/height_ruler.dart';
import 'package:height_weight/widgets/question_label.dart';
import 'package:height_weight/widgets/simple_ruler.dart';
import 'package:height_weight/widgets/submit_button.dart';
import 'package:height_weight/widgets/toggle_button.dart';
import 'package:height_weight/widgets/top_stack.dart';

class HeightSelector extends StatefulWidget {
  const HeightSelector({super.key});

  @override
  _HeightSelectorState createState() => _HeightSelectorState();
}

class _HeightSelectorState extends State<HeightSelector> {
  final GlobalKey _myKey = GlobalKey();
  final ValueNotifier<bool> isSelectedNotifier = ValueNotifier<bool>(true);
  final ValueNotifier<int> cmHeight = ValueNotifier<int>(175); // Default 175cm
  final ValueNotifier<int> feetHeight = ValueNotifier<int>(5); // Default 5'9"
  final ValueNotifier<int> inchesHeight = ValueNotifier<int>(9);
  final ValueNotifier<Offset?> widgetPositionNotifier = ValueNotifier(null);
  final SimpleRulerController rulerController = SimpleRulerController();

  final double defaultCmHeight = 175.0;
  final double defaultFtHeight = 5.75;

  @override
  void initState() {
    super.initState();
    cmHeight.value = defaultCmHeight.round();
    feetHeight.value = defaultFtHeight.floor();
    inchesHeight.value =
        ((defaultFtHeight - defaultFtHeight.floor()) * 12).round();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox? box =
          _myKey.currentContext?.findRenderObject() as RenderBox?;
      if (box != null && box.hasSize) {
        final Offset position = box.localToGlobal(Offset.zero);
        widgetPositionNotifier.value = position;
      }
    });
  }

  @override
  void dispose() {
    isSelectedNotifier.dispose();
    cmHeight.dispose();
    feetHeight.dispose();
    inchesHeight.dispose();
    widgetPositionNotifier.dispose();
    rulerController.dispose();
    super.dispose();
  }

  void updateFeetInches(double value) {
    int feet = value.floor();
    int inches = ((value - feet) * 12).round();

    if (inches == 12) {
      feet += 1;
      inches = 0;
    }

    feetHeight.value = feet;
    inchesHeight.value = inches;
  }

  double imperialToCm() {
    return (feetHeight.value * 30.48) + (inchesHeight.value * 2.54);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF030402),
      body: Stack(
        children: [
          ValueListenableBuilder(
            valueListenable: widgetPositionNotifier,
            builder: (context, position, child) {
              return Positioned(
                bottom: (position?.dy == null ? 0 : -(position!.dy + 44)),
                right: 0,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 2,
                  child: ValueListenableBuilder(
                    valueListenable: isSelectedNotifier,
                    builder: (context, isSelected, _) {
                      return HeightRuler(
                        isImperial: !isSelected,
                        showOnlyFootMarks: true,
                        controller: rulerController,
                        initialValue:
                            isSelected
                                ? cmHeight.value.toDouble()
                                : feetHeight.value.toDouble() +
                                    (inchesHeight.value / 12),
                        orientation: RulerOrientation.vertical,
                        minValue: isSelected ? 90 : 3, // 3 feet
                        maxValue: isSelected ? 250 : 8, // 8 feet
                        minorTickLength: 41,
                        majorTickLength: 41,
                        tickColor: Color.fromRGBO(243, 244, 241, 0.3),
                        labelStyle: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                          letterSpacing: 0.0,
                          color: Color(0xFFF3F4F1),
                        ),
                        postText: isSelected ? " cm" : "",
                        customPointer: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Color(0xFFCC0E00),
                                shape: BoxShape.circle,
                              ),
                            ),
                            Container(
                              width:
                                  position == null
                                      ? 0
                                      : isSelected
                                      ? position.dx - 15
                                      : position.dx - 10,
                              height: 2,
                              color: Color(0xFFCC0E00),
                            ),
                          ],
                        ),
                        onChanged: (val) {
                          if (isSelected) {
                            cmHeight.value = val.round();
                          } else {
                            updateFeetInches(val);
                          }
                        },
                        minorTicksPerInterval: isSelected ? 9 : 5,
                        majorTickInterval: isSelected ? 10 : 1,
                        tickSpacing: 40,
                        labelSpacing: 21,
                        minorTickPadding: isSelected ? 75 : 61,
                      );
                    },
                  ),
                ),
              );
            },
          ),
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 20,
              left: 16,
              right: 16,
            ),
            child: Column(
              children: [
                TopStack(),
                SizedBox(height: 52),
                QuestionLabel(textLabel: "What's your Height?"),
                SizedBox(height: 24),
                ValueListenableBuilder(
                  valueListenable: isSelectedNotifier,
                  builder: (context, isSelected, _) {
                    return UnitToggleTab(
                      isFirstSelected: isSelected,
                      text1: "cm",
                      text2: "Ft",
                      onToggle: (value) {
                        if (value != isSelectedNotifier.value) {
                          if (value) {
                            cmHeight.value = defaultCmHeight.round();
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              rulerController.value = defaultCmHeight;
                            });
                          } else {
                            feetHeight.value = defaultFtHeight.floor();
                            inchesHeight.value =
                                ((defaultFtHeight - defaultFtHeight.floor()) *
                                        12)
                                    .round();
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              rulerController.value = defaultFtHeight;
                            });
                          }
                        }
                        isSelectedNotifier.value = value;
                      },
                    );
                  },
                ),
                SizedBox(height: 32),
                ValueListenableBuilder(
                  valueListenable: isSelectedNotifier,
                  builder: (context, isSelected, _) {
                    if (isSelected) {
                      return ValueListenableBuilder(
                        valueListenable: cmHeight,
                        builder: (context, height, _) {
                          return DisplayChip(
                            number: height.toString(),
                            unit: 'cm',
                            key: _myKey,
                          );
                        },
                      );
                    } else {
                      return ValueListenableBuilder(
                        valueListenable: feetHeight,
                        builder: (context, feet, _) {
                          return ValueListenableBuilder(
                            valueListenable: inchesHeight,
                            builder: (context, inches, _) {
                              return DisplayChip(
                                number: "$feet'$inches",
                                unit: 'Ft',
                                key: _myKey,
                              );
                            },
                          );
                        },
                      );
                    }
                  },
                ),
                Spacer(),
                SubmitButton(
                  submitText: "NEXT",
                  onPressed: () {
                    double heightToSend =
                        isSelectedNotifier.value
                            ? cmHeight.value.toDouble()
                            : imperialToCm();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => WeightSelector(height: heightToSend),
                      ),
                    );
                  },
                ),
                SizedBox(height: 60),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
