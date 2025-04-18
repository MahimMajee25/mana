import 'package:flutter/material.dart';

class DisplayChip extends StatelessWidget {
  final String number;
  final String unit;

  const DisplayChip({super.key, required this.number, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: const Color(0xFF968889), // light mauve-ish border
          width: 1,
        ),
        gradient: LinearGradient(
          colors: [Color(0xFF151515), Color(0xFF2B2B2B)],
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            number,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Color(0xFFF3F4F1),
            ),
          ),
          const SizedBox(width: 12),
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              unit,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
