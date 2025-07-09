import 'package:flutter/material.dart';
import 'package:height_weight/widgets/custom_slider.dart';
import 'package:height_weight/widgets/xSlider.dart';

class Slider1 extends StatefulWidget {
  const Slider1({super.key});

  @override
  State<Slider1> createState() => _Slider1State();
}

class _Slider1State extends State<Slider1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: VerticalRangeSelector(),
    );
  }
}
