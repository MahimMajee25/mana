import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:height_weight/bmi_flow/target_weight.dart';
import 'package:height_weight/widgets/question_label.dart';
import 'package:height_weight/widgets/range_slider.dart';
import 'package:height_weight/widgets/submit_button.dart';
import 'package:height_weight/widgets/top_stack.dart';

class TargetBodyTypeSelector extends StatefulWidget {
  final double bodyType;
   const TargetBodyTypeSelector({super.key,required this.bodyType});

  @override
  _TargetBodyTypeSelectorState createState() => _TargetBodyTypeSelectorState();
}

class _TargetBodyTypeSelectorState extends State<TargetBodyTypeSelector> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF030402),
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20, left: 16, right: 16),
        child: Column(
          children: [
            TopStack(
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 52),
            QuestionLabel(textLabel: "What’s your Body Type?",fontSize: 20,),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset('assets/images/blur_image2.png', height: 155),
                Image.asset('assets/images/mask_group.png', height: 182, width: 204),
                Image.asset('assets/images/blur_image1.png', height: 155),
              ],
            ),
            SizedBox(height: 32),
            QuestionLabel(textLabel: "Body Fat 21-26%",fontSize: 20,),
            SizedBox(height: 24,),
            Column(
              children: [
                CustomRangeSlider(leftValue: widget.bodyType,
                  onChanged: (RangeValues values) {
                    print('Start: ${values.start}, End: ${values.end}');
                  },
                ),
                SizedBox(height: 12,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    QuestionLabel(textLabel: "Slim",fontSize: 16,),
                    QuestionLabel(textLabel: "Muscular",fontSize: 16,),
                  ],
                )
              ],
            ),
            SizedBox(height: 39,),
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
                        "ACHIEVABLE GOAL",
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFF3F4F1),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    textAlign: TextAlign.start,
                    "Goal is reasonable & achievable",
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
            SubmitButton(submitText: "NEXT",
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => TargetWeightSelector(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
