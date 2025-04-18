import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:height_weight/widgets/display_chip.dart';
import 'package:height_weight/widgets/question_label.dart';
import 'package:height_weight/widgets/simple_ruler.dart';
import 'package:height_weight/widgets/submit_button.dart';
import 'package:height_weight/widgets/toggle_button.dart';
import 'package:height_weight/widgets/top_stack.dart';

class WeightSelector extends StatefulWidget {
  final double? height;
  const WeightSelector({super.key, required this.height});
  @override
  _WeightSelectorState createState() => _WeightSelectorState();
}

class _WeightSelectorState extends State<WeightSelector> {
  final ValueNotifier<bool> isSelectedNotifier = ValueNotifier<bool>(true);
  final ValueNotifier<double?> kgWeight = ValueNotifier<double?>(null);
  final ValueNotifier<double?> lbsWeight = ValueNotifier<double?>(null);
  ValueNotifier<double> bmiNotifier = ValueNotifier(0.0);
  final SimpleRulerController rulerController = SimpleRulerController();

  final double defaultKgWeight = 65.0;
  final double defaultLbsWeight = 143.0;

  @override
  void initState() {
    super.initState();
    kgWeight.value = defaultKgWeight;
    lbsWeight.value = defaultLbsWeight;
    updateBMI(kgWeight.value!, widget.height!);
  }

  void updateBMI(double weightKg, double heightCm) {
    double heightM = heightCm / 100;
    double bmi = weightKg / (heightM * heightM);
    bmiNotifier.value = double.parse(bmi.toStringAsFixed(1));
  }

  String getBMIDescription(double bmi) {
    if (bmi < 18.5) return "You're underweight, try to eat healthy.";
    if (bmi < 24.9) return "You have got fantastic shape, stay on track";
    if (bmi < 29.9) return "You're slightly overweight, consider workouts";
    return "You are obese, consult a nutritionist or doctor";
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xFF030402),
      body: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 20,
          left: 16,
          right: 16,
        ),
        child: Column(
          children: [
            TopStack(
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 52),
            QuestionLabel(textLabel: "What's your Weight?"),
            SizedBox(height: 24),
            ValueListenableBuilder(
              valueListenable: isSelectedNotifier,
              builder: (context, isSelected, _) {
                return UnitToggleTab(
                  text1: "Kg",
                  text2: "lbs",
                  isFirstSelected: isSelected,
                  onToggle: (value) {
                    if (value != isSelectedNotifier.value) {
                      if (value) {
                        kgWeight.value = defaultKgWeight;
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          rulerController.value = defaultKgWeight;
                        });
                        updateBMI(defaultKgWeight, widget.height!);
                      } else {
                        lbsWeight.value = defaultLbsWeight;
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          rulerController.value = defaultLbsWeight;
                        });
                        updateBMI(
                          defaultLbsWeight * 0.45359237,
                          widget.height!,
                        );
                      }
                    }
                    isSelectedNotifier.value = value;
                  },
                );
              },
            ),
            ValueListenableBuilder(
              builder: (context, isSelected, _) {
                return SimpleRuler(
                  controller: rulerController,
                  initialValue: isSelected ? kgWeight.value! : lbsWeight.value!,
                  orientation: RulerOrientation.horizontal,
                  minValue: isSelected ? 10 : 20,
                  maxValue: isSelected ? 200 : 440,
                  minorTickLength: 41,
                  majorTickLength: 76,
                  tickColor: Color.fromRGBO(243, 244, 241, 0.3),
                  labelStyle: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    letterSpacing: 0.0,
                    color: Color(0xFFF3F4F1),
                  ),
                  postText: isSelected ? " kg" : " lbs",
                  customPointer: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(height: 70, width: 2, color: Color(0xFFCC0E00)),
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Color(0xFFCC0E00),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(height: 5),
                    ],
                  ),
                  onChanged: (val) {
                    if (isSelected) {
                      kgWeight.value = val;
                      updateBMI(kgWeight.value!, widget.height!);
                    } else {
                      lbsWeight.value = val;
                      updateBMI(lbsWeight.value! * 0.45359237, widget.height!);
                    }
                  },
                  minorTicksPerInterval: 9,
                  majorTickInterval: 10,
                  labelSpacing: 12,
                  tickSpacing: 20,
                  minorTickPadding: 22,
                );
              },
              valueListenable: isSelectedNotifier,
            ),
            SizedBox(height: 24),
            ValueListenableBuilder(
              builder: (context, isSelected, _) {
                if (isSelected) {
                  return ValueListenableBuilder(
                    builder: (context, weight, _) {
                      return DisplayChip(
                        number: weight!.toStringAsFixed(1),
                        unit: 'kgs',
                      );
                    },
                    valueListenable: kgWeight,
                  );
                } else {
                  return ValueListenableBuilder(
                    builder: (context, weight, _) {
                      return DisplayChip(
                        number: weight!.toStringAsFixed(1),
                        unit: 'lbs',
                      );
                    },
                    valueListenable: lbsWeight,
                  );
                }
              },
              valueListenable: isSelectedNotifier,
            ),
            SizedBox(height: screenHeight < 700 ? 9.7 : 36),
            Column(
              children: [
                ValueListenableBuilder(
                  valueListenable: bmiNotifier,
                  builder: (context, bmi, _) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFF1A1B18),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "YOUR BMI",
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFFF3F4F1),
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                bmi.toStringAsFixed(1),
                                style: GoogleFonts.inter(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0XFF2CCC00),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          FittedBox(
                            child: Text(
                              textAlign: TextAlign.center,
                              getBMIDescription(bmi),
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(243, 244, 241, 0.7),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            Spacer(),
            SubmitButton(),
            SizedBox(height: screenHeight < 700 ? 12 : 60),
          ],
        ),
      ),
    );
  }
}
