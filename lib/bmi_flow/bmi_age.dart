import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:height_weight/widgets/display_chip.dart';
import 'package:height_weight/widgets/question_label.dart';
import 'package:height_weight/widgets/simple_ruler.dart';
import 'package:height_weight/widgets/submit_button.dart';
import 'package:height_weight/widgets/toggle_button.dart';
import 'package:height_weight/widgets/top_stack.dart';

class BMIAge extends StatefulWidget {
  const BMIAge({super.key});

  @override
  _BMIAgeState createState() => _BMIAgeState();
}

class _BMIAgeState extends State<BMIAge> {
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
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20, left: 16, right: 16),
        child: Column(
          children: [
            TopStack(
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 47),
            QuestionLabel(textLabel: "What is your age?"),
            SizedBox(height: 32),
            RoundedTextField(
              controller: TextEditingController(),
              suffixIcon: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Years",
                  style: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 16, color: Color(0x70F3F4F1)),
                ),
              ),
              textStyle: GoogleFonts.inter(fontWeight: FontWeight.w500,
                fontSize: 20,
                color: Color(0xFFF3F4F1),
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Years",
                  style: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 16, color: Color(0x00000000)),
                ),
              ),
            ),
            Spacer(),
            SubmitButton(submitText: "NEXT"),
            SizedBox(height: screenHeight < 700 ? 12 : 60),
          ],
        ),
      ),
    );
  }
}

class RoundedTextField extends StatefulWidget {
  final String hintText;
  final String? labelText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final Color textColor;
  final Color hintColor;
  final double borderRadius;
  final EdgeInsets contentPadding;
  final TextStyle? textStyle;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool enabled;
  final Widget? suffixIcon;
  final Widget? prefixIcon;

  const RoundedTextField({
    Key? key,
    required this.controller,
    this.hintText = '',
    this.labelText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.textColor = Colors.white,
    this.hintColor = const Color(0xFF8E8E93),
    this.borderRadius = 99999,
    this.contentPadding = const EdgeInsets.symmetric(vertical: 14.0),
    this.textStyle,
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.suffixIcon,
    this.prefixIcon,
  }) : super(key: key);

  @override
  State<RoundedTextField> createState() => _RoundedTextFieldState();
}

class _RoundedTextFieldState extends State<RoundedTextField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment(-0.4, -0.9),
          end: Alignment(0.6, 1.1),
          colors: [Color(0xFF151515), Color(0xFF2B2B2B)],
        ),
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(color: Color(0xFF968889), width: 1.0),
      ),
      child: TextFormField(
        controller: widget.controller,
        focusNode: _focusNode,
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText,
        enabled: widget.enabled,
        onChanged: widget.onChanged,
        validator: widget.validator,
        textAlign: TextAlign.center,
        style: widget.textStyle ?? TextStyle(color: widget.textColor, fontSize: 16.0, fontWeight: FontWeight.w400),
        decoration: InputDecoration(
          hintText: widget.hintText,
          labelText: widget.labelText,
          hintStyle: TextStyle(color: widget.hintColor, fontSize: 16.0, fontWeight: FontWeight.w400),
          labelStyle: TextStyle(color: widget.hintColor, fontSize: 16.0, fontWeight: FontWeight.w400),
          contentPadding: widget.contentPadding,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          suffixIcon: widget.suffixIcon,
          prefixIcon: widget.prefixIcon,
        ),
      ),
    );
  }
}
