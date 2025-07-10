import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubmitButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? submitText;

  const SubmitButton({super.key, this.onPressed,this.submitText});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFF0000),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 32),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(99999),
        ),
      ),
      onPressed: onPressed ?? () {},
      child: Text(
        submitText??"SUBMIT",
        style: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
