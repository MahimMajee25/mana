import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TopStack extends StatelessWidget {
  final VoidCallback? onTap;

  const TopStack({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: onTap ?? () {},
              child: Container(
                margin: EdgeInsets.only(top: 8),
                height: 48,
                width: 48,
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Color(0x10F3F4F1),
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset('assets/icons/arrow-left.svg'),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: SvgPicture.asset('assets/icons/emblem.svg')),
          ],
        ),
      ],
    );
  }
}
