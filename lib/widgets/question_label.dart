import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuestionLabel extends StatelessWidget {
  final String textLabel;

  const QuestionLabel({super.key, required this.textLabel});

  @override
  Widget build(BuildContext context) {
    return Text(
      textLabel.toUpperCase(),
      textAlign: TextAlign.center,
      style: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        height: 1.0,
        letterSpacing: -0.1,
        color: Colors.white,
      ),
    );
  }
}
