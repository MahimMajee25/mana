import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:height_weight/bmi_flow/body_type.dart';
import 'package:height_weight/widgets/display_chip.dart';
import 'package:height_weight/widgets/question_label.dart';
import 'package:height_weight/widgets/simple_ruler.dart';
import 'package:height_weight/widgets/submit_button.dart';
import 'package:height_weight/widgets/toggle_button.dart';
import 'package:height_weight/widgets/top_stack.dart';

class TargetWeightSelector extends StatefulWidget {
  const TargetWeightSelector({super.key,});
  @override
  _TargetWeightSelectorState createState() => _TargetWeightSelectorState();
}

class _TargetWeightSelectorState extends State<TargetWeightSelector> {
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
            FittedBox(child: QuestionLabel(textLabel: "What’s your Target weight?")),
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
                      } else {
                        lbsWeight.value = defaultLbsWeight;
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          rulerController.value = defaultLbsWeight;
                        });
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
                    } else {
                      lbsWeight.value = val;
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
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 20,
              ),
              decoration: BoxDecoration(
                color: Color(0xFF1A1B18),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset('assets/icons/target.svg',height: 24,width: 24,),
                      SizedBox(width: 8),
                      Text(
                        "CHALLENGING GOAL",
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFF3F4F1),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 13,),
                  Text(
                    "You will gain 38% of your weight",
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFF3F4F1),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    textAlign: TextAlign.start,
                    "You will enjoy even greater benefits from muscle gain",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(243, 244, 241, 0.7),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            SubmitButton(
              submitText: "NEXT",
            ),
            SizedBox(height: screenHeight < 700 ? 12 : 60),
          ],
        ),
      ),
    );
  }
}
